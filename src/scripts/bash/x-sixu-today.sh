#!/usr/bin/env bash
YESTERDAY=$(LC_TIME=en_DK date --date="yesterday" +%y%b%d)
TODAY=$(LC_TIME=en_DK date +%y%b%d)
cat <<EOL
"${YESTERDAY}+" -> "${TODAY}-" -> "${TODAY}+";
subgraph cluster_${TODAY}
{
    x${TODAY}_
}
{rank=same; "${TODAY}-";
    x${TODAY}_
}
{rank=same; "${TODAY}+";
}
EOL
