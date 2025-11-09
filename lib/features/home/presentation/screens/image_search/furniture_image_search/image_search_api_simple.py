from flask import Flask, request, jsonify
from flask_cors import CORS
import torch
from PIL import Image
from transformers import CLIPProcessor, CLIPModel
import faiss
import numpy as np
import base64
import io
import os
import json
import requests

app = Flask(__name__)
CORS(app)

# متغيرات عامة
model = None
processor = None
faiss_index = None
faiss_id_map = []  # خريطة ID ↔ FAISS index


def initialize_clip():
    """تحميل نموذج CLIP مرة واحدة"""
    global model, processor
    if model is None:
        print("تحميل نموذج CLIP...")
        model = CLIPModel.from_pretrained("openai/clip-vit-base-patch32")
        processor = CLIPProcessor.from_pretrained("openai/clip-vit-base-patch32")
        print("✅ تم تحميل CLIP")


def get_image_embedding(image):
    """استخراج ميزات الصورة باستخدام CLIP"""
    initialize_clip()
    inputs = processor(images=image, return_tensors="pt")
    with torch.no_grad():
        features = model.get_image_features(**inputs)
    return features.cpu().numpy()


@app.route('/rebuild-index', methods=['POST'])
def rebuild_index():
    """إعادة بناء فهرس FAISS من صور API خارجي"""
    try:
        response = requests.get("https://accessories-eshop.runasp.net/api/products")
        if response.status_code != 200:
            return jsonify({'error': '❌ لا يمكن جلب المنتجات من API الخارجي'}), 400

        products = response.json()
        if not products:
            return jsonify({'error': '⚠️ لا توجد منتجات في API'}), 400

        print(f"🔄 بناء فهرس لـ {len(products)} منتج...")

        embeddings = []
        id_map = []

        for product in products:
            image_url = product.get('coverPictureUrl')
            if image_url:
                try:
                    img_response = requests.get(image_url)
                    image = Image.open(io.BytesIO(img_response.content)).convert("RGB")
                    embedding = get_image_embedding(image)
                    embeddings.append(embedding)
                    id_map.append(product['id'])
                except Exception as e:
                    print(f"❌ خطأ في الصورة {image_url}: {str(e)}")
            else:
                print("⚠️ المنتج لا يحتوي على صورة")

        if len(embeddings) == 0:
            return jsonify({'error': '❌ لا توجد صور صالحة'}), 400

        all_embeddings = np.vstack(embeddings)
        dimension = all_embeddings.shape[1]
        index = faiss.IndexFlatL2(dimension)
        index.add(all_embeddings.astype('float32'))

        # حفظ الفهرس والخريطة
        faiss.write_index(index, 'furniture_index.faiss')
        with open('faiss_id_map.json', 'w') as f:
            json.dump(id_map, f)

        global faiss_index, faiss_id_map
        faiss_index = index
        faiss_id_map = id_map

        print("✅ تم بناء الفهرس والخريطة بنجاح")
        return jsonify({
            'success': True,
            'message': f'📦 تم فهرسة {len(embeddings)} صورة بنجاح',
            'indexed_items': len(embeddings)
        })

    except Exception as e:
        return jsonify({'error': f'❌ حدث خطأ: {str(e)}'}), 500


@app.route('/search', methods=['POST'])
def search_by_image():
    """البحث عن صور مشابهة"""
    try:
        data = request.get_json()
        if 'image_base64' not in data:
            return jsonify({'error': '❌ لم يتم العثور على صورة'}), 400

        # فك تشفير الصورة
        image_data = base64.b64decode(data['image_base64'])
        image = Image.open(io.BytesIO(image_data)).convert("RGB")

        # استخراج الميزات
        query_embedding = get_image_embedding(image)

        # تحميل الفهرس إن لم يكن موجودًا
        global faiss_index, faiss_id_map
        if faiss_index is None:
            if os.path.exists('furniture_index.faiss'):
                faiss_index = faiss.read_index('furniture_index.faiss')
            else:
                return jsonify({'error': '⚠️ الفهرس غير موجود، أعد بناءه أولًا'}), 400

        if not faiss_id_map:
            if os.path.exists('faiss_id_map.json'):
                with open('faiss_id_map.json', 'r') as f:
                    faiss_id_map = json.load(f)
            else:
                return jsonify({'error': '⚠️ خريطة IDs غير موجودة'}), 400

        # البحث
        k = min(data.get('k', 5), faiss_index.ntotal)
        distances, indices = faiss_index.search(query_embedding, k)

        # جلب النتائج
        results = []

        for i, idx in enumerate(indices[0]):
            if 0 <= idx < len(faiss_id_map):
                product_id = faiss_id_map[idx]
                # إرجاع المنتج مع ID فقط، Flutter يمكنه استرجاع التفاصيل من API الخارجي
                results.append({
                    'product_id': product_id,
                    'similarity_score': float(distances[0][i])
                })

        return jsonify({
            'success': True,
            'results': results,
            'total_results': len(results)
        })

    except Exception as e:
        return jsonify({'error': f'❌ حدث خطأ: {str(e)}'}), 500


if __name__ == '__main__':
    print("🚀 بدء تشغيل خادم البحث بالصور")
    print("📍 http://localhost:5050")
    print("📌 POST /rebuild-index")
    print("📌 POST /search")
    app.run(host='0.0.0.0', port=8080, debug=True)

