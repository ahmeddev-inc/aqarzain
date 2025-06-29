# تطبيق realestate

## هيكل التطبيق
- frontend: واجهة المستخدم (React)
- backend: الخدمات (FastAPI)
- shared: كود مشترك
- assets: ملفات الوسائط
- env: إعدادات البيئة

## طريقة التشغيل
```bash
# تشغيل الواجهة
cd frontend
npm install
npm start

# تشغيل الخدمات
cd backend
pip install -r requirements.txt
uvicorn main:app --reload
```
