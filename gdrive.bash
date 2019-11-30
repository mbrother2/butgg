#!/bin/bash
BUTGG_DIR="${HOME}/.butgg"
BUTGG_CONF="${HOME}/.butgg/butgg.conf"
GDRIVE_API="https://www.googleapis.com/drive/v3"
DF_PARENTS_ID="root"
FIRST_OPTION=$1
SECOND_OPTION=$2
THIRD_OPTION=$3

if [ ! -d "${BUTGG_DIR}" ]
then
    mkdir ${BUTGG_DIR}
fi

loop_dir(){
    IFS=$'\n'
    for i in $(ls -1 "$1")
    do
        REAL_PATH=`realpath "$1/$i"`
        DIR_DEPTH=`echo ${REAL_PATH} | grep -o "/" | wc -l`
        DIR_DEPTH2=`expr ${DIR_DEPTH} - 1`
        if [ -d "${REAL_PATH}" ]
        then
            echo "Creating directory $i..."
            _mkdir "$i" ${!PR_ID_NAME} >/dev/null
            PARENTS_ID=${FOLDER_ID}
            PR_ID_NAME="PARENTS_ID${DIR_DEPTH}"
            eval "$PR_ID_NAME"="$PARENTS_ID"
            loop_dir ${REAL_PATH}
        else
            PR_ID_NAME="PARENTS_ID${DIR_DEPTH2}"
            echo "Uploading file $i..."
            curl -s -X POST -L \
                    -H "Authorization: Bearer ${GG_TOKEN}" \
                    -F "metadata={name: \"$i\", parents: [\"${!PR_ID_NAME}\"]};type=application/json;charset=UTF-8" \
                    -F "file=@${REAL_PATH}" \
                    https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart >/dev/null
        fi
    done
}

create_token(){
    if [ -f "${BUTGG_DIR}/butgg.conf" ]
    then
        GG_CLIENT_ID=`cat ${BUTGG_DIR}/butgg.conf | grep CLIENT_ID | cut -d"=" -f2`
        GG_CLIENT_SECRET=`cat ${BUTGG_DIR}/butgg.conf | grep CLIENT_SECRET | cut -d"=" -f2`
        if [[ ${GG_CLIENT_ID} == "" ]] || [[ ${GG_CLIENT_SECRET} == "" ]]
        then
            echo "Read more: https://github.com/mbrother2/backuptogoogle/wiki/Create-own-Google-credential-step-by-step"
            read -p " Your Google API client_id: " GG_CLIENT_ID
            read -p " Your Google API client_secret: " GG_CLIENT_SECRET
            sed -i "/^GG_CLIENT_ID/d" ${BUTGG_DIR}/butgg.conf
            sed -i "/^GG_CLIENT_SECRET/d" ${BUTGG_DIR}/butgg.conf
            echo "GG_CLIENT_ID=${GG_CLIENT_ID}" >> ${BUTGG_DIR}/butgg.conf
            echo "GG_CLIENT_SECRET=${GG_CLIENT_SECRET}" >> ${BUTGG_DIR}/butgg.conf
        fi
    else
        echo "Read more: https://github.com/mbrother2/backuptogoogle/wiki/Create-own-Google-credential-step-by-step"
        read -p " Your Google API client_id: " GG_CLIENT_ID
        read -p " Your Google API client_secret: " GG_CLIENT_SECRET
        echo "GG_CLIENT_ID=${GG_CLIENT_ID}" >> ${BUTGG_DIR}/butgg.conf
        echo "GG_CLIENT_SECRET=${GG_CLIENT_SECRET}" >> ${BUTGG_DIR}/butgg.conf
    fi
    echo ""
    echo "Authentication needed"
    echo "Go to the following url in your browser:"
    echo "https://accounts.google.com/o/oauth2/auth?access_type=offline&client_id=${GG_CLIENT_ID}&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&response_type=code&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive&state=state"
    echo ""
    read -p "Enter verification code: " GG_VERIFY_CODE
    
    echo "Generating token file..."
    curl -s -X POST \
            --data "code=${GG_VERIFY_CODE}&client_id=${GG_CLIENT_ID}&client_secret=${GG_CLIENT_SECRET}&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code&access_type=offline" \
            https://accounts.google.com/o/oauth2/token \
            -o ${BUTGG_DIR}/token.json
    TOKEN_START=`date +%s`
    TOKEN_END=`expr $TOKEN_START + 3600`
    TIME_END=`date -d @${TOKEN_END} --rfc-3339=seconds`
    sed -i "s/.*\"expires_in\":.*/\ \ \"expires_in\": \"${TIME_END}\",/" ${BUTGG_DIR}/token.json
}

