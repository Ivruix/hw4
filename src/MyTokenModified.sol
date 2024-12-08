// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyTokenModified is ERC721, ERC721Enumerable, ERC721Burnable, Ownable {
    uint256 public counter;

    constructor() ERC721("MyTokenModified", "MTKM") {}

    function mint(address to, uint256 amount) public {
        for (uint256 i; i < amount; i++) {
            _mint(to, counter++);
        }
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        virtual
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function ownerOf(uint256 tokenId)
        public
        view
        virtual
        override(ERC721, IERC721)
    returns (address) {
        address owner = _ownerOf(tokenId);
        return owner;
    }

    function balanceOf(address owner)
        public
        view
        virtual
        override(ERC721, IERC721)
    returns (uint256) {
        return _balances[owner];
    }

    function _transfer(address from, address to, uint256 tokenId)
        internal
        virtual
        override
    {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId, 1);

        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");

        unchecked {
            _balances[from] -= 1;
            _balances[to] += 1;
        }
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        _afterTokenTransfer(from, to, tokenId, 1);
    }
}
