from flask import Flask, request, jsonify
import joblib
import numpy as np

# Initialize Flask app
app = Flask(__name__)

# Load the trained model
model = joblib.load('trained_travel_cost_model_v5.pkl')

# Define a function to preprocess the input
def preprocess_input(country, preferences, days, travelers, package):
    # Initialize encoding vectors for country (3 features)
    country_encoding = [0, 0, 0]  # 3 columns for 'Malaysia', 'Thailand', 'Singapore'

    # Preference encoding (5 features)
    preference_encoding = [0, 0, 0, 0, 0]  # 5 columns for preferences: 'Beach', 'Adventure', 'Cultural', 'Nature', 'Shopping'

    # Travel package encoding (2 features for 'Mid-Range' and 'Premium', Budget is implicitly [0, 0])
    package_encoding = [0, 0]

    # Add placeholders for the extra 2 features that are likely missing
    extra_features = [0, 0]  # These could be extra categorical features from the training

    # Dictionary mappings for one-hot encoding
    country_map = {'Malaysia': 0, 'Thailand': 1, 'Singapore': 2}
    preference_map = {'Beach': 0, 'Adventure': 1, 'Cultural': 2, 'Nature': 3, 'Shopping': 4}
    
    # Encode the country
    if country == 'Malaysia':
        country_encoding[0] = 1
    elif country == 'Thailand':
        country_encoding[1] = 1
    elif country == 'Singapore':
        country_encoding[2] = 1
    
    # Encode the preferences
    if preferences:
        for pref in preferences:
            if pref in preference_map:
                preference_encoding[preference_map[pref]] = 1

    # Handle one-hot encoding for the Travel Package
    if package == 'Budget':
        package_encoding = [0, 0]  # Budget is [0, 0]
    elif package == 'Mid-Range':
        package_encoding = [1, 0]  # Mid-Range is [1, 0]
    elif package == 'Premium':
        package_encoding = [0, 1]  # Premium is [0, 1]

    # Combine everything into a single input vector
    input_vector = np.array(country_encoding + preference_encoding + [days, travelers] + package_encoding + extra_features).reshape(1, -1)

    return input_vector

# Function to get exchange rates (simulated rates)
def get_exchange_rates():
    rates = {
        "LKR": 325,   # Sri Lankan Rupee
        "USD": 1      # For USD, no conversion
    }
    return rates

# Route to handle prediction requests
@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    
    # Extract input from JSON request
    country = data.get('country')
    preferences = data.get('preferences')
    days = data.get('days')
    travelers = data.get('travelers')
    package = data.get('package')
    
    # Preprocess the input
    custom_input = preprocess_input(country, preferences, days, travelers, package)
    
    # Make prediction using the loaded model (base cost in USD)
    prediction = model.predict(custom_input)[0]  # Get the predicted cost per person in USD

    # Apply mathematical adjustments based on the travel package
    if package == 'Mid-Range':
        prediction *= 1.20  # Increase by 20% for Mid-Range package
    elif package == 'Premium':
        prediction *= 1.50  # Increase by 50% for Premium package

    # Apply adjustments based on the number of travel days
    if days != 7:  # Base cost is for 7 days
        prediction *= (days / 7)  # Adjust cost proportionally to the number of days

    # Get exchange rates
    exchange_rates = get_exchange_rates()

    # Convert the prediction cost to Sri Lankan Rupees (LKR)
    cost_lkr = prediction * exchange_rates["LKR"]

    # Calculate the total cost for all travelers in USD
    total_cost_usd = prediction * travelers
    total_cost_lkr = cost_lkr * travelers

    # Prepare the response as JSON
    response = {
        #"cost_per_person_usd": round(prediction, 2),
        "cost_per_person_lkr": round(cost_lkr, 2),
        #"total_cost_usd": round(total_cost_usd, 2),
        "total_cost_lkr": round(total_cost_lkr, 2)
    }

    return jsonify(response)

# Run the Flask app
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)