get_token(){
    if [ ! -f "${BUTGG_DIR}/token.json" ]
    then
        create_token
    else
        GG_TOKEN=`cat ${BUTGG_DIR}/token.json | grep access_token | cut -d'"' -f4`
        if [ "${GG_TOKEN}" == "" ]
        then
            create_token
            GG_TOKEN=`cat ${BUTGG_DIR}/token.json | grep access_token | cut -d'"' -f4`
        fi
    fi
}

refresh_token(){
    get_token
    TOKEN_END=`cat ${BUTGG_DIR}/token.json | grep expires_in | cut -d'"' -f4`
    TOKEN_END=`date -d "${TOKEN_END}" +%s`
    TIME_NOW=`date +%s`
    CHECK_TIME=`expr ${TOKEN_END} - ${TIME_NOW} - 5`
    if [ ${CHECK_TIME} -lt 0 ]
    then
        TOKEN_END=`expr ${TIME_NOW} + 3600`
        TIME_END=`date -d @${TOKEN_END} --rfc-3339=seconds`
        GG_REFRESH_TOKEN=`cat ${BUTGG_DIR}/token.json | grep refresh_token | cut -d'"' -f4`
        GG_CLIENT_ID=`cat ${BUTGG_DIR}/butgg.conf | grep CLIENT_ID | cut -d"=" -f2`
        GG_CLIENT_SECRET=`cat ${BUTGG_DIR}/butgg.conf | grep CLIENT_SECRET | cut -d"=" -f2`
        curl -s -X POST https://accounts.google.com/o/oauth2/token \
                --data "client_id=${GG_CLIENT_ID}&client_secret=${GG_CLIENT_SECRET}&refresh_token=${GG_REFRESH_TOKEN}&grant_type=refresh_token" -o ${BUTGG_DIR}/token.json
        sed -i "/.*\"scope\":.*/i \ \ \"refresh_token\": \"${GG_REFRESH_TOKEN}\"," ${BUTGG_DIR}/token.json
        sed -i "s/.*\"expires_in\":.*/\ \ \"expires_in\": \"${TIME_END}\",/" ${BUTGG_DIR}/token.json
    fi
}

check_info(){
    CHECK_INFO=`_info name "$1"` 
    if [ $? -ne 0 ]
    then
        echo "${CHECK_INFO}"
        exit 1
    fi
}

