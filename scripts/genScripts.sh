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
