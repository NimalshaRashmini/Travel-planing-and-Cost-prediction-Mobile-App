from flask import Flask, request, jsonify
import cohere
from datetime import datetime

# Initialize Flask app
app = Flask(__name__)

# Initialize Cohere API
COHERE_API_KEY = "xa3iIgffKr8cADxO4p03a62Uw4KqsU88PqP6Mgrp"  # Replace with your Cohere API key
co = cohere.Client(COHERE_API_KEY)

# Function to generate travel plan
def generate_travel_plan(country, travel_days, traveler_count, travel_date):
    prompt = (
        f"Create a detailed {travel_days}-day travel itinerary for {traveler_count} people visiting {country}, "
        f"starting from {travel_date}. Each day's summary should mention a main attraction, a dining recommendation, "
        f"and one additional activity, along with transportation options for the day. Keep the descriptions concise and focus on key highlights."
    )
    
    response = co.generate(
        model='command-xlarge-nightly',
        prompt=prompt,
        max_tokens=5500
    )

    if response.generations:
        travel_plan = response.generations[0].text.strip()
        return travel_plan
    else:
        return "Error: Unable to generate a travel plan"

# API route to handle travel plan generation
@app.route('/generate-travel-plan', methods=['POST'])
def travel_plan():
    data = request.json

    # Extract inputs from the JSON request
    country = data.get('country')
    travel_days = data.get('travel_days')
    traveler_count = data.get('traveler_count')
    travel_date = data.get('travel_date')

    if not country or not travel_days or not traveler_count or not travel_date:
        return jsonify({"error": "Missing required parameters"}), 400

    # Generate travel plan
    travel_plan_text = generate_travel_plan(country, travel_days, traveler_count, travel_date)

    # Return the travel plan as a JSON response
    return jsonify({"travel_plan": travel_plan_text})

# Run the Flask app
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5002)
