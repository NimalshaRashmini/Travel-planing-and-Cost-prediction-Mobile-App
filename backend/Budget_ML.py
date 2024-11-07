from flask import Flask, request, jsonify
import pandas as pd
import pickle

app = Flask(__name__)

with open('travel_cost_model.pkl', 'rb') as model_file:
    model = pickle.load(model_file)

@app.route('/predict_travel_cost', methods=['POST'])
def predict_travel_cost():
    try:
        data = request.json
        country = data.get('country')
        number_of_persons = data.get('number_of_persons')
        number_of_days = data.get('number_of_days')

        if not country or number_of_persons is None or number_of_days is None:
            return jsonify({"error": "Fields 'country', 'number_of_persons', and 'number_of_days' are required."}), 400

        input_data = pd.DataFrame([[country, number_of_persons, number_of_days]],
                                  columns=['country', 'number_of_persons', 'number_of_days'])

        prediction = model.predict(input_data)

        return jsonify({
            "predicted_cost": f"${prediction[0]:.2f}"
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5002)
