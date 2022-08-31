# Insts Design

When adding a new xa64 inst (a microop),
there are 3 runtime envrionments need to be treated carefully.

* x86: macroop => microops => execution
* bt: macroop => aot
* xa64: aot => microops => execution

---

The insts adding order follows insts layout in helloworld.

## push

Gem5 use stis (STore Implicit Stack) + sub microops to implement push.
The reason why implicit stack operation needs to be handle,
see gem5 commit 80ab796da9bd7341191eff8739587e6db189284b for details.
Here I copy and paste the commit message,

> x86: Fix implicit stack addressing in 64-bit mode
>
> When in 64-bit mode, if the stack is accessed implicitly by an instruction
> the alternate address prefix should be ignored if present.
>
> This patch adds an extra flag to the ldstop which signifies when the
> address override should be ignored. Then, for all of the affected
> instructions, this patch adds two options to the ld and st opcode to use
> the current stack addressing mode for all addresses and to ignore the
> AddressSizeFlagBit.  Finally, this patch updates the x86 TLB to not
> truncate the address if it is in 64-bit mode and the IgnoreAddrSizeFlagBit
> is set.
>
> This fixes a problem when calling __libc_start_main with a binary that is
> linked with a recent version of ld. This version of ld uses the address
> override prefix (0x67) on the call instruction instead of a nop.
>
> Note: This has not been tested in compatibility mode and only the call
> instruction with the address override prefix has been tested.
>
> See [1] page 9 (pdf page 45)
>
> For instructions that are affected see [1] page 519 (pdf page 555).
>
> [1] http://support.amd.com/TechDocs/24594.pdf
>
> Signed-off-by: Jason Lowe-Power <jason@lowepower.com>

TODO: Why is `stis` necessary?

Currently, for simplicity, I want to use sub and store to implement push.
For better performance (maybe), arm's post-index store is a good reference.

## call

* Arm: bl imm
* X86: call imm
* xa64: call imm, reg

  jump to pc+imm, store next pc to reg

This design worths, because arm `ret` can get return addr from user-specific reg.

## REP MOVS

in order to squeeze `rep movs` into 6 uops,

* loopcnt
* ld
* st
* hop
* loopend
* nop

`rep stos`

* loopcnt
* st
* step
* loopend
* nop

nop is a compromise of gem5 lastMicroop flags.
branch uop cannot be last microop in original gem5 design.
I don't want to restruct this, so I use a nop.
