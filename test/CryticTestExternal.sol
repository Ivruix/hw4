// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/MyToken.sol";
import "@crytic/properties/ERC721/util/IERC721Internal.sol";
import "@crytic/properties/ERC721/external/properties/ERC721ExternalBasicProperties.sol";
import "@crytic/properties/ERC721/external/properties/ERC721ExternalBurnableProperties.sol";
import "@crytic/properties/ERC721/external/properties/ERC721ExternalMintableProperties.sol";
import "@crytic/properties/ERC721/external/util/MockReceiver.sol";

contract CryticERC721ExternalHarness is CryticERC721ExternalBasicProperties, CryticERC721ExternalBurnableProperties {
    constructor() {
        token = IERC721Internal(address(new ERC721Mock()));
        mockSafeReceiver = new MockReceiver(true);
        mockUnsafeReceiver = new MockReceiver(false);
    }
}

contract ERC721Mock is MyToken {
    address constant USER1 = address(0x10000);
    address constant USER2 = address(0x20000);
    address constant USER3 = address(0x30000);

    bool public isMintableOrBurnable;

    function _customMint(address to, uint256 amount) external {
        mint(to, amount);
    }

    constructor() {
        isMintableOrBurnable = true;
    }
}
