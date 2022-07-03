# XA64 MANUAL

## Uop slot

![](./pictures/manual_uop_slot.svg)

## Ucache

### L1 uache

N-way associated.

![](./pictures/manual_l1ucahe.svg)

## Encoding

### Operand Extension and Size

One instruction contains one 5-bit field,
representing the operand extension and size.

* Extension (2 bits)
  * Zero
  * Signed
  * M? without modification other bits
* Size (3 bits)
  * Low
  * High
  * Word
  * Double word
  * Quadruple word

Macroop with H & L, needs to be decoded to shift and corresponding microop.
E.g. mov al, ah => shr tmp, ah, 8; mov al, tmp

### arithmetic flags

There is bit in encoding,
presenting whether arithmetic flags need to be calculated. 

### Immediate

Immediate is saved along with uops in uop slot.

Immediate is access by 5-bit field

```
[0b00000]:          reserved
[0b00001]:          1 64-bit imm
[0b00010, 0b00011]: 2 32-bit imm
[0b00100, 0b00111]: 4 16-bit imm
[0b01000, 0b01111]: 8  8-bit imm
[0b10000, 0b11111]: 16 4-bit imm
```