# -*- coding: utf-8 -*-
import mysql.connector
from mysql.connector import Error

def setup_database():
    """إعداد قاعدة البيانات وإدراج بيانات تجريبية"""
    try:
        # الاتصال ب MySQL
        connection = mysql.connector.connect(
            host='localhost',
            user='root',
            password=''  # كلمة المرور الافتراضية في XAMPP
        )
        if connection.is_connected():
            cursor = connection.cursor()
            # إنشاء قاعدة البيانات
            cursor.execute("CREATE DATABASE IF NOT EXISTS furniture_db")
            print(" تم إنشاء قاعدة البيانات furniture_db")
            # استخدام قاعدة البيانات
            cursor.execute("USE furniture_db")
            # إنشاء جدول الأثاث
            create_table_query = """
            CREATE TABLE IF NOT EXISTS furniture (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(255) NOT NULL,
                category VARCHAR(100) NOT NULL,
                price DECIMAL(10, 2) NOT NULL,
                description TEXT,
                image_url VARCHAR(500) NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
            """
            cursor.execute(create_table_query)
            print(" تم إنشاء جدول furniture")
            # التحقق من وجود بيانات
            cursor.execute("SELECT COUNT(*) FROM furniture")
            count = cursor.fetchone()[0]
            if count == 0:
                # إدراج بيانات تجريبية
                sample_data = [
                    ('كرسي مكتب مريح باللون الأحمر', 'كراسي', 150.00, 'كرسي مكتب أحمر', 'images/chair_red.jpg'),
                    ('كرسي مكتب مريح باللون الأزرق', 'كراسي', 160.00, 'كرسي مكتب أزرق', 'images/chair_blue.jpg'),
                    ('طاولة خشبية باللون الأخضر', 'طاولات', 200.00, 'طاولة خضراء', 'images/table_green.jpg'),
                    ('كنبة مريحة باللون الأحمر', 'كنب', 500.00, 'كنبة حمراء', 'images/sofa_red.jpg'),
                    ('سرير مزدوج باللون الأزرق', 'أسرة', 800.00, 'سرير أزرق', 'images/bed_blue.jpg'),
                    ('خزانة ملابس بيضاء', 'خزائن', 300.00, 'خزانة بيضاء', 'images/wardrobe_white.jpg'),
                    ('طاولة قهوة خشبية', 'طاولات', 120.00, 'طاولة قهوة بنية', 'images/coffee_table_brown.jpg'),
                    ('كرسي استرخاء مريح', 'كراسي', 250.00, 'كرسي استرخاء رمادي', 'images/armchair_gray.jpg'),
                ]
                insert_query = """
                INSERT INTO furniture (name, category, price, description, image_url)
                VALUES (%s, %s, %s, %s, %s)
                """
                cursor.executemany(insert_query, sample_data)
                connection.commit()
                print(f" تم إدراج {cursor.rowcount} (قطعة أثاث تجريبية")
            else:
                print(f"ℹ️ يوجد بالفعل {count} (قطعة أثاث في قاعدة البيانات")
            # عرض البيانات المدرجة
            cursor.execute("SELECT id, name, category, price FROM furniture")
            items = cursor.fetchall()
            print("\n (:قطع الأثاث المتاحة")
            print("-" * 50)
            for item in items:
                print(f"{item[0]}. {item[1]} ({item[2]}) - {item[3]} جنيه")
    except Error as e:
        print(f" خطأ في إعداد قاعدة البيانات : {e}")
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("\n (تم إغلاق الاتصال بقاعدة البيانات")

def test_database_connection():
    """اختبار الاتصال بقاعدة البيانات"""
    try:
        connection = mysql.connector.connect(
            host='localhost',
            database='furniture_db',
            user='root',
            password=''
        )
        if connection.is_connected():
            print(" (الاتصال بقاعدة البيانات ناجح")
            cursor = connection.cursor()
            cursor.execute("SELECT COUNT(*) FROM furniture")
            count = cursor.fetchone()[0]
            print(f" عدد قطع الأثاث : {count}")
            cursor.close()
            connection.close()
            return True
    except Error as e:
        print(f" فشل الاتصال بقاعدة البيانات : {e}")
        return False

if __name__ == "__main__":
    print(" (إعداد قاعدة بيانات نظام البحث بالصور")
    print("=" * 50)
    # إعداد قاعدة البيانات
    setup_database()
    print("\n (...اختبار الاتصال")
    test_database_connection()
    print("\n (!انتهى إعداد قاعدة البيانات بنجاح")
    print("\n يمكنك الآن تشغيل ال API باستخدام : python image_search_api_simple.py")
