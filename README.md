#  Выполнил

Каверин Максим, БПИ217

# Изменения

## Изменение 1

Функкция `ownerOf` была:

```
address owner = _ownerOf(tokenId);
require(owner != address(0), "ERC721: invalid token ID");
return owner;
```

Стала:

```
address owner = _ownerOf(tokenId);
return owner;
```

## Изменение 2

Функкция `balanceOf` была:

```
require(owner != address(0), "ERC721: address zero is not a valid owner");
return _balances[owner];
```

Стала:

```
return _balances[owner];
```

## Изменение 3

Функкция `_transfer` была:

```
require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
require(to != address(0), "ERC721: transfer to the zero address");

_beforeTokenTransfer(from, to, tokenId, 1);

require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");

delete _tokenApprovals[tokenId];

unchecked {
    _balances[from] -= 1;
    _balances[to] += 1;
}
_owners[tokenId] = to;

emit Transfer(from, to, tokenId);

_afterTokenTransfer(from, to, tokenId, 1);
```

Стала (нет `delete _tokenApprovals[tokenId]`):

```
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
```

# Запуск фаззера

 Для обычного ERC721:

```
echidna ./test/CryticTestInternal.sol --contract CryticERC721InternalHarness --config ./configs/echidna-config-internal.yaml
```

```
echidna ./test/CryticTestExternal.sol --contract CryticERC721ExternalHarness --config ./configs/
echidna-config-external.yaml
```

Для модифицированного ERC721:

```
echidna ./test/CryticTestInternalModified.sol --contract CryticERC721InternalHarness --config ./c
onfigs/echidna-config-internal-modified.yaml
```

```
echidna ./test/CryticTestExternalModified.sol --contract CryticERC721ExternalHarness --config ./
configs/echidna-config-external-modified.yaml
```


# Описание нарушенных свойств

## Свойство 1

**Название:** ownerOfInvalidTokenMustRevert

**Почему нарушено:** Нет проверки на нулевой адрес. Из-за этого функция завершается успешно, хотя не должна.

**Номер виновнoго изменения:** 1

## Свойство 2

**Название:** burnRevertOnOwnerOf

**Почему нарушено:** Нет проверки на нулевой адрес. Из-за этого получается получить владельца сожженного токена, что не должно происходить.

**Номер виновнoго изменения:** 1

## Свойство 3

**Название:** balanceOfZeroAddressMustRevert

**Почему нарушено:** Нет проверки на нулевой адрес. Из-за этого функция завершается успешно, хотя не должна.

**Номер виновнoго изменения:** 2

## Свойство 4

**Название:** transferFromResetApproval

**Почему нарушено:** После совершения перевода одобрение не убирается, а должно.

**Номер виновнoго изменения:** 3

## Свойство 5

**Название:** transferFromSelfResetsApproval

**Почему нарушено:** Аналогично, но только перевод самому себе.

**Номер виновнoго изменения:** 3