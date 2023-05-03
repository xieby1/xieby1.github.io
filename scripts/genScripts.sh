#!/usr/bin/env bash

echo "# My Scripts"
echo
echo "## Bash Scripts"
for script in ./src/scripts/bash/*.sh
do
    echo
    echo "### ${script##*/}"
    echo
    # echo -n "TLDR: "
    # ${script} -h | sed -z 's/\n/\n\n/g'
    echo "\`\`\`bash"
    echo "{{ #include bash/${script##*/} }}"
    echo "\`\`\`"
done
echo
echo "## Nix Scripts"
for script in $(find ./src/scripts/nix -name "*.nix")
do
    echo
    echo "### ${script##*/}"
    echo
    # echo -n "TLDR: "
    # ${script} -h | sed -z 's/\n/\n\n/g'
    echo "\`\`\`nix"
    echo "{{ #include nix/${script##*nix/} }}"
    echo "\`\`\`"
done
echo "{{ #include foot.html }}"
