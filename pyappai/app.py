from flask import Flask, request, jsonify
from flask_cors import CORS
from sklearn.linear_model import LogisticRegression
import numpy as np

app = Flask(__name__)
CORS(app)

# Örnek model - burada daha gelişmiş bir model kullanabilirsiniz
model = LogisticRegression()
X = np.array([[0], [1], [2], [3]])
y = np.array([0, 1, 1, 0])
model.fit(X, y)

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json()
    # Kullanıcı verilerini ve seçilen kartları kullanarak tahmin yapın
    # Bu örnekte basit bir model kullanılıyor, ancak kendi modelinizi ekleyebilirsiniz
    user_input = np.array([data['input']]).reshape(-1, 1)
    prediction = model.predict(user_input)
    response = {
        'prediction': int(prediction[0])
    }
    return jsonify(response)

if __name__ == '__main__':
    app.run(debug=True)