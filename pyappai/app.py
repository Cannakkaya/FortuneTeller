from flask import Flask, request, jsonify
from flask_cors import CORS
from sklearn.linear_model import LogisticRegression
import numpy as np

app = Flask(__name__)
CORS(app)

# Örnek model - burada daha gelişmiş bir model kullanabilirsiniz
model = LogisticRegression()

# Bu, modelin eğitileceği örnek veri setidir. Gerçek verilerle değiştirilmelidir.
X = np.array([[0], [1], [2], [3]])
y = np.array([0, 1, 1, 0])
model.fit(X, y)

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.get_json()
        # Kullanıcı bilgilerini ve kart seçimlerini al
        user_input = data['user_input']
        selected_card = data['selected_card']

        # Modeli burada kullanın. Bu örnek sadece bir simülasyon yapıyor.
        # Gerçek modeliniz için kullanıcı bilgilerini ve kart bilgisini daha iyi işleyebilirsiniz.
        prediction = model.predict(np.array([[len(user_input)]]))  # Basit bir tahmin örneği

        # Seçilen kart bilgisini burada bir şekilde kullanabilirsiniz
        # Örneğin: card_info = get_card_info(selected_card)

        response = {
            'prediction': f'Tahmin: {int(prediction[0])}, Kart: {selected_card}'
        }
        return jsonify(response)
    except KeyError:
        return jsonify({'error': 'Invalid input, "user_input" and "selected_card" are required.'}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)