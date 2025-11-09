import requests
import base64
from PIL import Image
import io
import time

def create_test_image(color='red'):
    # إنشاء صورة اختبار ملونة
    img = Image.new('RGB', (224, 224), color=color)
    buffer = io.BytesIO()
    img.save(buffer, format='JPEG')
    return base64.b64encode(buffer.getvalue()).decode('utf-8')

def test_api_health():
    # اختبار صحة الـ API
    try:
        response = requests.get("http://localhost:5000/health", timeout=10)
        if response.status_code == 200:
            data = response.json()
            print("API يعمل بشكل طبيعي")
            print(f" - CLIP محمّل: {'نعم' if data.get('clip_loaded') else 'لا'}")
            print(f" - FAISS محمّل: {'نعم' if data.get('faiss_loaded') else 'لا'}")
            return True
        else:
            print(f"خطأ في API: {response.status_code}")
            return False
    except requests.exceptions.ConnectionError:
        print("لا يمكن الوصول للـ API. تأكد من تشغيله أولاً")
        return False
    except Exception as e:
        print(f"خطأ غير متوقع : {e}")
        return False

def test_rebuild_index():
    # اختبار إعادة بناء الفهرس
    print("\n...اختبار إعادة بناء الفهرس")
    try:
        response = requests.post("http://localhost:5000/rebuild-index", timeout=60)
        if response.status_code == 200:
            data = response.json()
            print("تم بناء الفهرس بنجاح")
            print(f" - عدد العناصر المفهرسة : {data.get('indexed_items', 0)}")
            return True
        else:
            print(f"فشل بناء الفهرس : {response.status_code}")
            print(f"الخطأ : {response.text}")
            return False
    except Exception as e:
        print(f"خطأ في بناء الفهرس : {e}")
        return False

def test_image_search():
    # اختبار البحث بالصور
    print("\n...اختبار البحث بالصور")
    # اختبار ألوان مختلفة
    test_colors = ['red', 'blue', 'green']
    for color in test_colors:
        print(f"\nاختبار البحث بصورة {color}...")
        try:
            # إنشاء صورة اختبار
            image_base64 = create_test_image(color)
            # إرسال طلب البحث
            search_data = {
                'image_base64': image_base64,
                'k': 3  # أفضل 3 نتائج
            }
            start_time = time.time()
            response = requests.post(
                "http://localhost:5000/search",
                json=search_data,
                timeout=30
            )
            search_time = time.time() - start_time
            if response.status_code == 200:
                data = response.json()
                results = data.get('results', [])
                print(f"البحث نجح في {search_time:.2f} ثانية")
                print(f" - عدد النتائج : {len(results)}")
                if results:
                    print(" - أفضل النتائج:")
                    for i, item in enumerate(results[:3]):
                        similarity = item.get('similarity_score', 0) * 100
                        print(f" {i+1}. {item['name']} ({item['category']}) - تشابه {similarity:.1f}%")
                else:
                    print(" - لم يتم العثور على نتائج")
            else:
                print(f"فشل البحث : {response.status_code}")
                print(f"الخطأ : {response.text}")
        except Exception as e:
            print(f"خطأ في البحث : {e}")

def test_performance():
    # اختبار الأداء
    print("\n...اختبار الأداء")
    try:
        image_base64 = create_test_image('blue')
        search_data = {'image_base64': image_base64, 'k': 5}
        times = []
        for i in range(5):
            start_time = time.time()
            response = requests.post("http://localhost:5000/search", json=search_data, timeout=30)
            end_time = time.time()
            if response.status_code == 200:
                times.append(end_time - start_time)
                print(f"البحث {i+1}: {times[-1]:.2f} ثانية")
            else:
                print(f"البحث {i+1} فشل: {response.status_code}")
        if times:
            avg_time = sum(times) / len(times)
            min_time = min(times)
            max_time = max(times)
            print("\nإحصائيات الأداء:")
            print(f" - متوسط الوقت : {avg_time:.2f} ثانية")
            print(f" - أسرع بحث : {min_time:.2f} ثانية")
            print(f" - أبطأ بحث : {max_time:.2f} ثانية")
            if avg_time < 5:
                print("!الأداء ممتاز")
            elif avg_time < 10:
                print("⚠️ الأداء مقبول")
            else:
                print("الأداء بطيء")
    except Exception as e:
        print(f"خطأ في اختبار الأداء : {e}")

def main():
    # تشغيل جميع الاختبارات
    print("اختبار شامل لنظام البحث بالصور")
    print("=" * 50)

    # اختبار صحة API
    if not test_api_health():
        print("\nفشل اختبار الصحة. تأكد من تشغيل الـ API أولاً")
        print("python image_search_api_simple.py")
        return

    # اختبار إعادة بناء الفهرس
    if not test_rebuild_index():
        print("\nفشل بناء الفهرس. تحقق من قاعدة البيانات")
        return

    # اختبار البحث
    test_image_search()

    # اختبار الأداء
    test_performance()

    print("\nانتهت جميع الاختبارات!")
    print("\nالنظام جاهز للاستخدام. يمكنك الآن:")
    print("1. دمج الكود مع مشروع Flutter")
    print("2. تسليم الملفات لزميلتك")
    print("3. البدء في اختبار التكامل")

if __name__ == "__main__":
    main()
