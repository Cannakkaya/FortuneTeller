from flask import Flask, request, jsonify
from flask_cors import CORS
import numpy as np

app = Flask(__name__)
CORS(app)

# Kart anlamları
cards = {
    "The Fool": "Yeni başlangıçlar, cesaret, tecrübesizlik ve fırsatlar.",
    "The Magician": "Yaratıcılık, güçlü irade, beceri, manipülasyon.",
    "The High Priestess": "Sezgi, içsel bilgi, gizli sırlar.",
    "The Empress": "Bereket, doğa, annelik, duygusal büyüme.",
    "The Lovers": "Aşk, ilişkiler, seçimler, uyum.",
    "Death": "Bitişler, dönüşüm, yeni başlangıçlar, temizlenme.",
    "The Devil": "Bağımlılık, tuzaklar, korkular, kontrol.",
    "The Sun": "Başarı, mutluluk, neşe, aydınlanma.",
    # Diğer kartları buraya ekleyebilirsiniz.
}

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.get_json()
        user_input = data['user_input']  # Kullanıcının adı veya başka bir bilgisi
        selected_card = data['selected_card']  # Seçilen kart

        # Kartın anlamını al
        card_meaning = cards.get(selected_card, "Bu kartın anlamı bulunamadı.")

        # Kartın özelliklerine göre gelişmiş bir yorum yapalım (örneğin: kişisel yorum, durum analizi vs.)
        if selected_card == "Death":
            prediction = f"{user_input} için kart seçildi: {selected_card}. Bu, bir dönüm noktası, eski alışkanlıklardan kurtulma ve yeni başlangıçlar anlamına gelir."
        elif selected_card == "The Lovers":
            prediction = f"{user_input} için kart seçildi: {selected_card}. Bu kart, ilişkilerdeki uyumu ve önemli seçimleri işaret eder."
        else:
            prediction = f"{user_input} için kart seçildi: {selected_card}. Yorum: {card_meaning}"

        response = {
            'prediction': prediction
        }
        return jsonify(response)
    except KeyError:
        return jsonify({'error': 'Invalid input, "user_input" and "selected_card" are required.'}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)