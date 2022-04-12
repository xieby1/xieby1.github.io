# My Scripts

All scripts source code see:
[https://github.com/xieby1/xieby1.github.io/tree/main/src/scripts](https://github.com/xieby1/xieby1.github.io/tree/main/src/scripts)

## allfiles.sh

```bash
TLDR: un-hidden files
```

## asm.sh

```bash
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

```bash
TLDR: fuzzy find
```

## formatxml.sh

```bash
TLDR: format xml
```

## grep.sh

```bash
TLDR: my grep
```

## ldd-grep.sh

```bash
TLDR: gather dep so
Usage: ldd-grep.sh [-o DEST] [ FILE | DIR ]
  List the lib dependencies of FILE or files under DIR
  If FILE or DIR is not specified, '.' will be used
  If -o DEST is specifed, dependencies will be copied to DEST
```

## ls-git.sh

```bash
TLDR: ls files in git
```

## nbd-mount.sh

```bash
TLDR: nbd mount
Usage: nbd-mount.sh DISK_IMAGE [-o MOUNT_DIR]
  export DISK_IMAGE using the NBD protocol
  mount the nbd dev to MOUNT_DIR
  default MOUNT_DIR is c/, not create dir if c/ not exist
```

## pdbsf.sh

```bash
TLDR: pdb src file
```

## pdfbookmark.sh

```bash
TLDR: md <=> pdf toc
Usage:
  Extract Bookmarks from pdf: pdfbookmark.sh FILE.pdf [FILE.md]
  Update Bookmarks to pdf:  pdfbookmark.sh FILE.md FILE.pdf
```

## pwrThr.sh

```bash
TLDR: toggle pwrThr
```

## resize_gif.sh

```bash
TLDR: gif<=10M
Usage: resize_gif.sh <xxx.gif>
  Compress <xxx.gif> under and near 10M,
  output to <xxx.resized.gif>
```

## tar-repo.sh

```bash
TLDR: tar git files
Usage: tar-repo.sh [-h] <DIR>
  tar git repo <DIR>, exclude patterns from
  * global gitignore
  * repo's gitignore
  * repo's git/info/exclude
  output to <DIR>.tar.gz
```

## ubuntu.sh

```bash
TLDR: ubuntu container
Usage: ubuntu.sh [-h] [-c]
  run with no arg: enter a ubuntu container
  -c: reate a ubuntu container image
  -h: show this help
```
