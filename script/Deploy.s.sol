// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "forge-std/Script.sol";
import {Strings} from "openzeppelin/utils/Strings.sol";

interface ICreate2Deployer {
    function deploy(uint256 value, bytes32 salt, bytes memory code) external;
    function computeAddress(bytes32 salt, bytes32 codeHash) external view returns (address);
}

contract DeployBlockListRegistry is Script {
    using Strings for address;

    function run() public {
        // get environment variables
        ICreate2Deployer create2Deployer = ICreate2Deployer(vm.envAddress("CREATE2_DEPLOYER"));
        bytes memory constructorArgs = vm.envBytes("CONSTRUCTOR_ARGS");
        bytes32 salt = vm.envBytes32("SALT");

        // get bytecode
        bytes memory bytecode = abi.encodePacked(vm.getCode("BlockListRegistry.sol:BlockListRegistry"), constructorArgs);

        // deploy
        address deployedContract = create2Deployer.computeAddress(salt, keccak256(bytecode));
        vm.broadcast();
        create2Deployer.deploy(0, salt, bytecode);

        // save deployed contract address
        vm.writeLine("out.txt", deployedContract.toHexString());
    }
}

contract DeployBlockAllRegistry is Script {
    using Strings for address;

    function run() public {
        // get environment variables
        ICreate2Deployer create2Deployer = ICreate2Deployer(vm.envAddress("CREATE2_DEPLOYER"));
        bytes32 salt = vm.envBytes32("SALT");

        // get bytecode
        bytes memory bytecode = vm.getCode("BlockAllRegistry.sol:BlockAllRegistry");

        // deploy
        address deployedContract = create2Deployer.computeAddress(salt, keccak256(bytecode));
        vm.broadcast();
        create2Deployer.deploy(0, salt, bytecode);

        // save deployed contract address
        vm.writeLine("out.txt", deployedContract.toHexString());
    }
}