#!/bin/bash

sudo -v

MAS_OUTPUT=$(mas list | grep 869223134)

if [ -z "$MAS_OUTPUT" ]; then
  echo "카카오톡이 설치되어있지 않습니다."
  exit 1
fi

APP_NAME=$(echo "$MAS_OUTPUT" | awk '{print $2}')

if [ -d "/Applications/${APP_NAME}.app" ]; then
  SOURCE_APP_PATH="/Applications/${APP_NAME}.app"
elif [ -d "/Applications/${APP_NAME} (개인).app" ]; then
  SOURCE_APP_PATH="/Applications/${APP_NAME} (개인).app"
else
  echo "카카오톡이 설치되어있지 않습니다."
  exit 1
fi

cp -a "${SOURCE_APP_PATH}" /Applications/KakaoTalkDev.app

mv /Applications/KakaoTalkDev.app/Contents/MacOS/KakaoTalk /Applications/KakaoTalkDev.app/Contents/MacOS/KakaoTalkDev
cd /Applications/KakaoTalkDev.app/Contents/

sed -i .bak "s/KakaoTalk<\/string>/KakaoTalkDev<\/string>/g" Info.plist
sed -i .bak "s/com.kakao.KakaoTalkMac<\/string>/com.kakao.KakaoTalkDevMac<\/string>/g" Info.plist

codesign --force --deep --sign - /Applications/KakaoTalkDev.app

if [ "$SOURCE_APP_PATH" = "/Applications/${APP_NAME}.app" ]; then
  sudo mv "/Applications/${APP_NAME}.app" "/Applications/${APP_NAME} (개인).app"
fi

sudo mv /Applications/KakaoTalkDev.app "/Applications/${APP_NAME} (업무).app"

open "/Applications/${APP_NAME} (업무).app"
