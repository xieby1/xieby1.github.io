<div style="font-size:3em; text-align:right;">2019.10.21</div>

http://releases.llvm.org/1.0/docs/LangRef.html

Q：怎么处理内联汇编？

A：新版本里有了High-level structure来处理

在看了新版本的[LangRef](http://llvm.org/docs/LangRef.html)后，

Q：metadata是干什么的？

A：目前主要是用来传递debug信息，参考[What is LLVM metadata](https://stackoverflow.com/questions/19743861/what-is-llvm-metadata)和[LangRef#metadata](http://llvm.org/docs/LangRef.html#metadata)。

# Instruction Reference

1. **Terminator Intructions**
   1. ret
   2. br
   3. switch
   4. invoke
   5. unwind
2. **Binary Operations**
   6. add
   7. sub
   8. mul
   9. div
   10. rem
   11. setcc
3. **Bitwise Binary Operations**
   12. and
   13. or
   14. xor
   15. shl
   16. shr
4. **Memory Access Operations**
   17. malloc
   18. free
   19. alloca
   20. load
   21. store
   22. getelementptr
5. **Other Operations**
   23. phi
   24. cast ... to
   25. call
   26. vanext
   27. vaarg