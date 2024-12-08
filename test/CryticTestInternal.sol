// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@crytic/properties/ERC721/internal/properties/ERC721BasicProperties.sol";
import "@crytic/properties/ERC721/internal/properties/ERC721BurnableProperties.sol";
import "@crytic/properties/ERC721/internal/properties/ERC721MintableProperties.sol";
import "../src/MyToken.sol";

contract CryticERC721InternalHarness is
    MyToken,
    CryticERC721BasicProperties,
    CryticERC721BurnableProperties,
    CryticERC721MintableProperties
{
    using Address for address;

    constructor() {
        isMintableOrBurnable = true;
        safeReceiver = new MockReceiver(true);
        unsafeReceiver = new MockReceiver(false);
    }

    function _customMint(address to, uint256 amount) internal virtual override {
        mint(to, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        virtual
        override(MyToken, CryticERC721TestBase, CryticERC721BurnableProperties)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(MyToken, CryticERC721TestBase, CryticERC721BurnableProperties)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
