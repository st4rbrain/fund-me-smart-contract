// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script{
    // Use mocks when on a local Anvil chain
    // Use relevant address when on a live network

    // struct to return a whole bunch of stuff like Price Feed address, vrf address, gas price
    struct NetworkConfig {
        address priceFeed;
    }

    NetworkConfig private activeNetworkConfig;
    uint8 constant DECIMALS = 8;
    int256 constant INITIAL_PRICE = 2000e8;


    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else if (block.chainid == 80001) {
            activeNetworkConfig = getPolygonMumbaiConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }
    

    function getSepoliaEthConfig() public pure returns(NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns(NetworkConfig memory) {
        NetworkConfig memory ethConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return ethConfig;
    }

    function getMainnetPolygonConfig() public pure returns(NetworkConfig memory) {
        NetworkConfig memory ethConfig = NetworkConfig({
            priceFeed: 0xAB594600376Ec9fD91F8e885dADF0CE036862dE0
        });
        return ethConfig;
    }

    function getPolygonMumbaiConfig() public pure returns(NetworkConfig memory) {
        NetworkConfig memory polygonMumbaiConfig = NetworkConfig({
            priceFeed: 0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada
        });
        return polygonMumbaiConfig;
    }

    function getOrCreateAnvilEthConfig() public returns(NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) return activeNetworkConfig;
        // Deploy the mocks
        // return the mock address

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }

    // getter functions
    function getActiveNetworkConfig() external view returns(NetworkConfig memory) {
        return activeNetworkConfig;
    }

}