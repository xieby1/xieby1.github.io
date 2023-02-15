#!/usr/bin/env bash
# input: the file (or diretory) to be examed,
# output: its (or files under the directory, recursively) depending lib

# default value
TARGET=.

while [[ ${OPTIND} -le $# ]]; do
    getopts "ho:" opt
    case "${opt}" in
        h)
            echo "gather dep so"
            echo "Usage: ${0##*/} [-o DEST] [ FILE | DIR ]"
            echo "  List the lib dependencies of FILE or files under DIR"
            echo "  If FILE or DIR is not specified, '.' will be used"
            echo "  If -o DEST is specifed, dependencies will be copied to DEST"
            exit 0
            ;;
        o)
            if [[ -e ${OPTARG} ]]; then
                if [[ -d ${OPTARG} ]]; then
                    DEST_DIR=${OPTARG}
                else
                    echo "-o ${OPTARG} should be a directory"
                    exit 1
                fi
            else
                echo "${OPTARG} not exists"
                exit 1
            fi
            ;;
        ?)
            TARGET=${!OPTIND}
            shift
            ;;
        *)
            echo "unknown options arg${OPTIND} ${OPTARG}"
            exit 1
            ;;
    esac
done

ldd_real_path()
{
    ldd "$1" 2> /dev/null | while read Line; do
        # start with /
        if [[ $Line =~ ^\s*\/ ]]; then
            echo ${Line%% *}
        else
            _temp=${Line##*=> }
            echo ${_temp%% *}
        fi
    done

    # ldd "$1" 2> /dev/null |\
    #     sed 's/.*=>//' |\
    #     grep -E -o '\/.*\s' |\
    #     sed 's/\s//'
}

get_dependencies()
{
    if [[ -z ${DEST_DIR} ]]; then
        ldd_real_path $1
    else
        ldd_real_path $1 | while read DEP; do
            LIB_NEW_PATH="${DEST_DIR}/${DEP#/}"
            LIB_NEW_DIR="${LIB_NEW_PATH%/*}/"
            mkdir -p ${LIB_NEW_DIR}
            cp -n -v ${DEP} ${LIB_NEW_DIR}
        done
    fi
}

echo "ldd-grep from ${TARGET} to ${DEST_DIR}"

if [[ -d ${TARGET} ]]; then
    for FILE in $(find ${TARGET} -type f); do
        get_dependencies ${FILE}
    done
elif [[ -f ${TARGET} ]]; then
    get_dependencies ${TARGET}
fi
