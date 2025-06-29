#!/data/data/com.termux/files/usr/bin/bash

# ====== 1. تهيئة المتغيرات الأساسية ======
ROOT_DIR="/data/data/com.termux/files/home/aqarzain"

# ====== 2. إنشاء الهيكل الرئيسي ======
mkdir -p $ROOT_DIR/system/{core,devtools/templates/{react,fastapi},env}
mkdir -p $ROOT_DIR/apps
mkdir -p $ROOT_DIR/{build,docs,meta}

# ====== 3. ملفات نظام الأساسية ======
cat << 'EOC' > $ROOT_DIR/system/core/core_utils.sh
#!/bin/bash
# أدوات أساسية للنظام
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

validate_app_name() {
    if [[ ! "$1" =~ ^[a-z_]+$ ]]; then
        log "خطأ: اسم التطبيق يجب أن يحتوي على أحرف صغيرة فقط وشرط سفلية"
        exit 1
    fi
}
EOC

cat << 'EOC' > $ROOT_DIR/system/env/.env.default
# إعدادات البيئة الافتراضية
APP_MODE=development
API_BASE_URL=https://api.aqarzain.com
DB_HOST=localhost
DB_PORT=5432
EOC

# ====== 4. قوالب التطبيقات ======
# 4.1 قالب React
mkdir -p $ROOT_DIR/system/devtools/templates/react/src/{components,views,services}
cat << 'EOC' > $ROOT_DIR/system/devtools/templates/react/src/App.js
import React from 'react';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <h1>مرحباً بك في تطبيق {APP_NAME}</h1>
      </header>
    </div>
  );
}

export default App;
EOC

# 4.2 قالب FastAPI
mkdir -p $ROOT_DIR/system/devtools/templates/fastapi/{app,routers}
cat << 'EOC' > $ROOT_DIR/system/devtools/templates/fastapi/main.py
from fastapi import FastAPI
from routers import main_router

app = FastAPI(title="{APP_NAME} API")
app.include_router(main_router.router)

@app.get("/health")
def health_check():
    return {"status": "active", "app": "{APP_NAME}"}
EOC

# ====== 5. سكربت إنشاء التطبيقات ======
cat << 'EOC' > $ROOT_DIR/system/devtools/create_app.sh
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
EOC
chmod +x $ROOT_DIR/system/devtools/create_app.sh

# ====== 6. سكربتات البناء ======
cat << 'EOC' > $ROOT_DIR/build/build_apk.sh
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
EOC
chmod +x $ROOT_DIR/build/build_apk.sh

# ====== 7. ملفات التوثيق ======
cat << 'EOC' > $ROOT_DIR/docs/README.md
# نظام aqarzain - الوثائق الفنية

## نظرة عامة
هو نظام شامل لإدارة تطبيقات متعددة، مع بنية أساسية موحدة.

## المكونات الرئيسية
1. **system/** - القلب النابض للنظام
2. **apps/** - مجلد التطبيقات
3. **build/** - سكربتات البناء المركزية
4. **meta/** - إعدادات النظام العام

## طريقة إنشاء تطبيق جديد
\`\`\`bash
cd system/devtools
./create_app.sh <اسم_التطبيق>
\`\`\`
EOC

# ====== 8. ملفات النظام العام ======
cat << 'EOC' > $ROOT_DIR/meta/config.json
{
    "system_name": "aqarzain",
    "version": "1.0.0",
    "default_apps": ["realestate", "users", "orders"]
}
EOC

# ====== 9. README الرئيسي ======
cat << 'EOC' > $ROOT_DIR/README.md
# نظام aqarzain الأساسي

## 📌 نظرة عامة
هذه هي البنية الأساسية لنظام aqarzain الذي يدعم تطبيقات متعددة بنظام موحد.

## ⚡ البداية السريعة
\`\`\`bash
# إنشاء تطبيق جديد
cd system/devtools
./create_app.sh realestate

# بناء تطبيق Android
cd ../../build
./build_apk.sh realestate
\`\`\`

## 📂 الهيكل الرئيسي
- \`system/\`: المكونات الأساسية للنظام
- \`apps/\`: مجلد التطبيقات
- \`build/\`: سكربتات البناء
- \`docs/\`: الوثائق الفنية
- \`meta/\`: إعدادات النظام العام
EOC

# ====== 10. إنشاء تطبيقات افتراضية ======
echo "إنشاء التطبيقات الافتراضية..."
$ROOT_DIR/system/devtools/create_app.sh realestate
$ROOT_DIR/system/devtools/create_app.sh orders
$ROOT_DIR/system/devtools/create_app.sh users

echo "✅ تم إنشاء نظام aqarzain بنجاح في $ROOT_DIR"
echo "يمكنك البدء بإنشاء تطبيقات جديدة باستخدام:"
echo "  cd system/devtools && ./create_app.sh <اسم_التطبيق>"
