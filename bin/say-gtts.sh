#!/bin/bash
#
#

GTTSBIN="gtts-cli"
PLAYER="mpg123"
UAGENT="Mozilla/5.0 (X11; Linux x86_64; rv:42.0) Gecko/20100101 Firefox/42.0"
readonly LNG=${LNG:=de}
readonly URL="http://translate.google.com/translate_tts?ie=UTF-8&total=1&idx=0&client=t&tl=${LNG}&q="
readonly STOCK="$HOME/.${0##*/}"
#readonly STOCK="${HOME}/.${0##*/}"

which $PLAYER &>/dev/null || {
  echo "error: $PLAYER not installed"
  exit
}

which ffmpeg &>/dev/null || {
  echo "error: ffmpeg not installed"
  exit
}

which wget &>/dev/null || {
  echo "error: wget not installed"
  exit
}

[ -d "${STOCK}/${LNG}" ] || {
  mkdir -p "${STOCK}/${LNG}" || {
    echo "error: cannot create speech stock \"$STOCK\""
    exit
  }
}

# sleep function
SLEEP="0"
CHANNEL="0" # both=0, left=1, right=2
for i in "$@"
  do
    case $i in
      -s=*|--sleep=*)
        SLEEP="${i#*=}"
        shift
      ;;
      -c=*|--channel=*)
        CHANNEL="${i#*=}"
        shift
      ;;
      *)
        # unknown option
      ;;
  esac
done

ARGS=${*:-$(cat)}
#TEXT=${ARGS// /+}
TEXT=${ARGS// / }
echo $TEXT
FILE="$(echo "$TEXT" | md5sum)"
echo $TEXT
echo $FILE
FILE=${FILE%% *}
echo $FILE
#FILE="${STOCK}/${LNG}/${FILE}"
#
FILEX=".mp3"
FILETMP="${STOCK}/${LNG}/${FILE}tmp${FILEX}"
#FILE="${STOCK}/${LNG}/${FILE}${FILEX}"

# Replace umlauts for wget non supporting utf8
TEXT=$(echo $TEXT | sed 's/Ä/Ae/g')
TEXT=$(echo $TEXT | sed 's/Ö/Oe/g')
TEXT=$(echo $TEXT | sed 's/Ü/Ue/g')
TEXT=$(echo $TEXT | sed 's/ä/ae/g')
TEXT=$(echo $TEXT | sed 's/ö/oe/g')
TEXT=$(echo $TEXT | sed 's/ü/ue/g')
TEXT=$(echo $TEXT | sed 's/ß/ss/g')

#
if [ "$CHANNEL" == "0" ];then
  FILE="${STOCK}/${LNG}/${FILE}"
  if [ ! -f "${FILE}" ];then 
    echo "Downloading ..."
    #wget -q --user-agent="$UAGENT" -O "${FILE}" "${URL}${TEXT}"
    #curl -A "$UAGENT" -o "${FILE}" "${URL}${TEXT}"
    $GTTSBIN "${TEXT}" -l "${LNG}" -o "${FILE}"
    #google_speech -l "${LNG}" -o "${FILE}"
  fi
else 
  #FILE="${STOCK}/${LNG}/${FILE}${FILEX}"
  if [ "$CHANNEL" == "1" ]; then
    FILE="${STOCK}/${LNG}/${FILE}-1${FILEX}"
    MC1="0.0.0"
    MC2="-1"
  else
    FILE="${STOCK}/${LNG}/${FILE}-2${FILEX}"
    MC1="-1"
    MC2="0.0.0" 
  fi
  [ -f "${FILE}" ] ||
      (gtts-cli "${TEXT}" -l "${LNG}" -o "${FILE}" &&
      ffmpeg -y -i "${FILE}" -ac 2 "${FILETMP}" >/dev/null 2>&1 &&
    rm -r "${FILE}" && 
      ffmpeg -y -i "${FILETMP}" -map_channel $MC1 -map_channel $MC2 "${FILE}" >/dev/null 2>&1 &&
    rm -r "${FILETMP}")
fi
echo "${URL}${TEXT}"
echo "${FILE}"

FSIZE=$(du -k "${FILE}" | cut -f 1)
if [ "${FSIZE}" -eq 0 ];then
  rm ${FILE}
else 
  sleep "$SLEEP" && $PLAYER "${FILE}" &>/dev/null
fi

exit 0
