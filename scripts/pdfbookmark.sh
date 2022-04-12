#!/usr/bin/env bash

echoHelp() {
    echo "md <=> pdf toc"
    echo "Usage:"
    echo "  Extract Bookmarks from pdf: ${0##*/} FILE.pdf [FILE.md]" 
    echo "  Update Bookmarks to pdf:  ${0##*/} FILE.md FILE.pdf"
    exit 0
}

# default value
BKMRK="Bookmark"
BEGIN="${BKMRK}Begin"
TITLE="${BKMRK}Title"
LEVEL="${BKMRK}Level"
PGNUM="${BKMRK}PageNumber"
## markdown default value
INDENTNUM=2
INDENTSYM="*"
INDENTSYM_ESC="\*"
PGNUMDELIMIT="@"

# value
TITLEV=""
LEVELV=""
PGNUMV=""

pdfdata_to_markdown() {
    #for LINE in $1; do
    cat $1 | while read LINE; do
        #echo ${LINE}
        case ${LINE} in
            ${BEGIN}*)
                TITLEV=""
                LEVELV=""
                PGNUMV=""
                ;;
            ${TITLE}*)
                TITLEV=${LINE#"${TITLE}: "}
                ;;
            ${LEVEL}*)
                LEVELV=${LINE#"${LEVEL}: "}
                ;;
            ${PGNUM}*)
                PGNUMV=${LINE#"${PGNUM}: "}
                output=""
                while [[ ${#output} -lt $(((LEVELV - 1)*INDENTNUM)) ]]; do
                    output="${output} "
                done
                output="${output}${INDENTSYM} ${TITLEV} ${PGNUMDELIMIT}${PGNUMV}"
                echo -e "${output}"
                ;;
        esac
    done
}

markdown_to_pdfdata() {
    IFS=''
    cat $1 | while read LINE; do
    indentStr="${LINE%%${INDENTSYM_ESC}*}"
    indentStrLen="${#indentStr}"
    LEVELV=$((indentStrLen / INDENTNUM + 1))

    PGNUMV="${LINE##*${PGNUMDELIMIT}}"

    TITLEV="${LINE#*${INDENTSYM_ESC} }"
    TITLEV="${TITLEV%${PGNUMDELIMIT}*}"

    echo "${BEGIN}"
    echo "${TITLE}: ${TITLEV}"
    echo "${LEVEL}: ${LEVELV}"
    echo "${PGNUM}: ${PGNUMV}"
done
}

# main function
FILE1=""
FILE2=""

while [[ ${OPTIND} -le $# ]]; do
    getopts "h" opt
    case "${opt}" in
        h)
            echoHelp
            ;;
        ?)
            if [[ -z ${FILE1} ]]; then
                FILE1=${!OPTIND}
            elif [[ -z ${FILE2} ]]; then
                FILE2=${!OPTIND}
            else
                echoHelp
            fi
            shift
            ;;
    esac
done

## create temporary directory
tempDir="/dev/shm/${0##*/}"
if [[ ! -d ${tempDir} ]]; then
    mkdir ${tempDir}
fi

## check input files
if [[ -z ${FILE1} ]]; then
    echoHelp
fi
if [[ -z ${FILE2} ]]; then
    FILE2=${FILE1%.*}.md
fi

tempFile=${tempDir}/${FILE2##*/}
tempFile=${tempFile%.*}
if [[ ${FILE1##*.} == "md" ]]; then
### md to pdf
    pdftk ${FILE2} dump_data_utf8 output ${tempFile}.dumpdata

    #### clear bookmark info
    grep -v "${BKMRK}" ${tempFile}.dumpdata > ${tempFile}.cleardata
    cp ${tempFile}.cleardata ${tempFile}.newdata

    #### append bookmark info
    markdown_to_pdfdata ${FILE1} >> ${tempFile}.newdata
    pdftk ${FILE2} update_info ${tempFile}.newdata output ${FILE2%.*}.toc.pdf
elif [[ ${FILE2##*.} == "md" ]]; then
    pdftk ${FILE1} dump_data_utf8 output ${tempFile}.dumpdata

    pdfdata_to_markdown ${tempFile}.dumpdata > ${FILE2}
else
    echoHelp
fi

## clear tempDir
#rm -r ${tempDir}
