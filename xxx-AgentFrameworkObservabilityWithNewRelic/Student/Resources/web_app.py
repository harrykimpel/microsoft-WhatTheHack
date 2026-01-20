# 📦 Import Required Libraries
import os
import asyncio
import time
import logging
from random import randint, uniform

# Flask imports
from flask import Flask, render_template, request, jsonify

# Microsoft Agent Framework
from agent_framework import ChatAgent
from agent_framework.openai import OpenAIChatClient

# Load environment variables
from dotenv import load_dotenv
load_dotenv()

# 🌐 Initialize Flask Application
app = Flask(__name__)

# 📝 Configure Logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# ============================================================================
# TODO 1: Define Tool Functions
# ============================================================================
# These are functions the agent can call to get information


def get_random_destination() -> str:
    """
    TODO: Implement this tool function

    Args:
        destination: The destination the user selected

    Returns:
        A string confirming the destination

    Hint: Simply return a confirmation message with the destination name
    """
    destinations = ["Garmisch-Partenkirchen", "Munich",
                    "Paris", "New York", "Tokyo", "Sydney", "Cairo"]
    destination = destinations[randint(0, len(destinations) - 1)]
    return f"You have selected {destination} as your travel destination."


def get_weather(location: str) -> str:
    """
    TODO: Implement this tool function

    This should return weather information for a location.
    For now, you can return a fake weather message.

    Args:
        location: The location to get weather for

    Returns:
        A weather description string

    Hint: For MVP, just return something like "The weather in {location} is sunny with a high of 22°C"
    Real weather API integration is optional and can use OPENWEATHER_API_KEY
    """
    return f"The weather in {location} is sunny with a high of {randint(20, 30)}°C."


def get_datetime() -> str:
    """
    TODO: Implement this tool function

    Return the current date and time

    Returns:
        Current date and time as string

    Hint: Use datetime.datetime.now().isoformat()
    """
    return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())

# ============================================================================
# TODO 2: Create/configure the OpenAI Chat Client
# ============================================================================


model_id = os.environ.get("MODEL_ID", "gpt-5-mini")

# Use Microsoft Foundry endpoint directly
openai_chat_client = OpenAIChatClient(
    base_url=os.environ.get("MSFT_FOUNDRY_ENDPOINT"),
    api_key=os.environ.get("MSFT_FOUNDRY_API_KEY"),
    model_id=model_id
)

# ============================================================================
# TODO 3: Create the Travel Planning Agent
# ============================================================================

# TODO: Create a ChatAgent with:
# - chat_client: Your OpenAI client
# - instructions: "You are a helpful AI Agent that can help plan vacations for customers."
# - tools: A list of the three tool functions [get_random_destination, get_weather, get_datetime]

agent = ChatAgent(
    chat_client=openai_chat_client,
    instructions="You are a helpful AI Agent that can help plan vacations for customers at random destinations.",
    # Tool functions available to the agent
    tools=[get_random_destination, get_weather, get_datetime]
)

# ============================================================================
# TODO 4: Create Flask Routes
# ============================================================================


@app.route('/')
def index():
    """Serve the home page with the travel planning form."""
    return render_template('index.html')


@app.route('/plan', methods=['POST'])
async def plan_trip():
    """
    Handle travel plan requests from the form.

    TODO: Implement this endpoint
    """
    try:
        # TODO: Extract form data
        # Hint: Use request.form.get() for single values and request.form.getlist() for checkboxes
        # You need: origin, destination, date, duration, interests (list), special_requests
        date = request.form.get('date', '')
        duration = request.form.get('duration', '3')
        interests = request.form.getlist('interests')
        special_requests = request.form.get('special_requests', '')

        # TODO: Build a user prompt for the agent
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

        # TODO: Run the agent asynchronously
        # Hint: Use asyncio to run: response = await agent.run(user_prompt)
        loop = asyncio.new_event_loop()
        asyncio.set_event_loop(loop)
        response = await agent.run(user_prompt)
        loop.close()

        # TODO: Extract the travel plan from response
        # Hint: response.messages[-1].contents[0].text
        last_message = response.messages[-1]
        text_content = last_message.contents[0].text

        # TODO: Render and return 'result.html' with the travel plan
        return render_template('result.html',
                               travel_plan=text_content,
                               duration=duration)

    except Exception as e:
        logger.error(f"Error planning trip: {str(e)}")
        return render_template('error.html', error=str(e)), 500

# ============================================================================
# Optional: API Endpoint for Mobile Apps
# ============================================================================


@app.route('/api/plan', methods=['POST'])
def api_plan_trip():
    """
    API endpoint that returns JSON instead of HTML.

    Optional for MVP but good practice for scaling!
    """
    # TODO: Similar to /plan but returns JSON
    # Hint: Return jsonify({'travel_plan': text_content, 'success': True})
    pass

# ============================================================================
# Main Execution
# ============================================================================


if __name__ == "__main__":
    # Run Flask development server
    app.run(debug=True, host='0.0.0.0', port=5002)