_about(){
    GD_EMAIL=`curl -s "${GDRIVE_API}/about?fields=user" -H "Authorization: Bearer ${GG_TOKEN}" -H "Accept: application/json" --compressed | grep emailAddress | cut -d'"' -f4`
    GD_LIMIT=`curl -s "${GDRIVE_API}/about?fields=storageQuota" -H "Authorization: Bearer ${GG_TOKEN}" -H "Accept: application/json" --compressed | grep "\"limit\"" | cut -d'"' -f4`
    GD_USAGE=`curl -s "${GDRIVE_API}/about?fields=storageQuota" -H "Authorization: Bearer ${GG_TOKEN}" -H "Accept: application/json" --compressed | grep "\"usage\"" | cut -d'"' -f4`
    if [ ${GD_USAGE} -ge 1099511627776 ]
    then
        GD_USAGE2=`awk "BEGIN {printf \"%.2f\n\", ${GD_USAGE} / 1099511627776}"`" TB"
    elif [ ${GD_USAGE} -ge 1073741824 ]
    then
        GD_USAGE2=`awk "BEGIN {printf \"%.2f\n\", ${GD_USAGE} / 1073741824}"`" GB"
    elif [ ${GD_USAGE} -ge 1048576 ]
    then
        GD_USAGE2=`awk "BEGIN {printf \"%.2f\n\", ${GD_USAGE} / 1048576}"`" MB"
    elif [ ${GD_USAGE} -ge 1024 ]
    then
        GD_USAGE2=`awk "BEGIN {printf \"%.2f\n\", ${GD_USAGE} / 1024}"`" KB"
    else
        GD_USAGE2="${GD_USAGE} B"
    fi
    GD_FREE=`awk "BEGIN {printf \"%.2f\n\", (${GD_LIMIT} - ${GD_USAGE}) / 1073741824}"`
    GD_LIMIT=`awk "BEGIN {printf \"%.2f\n\", ${GD_LIMIT} / 1073741824}"`
    echo "Email: ${GD_EMAIL}"
    echo "Total: ${GD_LIMIT} GB"
    echo "Used : ${GD_USAGE2}"
    echo "Free : ${GD_FREE} GB"
}

_upload(){
    if [ -z "$2" ]
    then
        PARENTS_ID="${DF_PARENTS_ID}"
    else
        PARENTS_ID="$2"
    fi
    check_info "${PARENTS_ID}"
    REAL_PATH=`realpath "$1"`
    FILE_NAME=`echo $1 | grep -o '[^/]*$'`
    if [ -d "${REAL_PATH}" ]
    then
        echo "Creating directory ${FILE_NAME}..."
        DIR_DEPTH=`echo "${REAL_PATH}" | grep -o "/" | wc -l`
        _mkdir "${FILE_NAME}" "${PARENTS_ID}" >/dev/null
        PARENTS_ID=${FOLDER_ID}
        PR_ID_NAME="PARENTS_ID${DIR_DEPTH}"
        eval "$PR_ID_NAME"="$PARENTS_ID"
        loop_dir "${REAL_PATH}"
    else
        echo "Uploading file ${FILE_NAME}..."
        curl -s -X POST -L https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart \
                -H "Authorization: Bearer ${GG_TOKEN}" \
                -F "metadata={name: \"${FILE_NAME}\", parents: [\"${PARENTS_ID}\"]};type=application/json;charset=UTF-8" \
                -F "file=@${REAL_PATH}" >/dev/null
    fi
}

_list(){  
    if [ -z "$2" ]
    then
        echo "Missing file ID"
        exit 1
    elif [ "$1" == "all" ]
    then
        MIMETYPE=""
    elif [ "$1" == "dir" ]
    then
        MIMETYPE="+and+mimeType+=+'application/vnd.google-apps.folder'"
    elif [ "$1" == "file" ]
    then
        MIMETYPE="+and+mimeType+!=+'application/vnd.google-apps.folder'"
    else
        echo "Do not support option $1"
        exit 1
    fi
    check_info "$2"
    for i in $(curl -s "${GDRIVE_API}/files?q=\"$2\"+in+parents+and+trashed=false${MIMETYPE}" -H "Authorization: Bearer ${GG_TOKEN}" -H "Accept: application/json" --compressed | grep "\"id\":" | cut -d'"' -f4)
    do
        NAME=`curl -s "${GDRIVE_API}/files/$i" -H "Authorization: Bearer ${GG_TOKEN}" -H "Accept: application/json" --compressed | grep "\"name\":" | cut -d'"' -f4`
        echo "$i ${NAME}"
    done
}

