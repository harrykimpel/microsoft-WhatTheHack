# 📦 Import Required Libraries
from dotenv import load_dotenv
import os
import asyncio
import time
import logging
from random import randint, uniform

# Flask imports
from flask import Flask, render_template, request, jsonify

# Load environment variables
load_dotenv()

# ============================================================================
# Challenge #3
# TODO: configure observability
# ============================================================================


# 📝 Configure Logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# ============================================================================
# Challenge #2
# TODO: Import Microsoft Agent Framework
# HINT: from agent_framework import ???
# ============================================================================

# 🌐 Initialize Flask Application
app = Flask(__name__)

# ============================================================================
# Challenge #2
# TODO: Define Tool Functions
# ============================================================================
# These are functions the agent can call to get information


def get_random_destination() -> str:
    """
    TODO:(optional) implement/update this tool function

    Get a random travel destination

    Returns:
        A random destination

    """
    # ============================================================================
    # Challenge #3
    # TODO: Add custom span for observability
    # Hint: Use tracer.start_as_current_span
    # ============================================================================
    destinations = ["Garmisch-Partenkirchen", "Munich",
                    "Paris", "New York", "Tokyo", "Sydney", "Cairo"]
    destination = destinations[randint(0, len(destinations) - 1)]
    logger.info(f"Selected random destination: {destination}")
    return f"You have selected {destination} as your travel destination."


def get_weather(location: str) -> str:
    """
    TODO: Implement this function or return mock data
    Get current weather for a given location
    Returns:
        Current weather as string
    Hint: Use OpenWeatherMap API with requests library or return mock data
    """
    # ============================================================================
    # Challenge #3
    # TODO: Add custom span for observability
    # Hint: Use tracer.start_as_current_span
    # ============================================================================
    logger.info(f"Fetching weather for location: {location}")
    pass  # Your code here


def get_datetime() -> str:
    """
    Return the current date and time

    Returns:
        Current date and time as string

    Hint: Use datetime.datetime.now().isoformat()
    """
    # ============================================================================
    # Challenge #3
    # TODO: Add custom span for observability
    # Hint: Use tracer.start_as_current_span
    # ============================================================================
    logger.info("Fetching current date and time.")
    current_datetime = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    return current_datetime


model_id = os.environ.get("MODEL_ID", "gpt-5-mini")

# ============================================================================
# Challenge #2
# TODO: Create/configure the OpenAI Chat Client
# HINT:
# - check https://github.com/microsoft/agent-framework/blob/main/python/samples/getting_started/chat_client/openai_chat_client.py
# - be sure to set base url to Microsoft Foundry endpoint
# - openai_chat_client = ???
# ============================================================================


# ============================================================================
# Challenge #2
# TODO: Create the Travel Planning ChatAgent
# - chat_client: Your OpenAI client
# - instructions: "You are a helpful AI Agent that can help plan vacations for customers."
# - tools: A list of the three tool functions [get_random_destination, get_weather, get_datetime]
# HINT:
# - check https://learn.microsoft.com/en-us/python/api/agent-framework-core/agent_framework.chatagent?view=agent-framework-python-latest
# - agent = ???
# ============================================================================


# ============================================================================
# Flask Routes
# ============================================================================

@app.route('/')
def index():
    """Serve the home page with the travel planning form."""
    logger.info("Serving home page.")
    return render_template('index.html')


@app.route('/plan', methods=['POST'])
async def plan_trip():
    """
    Handle travel plan requests from the form.
    """
    logger.info("Received travel plan request.")
    try:
        # You need: origin, destination, date, duration, interests (list), special_requests
        date = request.form.get('date', '')
        duration = request.form.get('duration', '3')
        interests = request.form.getlist('interests')
        special_requests = request.form.get('special_requests', '')

        # Example structure:
        # f"Plan me a {duration}-day trip from {origin} to {destination}..."
        user_prompt = f"""Plan me a {duration}-day trip to a random destination starting on {date}.

            Trip Details:
            - Date: {date}
            - Duration: {duration} days
            - Interests: {', '.join(interests) if interests else 'General sightseeing'}
            - Special Requests: {special_requests if special_requests else 'None'}

            Instructions:
            1. A detailed day-by-day itinerary with activities tailored to the interests
            2. Current weather information for the destination
            3. Local cuisine recommendations
            4. Best times to visit specific attractions
            5. Travel tips and budget estimates
            6. Current date and time reference
            """

        # ============================================================================
        # Challenge #2
        # TODO: Run the agent asynchronously
        # Hint: Use asyncio to run: response = await agent.run(user_prompt)
        # ============================================================================

        # ============================================================================
        # Challenge #2
        # TODO: Extract the travel plan from response
        # Hint: text_content = response.messages???
        # ============================================================================

        return render_template('result.html',
                               travel_plan=text_content,
                               duration=duration)

    except Exception as e:
        logger.error(f"Error planning trip: {str(e)}")
        return render_template('error.html', error=str(e)), 500


# ============================================================================
# Main Execution
# ============================================================================

if __name__ == "__main__":
    # Run Flask development server
    app.run(debug=True, host='0.0.0.0', port=5002)
