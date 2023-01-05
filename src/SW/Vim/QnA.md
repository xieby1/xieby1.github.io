<div style="text-align:right; font-size:3em;">2021.07.07</div>

## 如何得知当前光标下的syntax组

[stack overflow: Find out to which highlight-group a particular keyword/symbol belongs in vim](https://stackoverflow.com/questions/1467438/find-out-to-which-highlight-group-a-particular-keyword-symbol-belongs-in-vim)

```
" adds to statusline
set laststatus=2
set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}

" a little more informative version of the above
# nmap <Leader>sI :call <SID>SynStack()<CR>
# nmap <C-S-P> :call <SID>SynStack()<CR>

function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
```

## syntax files

前言：为了修复.dot文件注释斜线超过2条，会影响后面行的问题

结论：缺少keepend参数，添加`~/.vim/after/syntax/dot.vim`覆盖`$VIMRUNTIME/syntax/dot.vim`的对“//”的定义即可。

* `:h :syn-files`
  * `:h mysyntaxfile` 新增syntax file
  * `:h mysyntaxfile-add` 在原有syntax file上修补