_mkdir(){
    if [ -z "$2" ]
    then
        PARENTS_ID="root"
    else
        PARENTS_ID="$2" 
    fi
    check_info "${PARENTS_ID}"
    FOLDER_ID=`curl -s -X POST ${GDRIVE_API}/files -H "Authorization: Bearer ${GG_TOKEN}" -H 'Content-Type: application/json' --data "{name: \"$1\",mimeType: \"application/vnd.google-apps.folder\",parents: [\"${PARENTS_ID}\"]}" --compressed | grep "\"id\":" | cut -d'"' -f4`
    if [ -z "{FOLDER_ID}" ]
    then
        echo "Can not create file $1"
        exit 1
    else
        echo "${FOLDER_ID}"
    fi
}

_delete(){
    check_info "$1"
    DELETE_FILE=`curl -s -X DELETE ${GDRIVE_API}/files/$1 -H "Authorization: Bearer ${GG_TOKEN}" -H 'Content-Type: application/json' --compressed`
    if [ -z "${DELETE_FILE}" ]
    then
        echo "Deleted file ID $1"
    else
        echo "${DELETE_FILE}"
        exit 1
    fi
}

_info(){
    if [ -z "$2" ]
    then
        echo "Missing file ID"
        exit 1
    elif [[ "$1" == "name" ]] || [[ "$1" == "mimeType" ]]
    then
        FILE_INFO=`curl -s "${GDRIVE_API}/files/$2" -H "Authorization: Bearer ${GG_TOKEN}" | grep "\"$1\":" | cut -d'"' -f4`
    elif [ "$1" == "trashed" ]
    then
        FILE_INFO=`curl -s "${GDRIVE_API}/files/$2?fields=trashed" -H "Authorization: Bearer ${GG_TOKEN}" | grep "\"$1\":" | cut -d' ' -f3`
    else
        echo "Do not support option $1"
        exit 1
    fi
    if [ "${FILE_INFO}" == "" ]
    then
        echo "Can not find file ID ${FILE_ID}"
        exit 1
    else
        echo "${FILE_INFO}"
    fi
}

_download(){
    FILE_TYPE=`_info mimeType "$1"`
    if [ ${FILE_TYPE} == "application/vnd.google-apps.folder" ]
    then
        echo "Do not support download directory"
        exit 1
    fi
    FILE_NAME=`_info name "$1"`
    echo "Downloading file $1..."
    curl -s "${GDRIVE_API}/files/$1?alt=media" -H "Authorization: Bearer ${GG_TOKEN}" -o "${FILE_NAME}"
}

_help(){
    echo "gdrive.bash - Simple upload to Google Drive use curl"
    echo ""
    echo "Usage: gdrive.bash [options] [command] [file ID]"
    echo ""
    echo "Options:"
    echo "  --about      show Google account informations"
    echo "  --upload     upload to Google Drive"
    echo "  --list       list directory and file"
    echo "    all        list all directory and file"
    echo "    dir        list directory only"
    echo "    file       list file only"
    echo "  --mkdir      create directory on Google Drive"
    echo "  --delete     delete file or directory on Google Drive"
    echo "  --info       show info of file"
    echo "    name       show name only"
    echo "    mimeType   show mimeType only"
    echo "    trashed    show file in trash or not"
    echo "  --download   download file. Not download directory"
    echo "  --help       show this help message and exit"
}

refresh_token
get_token

case ${FIRST_OPTION} in
    --about)    _about;;
    --upload)   _upload   "${SECOND_OPTION}" "${THIRD_OPTION}";;
    --list)     _list     "${SECOND_OPTION}" "${THIRD_OPTION}";;
    --mkdir)    _mkdir    "${SECOND_OPTION}" "${THIRD_OPTION}";;
    --delete)   _delete   "${SECOND_OPTION}";;
    --info)     _info     "${SECOND_OPTION}" "${THIRD_OPTION}";;
    --download) _download "${SECOND_OPTION}";;
    --help)     _help;;
    *)        echo "Not support option ${FIRST_OPTION}"; _help;;
esac
