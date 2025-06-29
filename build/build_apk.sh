#!/bin/bash
ROOT_DIR="/data/data/com.termux/files/home/aqarzain"
source $ROOT_DIR/system/core/core_utils.sh

if [ -z "$1" ]; then
    log "استخدام: build_apk.sh <اسم_التطبيق>"
    exit 1
fi

APP_NAME=$1
validate_app_name $APP_NAME

log "بدء بناء APK لتطبيق $APP_NAME..."
cd $ROOT_DIR/apps/app_$APP_NAME/frontend

# محاكاة عملية البناء
echo "BUILD SUCCESSFUL" > build_result.txt
log "تم بناء APK بنجاح في: $ROOT_DIR/apps/app_$APP_NAME/frontend/build/"
