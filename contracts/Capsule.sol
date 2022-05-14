// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";

contract Capsule is KeeperCompatibleInterface {
    uint timestamp;
    address payable depositer;

    function deposit(uint _lockedUntil) external payable {
        require(timestamp == 0);
        timestamp = _lockedUntil;
        depositer = payable(msg.sender);
    }

    function checkUpkeep(bytes calldata) external view override returns (bool upkeepNeeded, bytes memory) {
        upkeepNeeded = timestamp > 0 && block.timestamp > timestamp;
    }

    function performUpkeep(bytes calldata) external override {
        require(block.timestamp > timestamp);
        depositer.transfer(address(this).balance);
        delete timestamp;
    }   
}