# My Scripts

All scripts source code see:
[https://github.com/xieby1/xieby1.github.io/tree/main/src/scripts](https://github.com/xieby1/xieby1.github.io/tree/main/src/scripts)

## allfiles.sh

```
TLDR: un-hidden files
```

## asm.sh

```
TLDR: asm => bin
Usage: asm.sh [-h] <asm>
  Convert <asm> to machine code, by GNU assembler 'as'.
Symbol needs to be escaped:
  dolar (\$), hash tag (\#), simicolon (\;), slash (\\)
Example:
  asm.sh "int \$0x80"
  asm.sh "add \$12, %eax"
  asm.sh "nop\nnop"
  asm.sh "nop\;nop"
```

## ff.sh

```
TLDR: fuzzy find
```

## formatxml.sh

```
TLDR: format xml
```

## grep.sh

```
TLDR: my grep
```

## ldd-grep.sh

```
TLDR: gather dep so
Usage: ldd-grep.sh [-o DEST] [ FILE | DIR ]
  List the lib dependencies of FILE or files under DIR
  If FILE or DIR is not specified, '.' will be used
  If -o DEST is specifed, dependencies will be copied to DEST
```

## ls-git.sh

```
TLDR: ls files in git
```

## nbd-mount.sh

```
TLDR: nbd mount
Usage: nbd-mount.sh DISK_IMAGE [-o MOUNT_DIR]
  export DISK_IMAGE using the NBD protocol
  mount the nbd dev to MOUNT_DIR
  default MOUNT_DIR is c/, not create dir if c/ not exist
```

## pdbsf.sh

```
TLDR: pdb src file
```

## pdfbookmark.sh

```
TLDR: md <=> pdf toc
Usage:
  Extract Bookmarks from pdf: pdfbookmark.sh FILE.pdf [FILE.md]
  Update Bookmarks to pdf:  pdfbookmark.sh FILE.md FILE.pdf
```

## pwrThr.sh

```
TLDR: toggle pwrThr
```

## resize_gif.sh

```
TLDR: gif<=10M
Usage: resize_gif.sh <xxx.gif>
  Compress <xxx.gif> under and near 10M,
  output to <xxx.resized.gif>
```

## tar-repo.sh

```
TLDR: tar git files
Usage: tar-repo.sh [-h] <DIR>
  tar git repo <DIR>, exclude patterns from
  * global gitignore
  * repo's gitignore
  * repo's git/info/exclude
  output to <DIR>.tar.gz
```

## ubuntu.sh

```
TLDR: ubuntu container
Usage: ubuntu.sh [-h] [-c]
  run with no arg: enter a ubuntu container
  -c: reate a ubuntu container image
  -h: show this help
```
