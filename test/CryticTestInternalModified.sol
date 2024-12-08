// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@crytic/properties/ERC721/internal/properties/ERC721BasicProperties.sol";
import "@crytic/properties/ERC721/internal/properties/ERC721BurnableProperties.sol";
import "@crytic/properties/ERC721/internal/properties/ERC721MintableProperties.sol";
import "../src/MyTokenModified.sol";

contract CryticERC721InternalHarness is
    MyTokenModified,
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
        override(MyTokenModified, CryticERC721TestBase, CryticERC721BurnableProperties)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(MyTokenModified, CryticERC721TestBase, CryticERC721BurnableProperties)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function ownerOf(uint256 tokenId)
        public
        view
        virtual
        override(MyTokenModified, ERC721, IERC721)
        returns (address)
    {
        return super.ownerOf(tokenId);
    }

    function balanceOf(address owner)
        public
        view
        virtual
        override(MyTokenModified, ERC721, IERC721) returns (uint256)
    {
        return super.balanceOf(owner);
    }

    function _transfer(address from, address to, uint256 tokenId)
        internal
        virtual
        override(MyTokenModified, ERC721)
    {
        super._transfer(from, to, tokenId);
    }
}
