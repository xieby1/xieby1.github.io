# My Scripts

## allfiles.sh

```bash
un-hidden files
```

## asm.sh

```bash
asm => bin
asm.sh [-h] <asm>
Convert <asm> to machine code, by as
Escape Note:
  hash tag (#), simicolon (;), slash (\)
Example:
  asm.sh "int \$0x80"
  asm.sh "add \$12, %eax"
  asm.sh "nop\nnop"
  asm.sh "nop\;nop"
```

## ff.sh

```bash
fuzzy find
```

## formatxml.sh

```bash
format xml
```

## grep.sh

```bash
my grep
```

## ldd-grep.sh

```bash
gather dep so
Usage: ldd-grep.sh [-o DEST] [ FILE | DIR ]

  List the lib dependencies of FILE or files under DIR
  If FILE or DIR is not specified, '.' will be used
  If -o DEST is specifed, dependencies will be copied to DEST
```

## ls-git.sh

```bash
ls files in git
```

## nbd-mount.sh

```bash
nbd mount
Usage: nbd-mount.sh DISK_IMAGE [-o MOUNT_DIR]

  export DISK_IMAGE using the NBD protocol
  mount the nbd dev to MOUNT_DIR
  default MOUNT_DIR is c/, not create dir if c/ not exist
```

## pdbsf.sh

```bash
pdb src file
```

## pdfbookmark.sh

```bash
md <=> pdf toc
Usage:
  Extract Bookmarks: pdfbookmark.sh FILE.pdf [FILE.md]
  Update Bookmarks:  pdfbookmark.sh FILE.md FILE.pdf
```

## pwrThr.sh

```bash
toggle pwrThr
```

## resize_gif.sh

```bash
gif<=10M
Usage:
  resize_gif.sh <xxx.gif>

Compress <xxx.gif> under and near 10M
output to <xxx.resized.gif>
```

## tar-repo.sh

```bash
tar git files
tar-repo.sh [-h] <DIR>
tar git repo <DIR>, exclude patterns from
  * global gitignore
  * repo's gitignore
  * repo's git/info/exclude
output to DIR.tar.gz
```

## ubuntu.sh

```bash
ubuntu container
Usage: ubuntu.sh [-h] [-c]
  run with no arg: enter a ubuntu container
  -c: reate a ubuntu container image
  -h: show this help
```
