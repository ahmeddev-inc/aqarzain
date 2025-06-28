#!/usr/bin/env bash

# سكربت بناء تطبيق "عقار زين" بصيغة APK داخل Termux
# الإصدار: 3.0 (مُحسَّن ومُثبَّت)
# التاريخ: 2025-06-29

set -euo pipefail

# -------- 🎨 الألوان --------
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

# -------- 📁 إعداد المسارات --------
APP_NAME="AcarZain"
APP_ID="com.ahmeddev.acarzain"
APP_TITLE="AcarZain"
BASE_DIR="$HOME/projects/$APP_NAME"
WEBAPP_SRC="$BASE_DIR/webapp"
APK_OUTPUT_DIR="$BASE_DIR/apk_output"

# -------- 🔍 التحقق من المتطلبات --------
check_requirements() {
    echo -e "${CYAN}🔍 التحقق من المتطلبات...${NC}"
    
    if ! command -v node &> /dev/null; then
        echo -e "${RED}❌ Node.js غير مثبت!${NC}"
        echo -e "${YELLOW}📌 جاري التثبيت التلقائي...${NC}"
        pkg install nodejs -y || {
            echo -e "${RED}❌ فشل تثبيت Node.js!${NC}"
            exit 1
        }
    fi

    if ! command -v cordova &> /dev/null; then
        echo -e "${YELLOW}⚠️ Cordova غير مثبت، جاري التثبيت...${NC}"
        npm install -g cordova --ignore-scripts || {
            echo -e "${RED}❌ فشل تثبيت Cordova!${NC}"
            exit 1
        }
    fi

    if ! command -v cordova-res &> /dev/null; then
        echo -e "${YELLOW}⚠️ جاري تثبيت cordova-res (بدون sharp)...${NC}"
        npm install -g cordova-res --ignore-scripts || {
            echo -e "${YELLOW}⚠️ تم تخطي cordova-res (غير ضروري للبناء الأساسي)${NC}"
        }
    fi
}

# -------- 🏗️ إعداد المشروع --------
setup_project() {
    echo -e "${CYAN}🏗️ إعداد المشروع...${NC}"
    
    # إنشاء مجلدات العمل
    mkdir -p "$WEBAPP_SRC" "$APK_OUTPUT_DIR"
    
    # إنشاء ملفات ويب افتراضية إذا لم تكن موجودة
    if [ ! -f "$WEBAPP_SRC/index.html" ]; then
        echo -e "${YELLOW}📝 إنشاء ملفات ويب افتراضية...${NC}"
        mkdir -p "$WEBAPP_SRC"/{css,js,images}
        cat << 'EOF' > "$WEBAPP_SRC/index.html"
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <title>عقار زين</title>
</head>
<body>
    <h1>مرحباً بكم في عقار زين</h1>
</body>
</html>
EOF
    fi

    # تنظيف شامل للمشروع القديم
    rm -rf "$BASE_DIR"/{platforms,plugins,node_modules,www,config.xml}
    
    # إنشاء مشروع Cordova جديد
    echo -e "${CYAN}📦 إنشاء مشروع Cordova جديد...${NC}"
    cordova create "$BASE_DIR" "$APP_ID" "$APP_TITLE" || {
        echo -e "${RED}❌ فشل إنشاء المشروع!${NC}"
        exit 1
    }
}

# -------- 📂 نسخ ملفات الويب --------
copy_web_files() {
    echo -e "${CYAN}📁 نسخ ملفات الواجهة...${NC}"
    
    if [ -d "$WEBAPP_SRC" ] && [ -n "$(ls -A "$WEBAPP_SRC")" ]; then
        rm -rf "$BASE_DIR/www"/*
        cp -r "$WEBAPP_SRC"/* "$BASE_DIR/www/" || {
            echo -e "${RED}❌ فشل نسخ ملفات الويب!${NC}"
            exit 1
        }
    else
        echo -e "${RED}❌ مجلد الواجهة فارغ أو غير موجود!${NC}"
        exit 1
    fi
}

# -------- 📱 بناء التطبيق --------
build_app() {
    cd "$BASE_DIR"
    
    echo -e "${CYAN}📱 إضافة منصة Android...${NC}"
    cordova platform add android --no-interactive || {
        echo -e "${RED}❌ فشل إضافة منصة Android!${NC}"
        exit 1
    }

    echo -e "${CYAN}🏗️ جاري بناء التطبيق...${NC}"
    cordova build android || {
        echo -e "${RED}❌ فشل بناء التطبيق!${NC}"
        exit 1
    }
}

# -------- 📦 نقل ملف APK --------
move_apk() {
    APK_SOURCE_PATH="platforms/android/app/build/outputs/apk/debug/app-debug.apk"
    
    if [ -f "$APK_SOURCE_PATH" ]; then
        echo -e "${CYAN}📦 نقل ملف APK...${NC}"
        mkdir -p "$APK_OUTPUT_DIR"
        cp "$APK_SOURCE_PATH" "$APK_OUTPUT_DIR/$APP_NAME.apk"
        echo -e "${GREEN}✅ تم إنشاء APK بنجاح!${NC}"
        echo -e "${GREEN}📂 الموقع: $APK_OUTPUT_DIR/$APP_NAME.apk${NC}"
        
        # نسخ إلى مجلد التحميل إذا وجد
        if [ -d "/storage/emulated/0/Download" ]; then
            cp "$APK_OUTPUT_DIR/$APP_NAME.apk" "/storage/emulated/0/Download/$APP_NAME.apk"
            echo -e "${GREEN}📥 تم النسخ إلى مجلد التحميل${NC}"
        fi
    else
        echo -e "${RED}❌ لم يتم العثور على ملف APK!${NC}"
        exit 1
    fi
}

# -------- 📜 التنفيذ الرئيسي --------
main() {
    check_requirements
    setup_project
    copy_web_files
    build_app
    move_apk
    echo -e "${CYAN}🎉 تم الانتهاء بنجاح!${NC}"
}

main