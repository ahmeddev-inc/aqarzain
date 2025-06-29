#!/bin/bash
ROOT_DIR="/data/data/com.termux/files/home/aqarzain"
source $ROOT_DIR/system/core/core_utils.sh

if [ -z "$1" ]; then
    log "استخدام: create_app.sh <اسم_التطبيق>"
    exit 1
fi

APP_NAME=$1
validate_app_name $APP_NAME

APP_DIR="$ROOT_DIR/apps/app_$APP_NAME"

# إنشاء هيكل التطبيق
mkdir -p $APP_DIR/{frontend,backend,shared,assets,env,build}

# نسخ القوالب
cp -r $ROOT_DIR/system/devtools/templates/react/* $APP_DIR/frontend/
cp -r $ROOT_DIR/system/devtools/templates/fastapi/* $APP_DIR/backend/

# إنشاء ملفات خاصة بالتطبيق
cat << EOT > $APP_DIR/README.md
# تطبيق $APP_NAME

## هيكل التطبيق
- frontend: واجهة المستخدم (React)
- backend: الخدمات (FastAPI)
- shared: كود مشترك
- assets: ملفات الوسائط
- env: إعدادات البيئة

## طريقة التشغيل
\`\`\`bash
# تشغيل الواجهة
cd frontend
npm install
npm start

# تشغيل الخدمات
cd backend
pip install -r requirements.txt
uvicorn main:app --reload
\`\`\`
EOT

# استبدال اسم التطبيق في القوالب
sed -i "s/{APP_NAME}/$APP_NAME/g" $APP_DIR/frontend/src/App.js
sed -i "s/{APP_NAME}/$APP_NAME/g" $APP_DIR/backend/main.py

log "تم إنشاء تطبيق $APP_NAME بنجاح في $APP_DIR"
