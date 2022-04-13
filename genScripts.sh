#!/usr/bin/env bash

echo "# My Scripts"
for script in ./src/scripts/*.sh
do
    echo
    echo "## ${script##*/}"
    echo
    # echo -n "TLDR: "
    # ${script} -h | sed -z 's/\n/\n\n/g'
    echo "\`\`\`bash"
    echo "{{ #include ${script##*/} }}"
    echo "\`\`\`"
done
echo "{{ #include foot.html }}"
