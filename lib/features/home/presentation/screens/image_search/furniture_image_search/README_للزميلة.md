نظرة عامة ##
هذا النظام يوفر API .للبحث عن الأثاث المشابه باستخدام الصور والذكاء الاصطناعي
المتطلبات الأساسية ##
- Python أو أحدث 3.8
- MySQL ( من خلال XAMPP)
لتحميل نموذج) اتصال بالإنترنت - CLIP (في المرة الأولى
خطوات التشغيل ##
### إعداد البيئة . 1
```bash
إنشاء بيئة افتراضية #
python -m venv image_search_env
تفعيل البيئة الافتراضية #
# Windows:
image_search_env\Scripts\activate
# Mac/Linux:
source image_search_env/bin/activate
تثبيت المكتبات المطلوبة #
pip install -r requirements.txt