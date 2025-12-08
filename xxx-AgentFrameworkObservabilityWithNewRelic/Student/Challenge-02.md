# 🏗️ Challenge 2: Build Your MVP

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## 🎯 Objective

Create the first version of WanderAI's Travel Planner service!

You'll build a Flask web application that:

- ✅ Serves a web interface for travel planning
- ✅ Accepts user travel preferences
- ✅ Uses Microsoft Agent Framework to plan trips
- ✅ Returns beautiful itineraries to users

By the end, you'll have a working startup product! 🚀

---

## 📋 What You're Building

### The MVP Feature Set

**User Interface:**

- A form where users enter their travel preferences
  - Travel date
  - Trip duration (days)
  - Interests (multiple select)
  - Special requests (free text)

**Backend:**

- Flask web server
- AI agent that creates travel plans
- Tool functions for getting data (weather, random destinations, current time)
- JSON API for future mobile apps

**Output:**

- Formatted HTML page with travel itinerary
- Beautiful presentation of the AI's recommendations

---

## 🚀 Getting Started

### Step 1: Set Up Your Environment

```bash
# Create a virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

**requirements.txt should include:**

```python
agent-framework-core
flask[async]
requests
python-dotenv
```

### Step 2: Environment Variables

Create a `.env` file in your project root:

```bash
# LLM Configuration
OPENAI_API_KEY=your_openai_api_key_here
GITHUB_MODEL_ID=gpt-4o-mini

# (Optional) Weather API
OPENWEATHER_API_KEY=your_openweather_key_here
```

### Step 3: Understand the Components

**You need to build:**

1. **Tool Functions** - Helper functions the agent can call
   - `get_random_destination()` - Verify the destination choice
   - `get_weather()` - Get current weather for a location
   - `get_datetime()` - Return current date/time

2. **Flask App** - Web server
   - GET `/` - Serve the home page form
   - POST `/plan` - Accept travel preferences, run agent, return results
   - (Optional) POST `/api/plan` - JSON API endpoint

3. **Agent Setup** - Create the AI agent
   - Initialize OpenAI client
   - Create ChatAgent with tools
   - Set system instructions

4. **Templates** - HTML pages (provided separately)

---

## 📝 Starter Code

Create `web_app.py`:

```python
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

def get_selected_destination(destination: str) -> str:
    """
    TODO: Implement this tool function
    
    Args:
        destination: The destination the user selected
    
    Returns:
        A string confirming the destination
    
    Hint: Simply return a confirmation message with the destination name
    """
    pass

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
    pass

def get_datetime() -> str:
    """
    TODO: Implement this tool function
    
    Return the current date and time
    
    Returns:
        Current date and time as string
    
    Hint: Use datetime.datetime.now().isoformat()
    """
    pass

# ============================================================================
# TODO 2: Create the OpenAI Chat Client
# ============================================================================

model_id = os.environ.get("GITHUB_MODEL_ID", "gpt-4o-mini")

# TODO: Create an OpenAIChatClient instance
# Hint: - You can leverage OpenAI, Azure OpenAI or GitHub Models here
#       - OpenAI: Use api_key=os.environ.get("OPENAI_API_KEY"), model_id=model_id
#       - GitHub Models: Use base_url=os.environ.get("GITHUB_ENDPOINT"), api_key=os.environ.get("GITHUB_TOKEN"), model_id=model_id
openai_chat_client = None

# ============================================================================
# TODO 3: Create the Travel Planning Agent
# ============================================================================

# TODO: Create a ChatAgent with:
# - chat_client: Your OpenAI client
# - instructions: "You are a helpful AI Agent that can help plan vacations for customers."
# - tools: A list of the three tool functions [get_selected_destination, get_weather, get_datetime]

agent = None

# ============================================================================
# TODO 4: Create Flask Routes
# ============================================================================

@app.route('/')
def index():
    """Serve the home page with the travel planning form."""
    # TODO: Render and return 'index.html'
    # Hint: return render_template('index.html')
    pass

@app.route('/plan', methods=['POST'])
async def plan_trip():
    """
    Handle travel plan requests from the form.
    
    TODO: Implement this endpoint
    """
    try:
        # TODO: Extract form data
        # Hint: Use request.form.get() for single values and request.form.getlist() for checkboxes
        # You need: date, duration, interests (list), special_requests
        
        # TODO: Build a user prompt for the agent
        # Example structure:
        # f"Plan me a {duration}-day trip to a random destination starting on {date} ..."
        
        # TODO: Run the agent asynchronously
        # Hint: Use asyncio to run: response = await agent.run(user_prompt)
        
        # TODO: Extract the travel plan from response
        # Hint: response.messages[-1].contents[0].text
        
        # TODO: Render and return 'result.html' with the travel plan
        pass
        
    except Exception as e:
        logger.error(f"Error planning trip: {str(e)}")
        return render_template('error.html', error=str(e)), 500

# ============================================================================
# Optional: API Endpoint for Mobile Apps
# ============================================================================

@app.route('/api/plan', methods=['POST'])
async def api_plan_trip():
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
    app.run(debug=True, host='0.0.0.0', port=5000)
```

---

## 🎨 HTML Templates

You'll need to create these in a `templates/` folder:

**templates/index.html** - The form page
**templates/result.html** - The results page  
**templates/error.html** - Error page

*See hints.md for template suggestions*

---

## 🎯 Implementation Checklist

- [ ] Create `web_app.py` with all TODO items filled in
- [ ] Implement `get_random_destination()` tool
- [ ] Implement `get_weather()` tool
- [ ] Implement `get_datetime()` tool
- [ ] Create OpenAI chat client
- [ ] Create ChatAgent with tools
- [ ] Implement `GET /` route
- [ ] Implement `POST /plan` route
- [ ] Create `templates/index.html`
- [ ] Create `templates/result.html`
- [ ] Create `templates/error.html`
- [ ] Test: Run the app and submit a travel request
- [ ] Verify: You get back a formatted travel plan

---

## 🧪 Testing Your MVP

```bash
# 1. Start your Flask app
python web_app.py

# 2. Open browser to http://localhost:5000

# 3. Fill in the form:
#    - Date: Pick a date
#    - Duration: "3"
#    - Interests: Check some boxes
#    - Special Requests: (optional)

# 4. Click "Plan My Trip"

# 5. You should see a formatted travel itinerary!
```

---

## 📊 Expected Output

When you submit a travel request, you should see HTML that includes:

```log
Destination: Barcelona, Spain
Duration: 3 days

Travel Plan:
[AI-generated detailed itinerary]
```

Real example from AI:

```log
Day 1: Arrival and Gothic Quarter
- Arrive and settle into accommodation
- Walk through the historic Gothic Quarter
- Visit Barcelona Cathedral (entry ~€8)
- Dinner at a local tapas bar (€15-25 per person)

Current Weather: Sunny, 22°C
Best Time to Visit: April-May or September-October
```

---

## 💡 Hints & Tips

1. **Start small** - Get the form rendering first, then add the agent logic
2. **Test tools individually** - Make sure each tool works before integrating
3. **Debug with print()** - Log what the agent is thinking
4. **Reference the solution** - Look at `web_app.py` in the parent directory if stuck
5. **Use async properly** - The agent.run() must be awaited in an async context

---

## 🚨 Common Issues

**Issue:** `ModuleNotFoundError: No module named 'agent_framework'`

- **Solution:** Make sure you've installed `agent-framework-core` in your .venv

**Issue:** Agent doesn't call tools

- **Solution:** Check that tools are passed to the ChatAgent constructor

**Issue:** HTML template not found

- **Solution:** Make sure `templates/` folder exists and is in the same directory as `web_app.py`

**Issue:** OPENAI_API_KEY error

- **Solution:** Check your `.env` file and ensure the key is set correctly

---

## ✅ Challenge Complete When

- ✅ App runs without errors
- ✅ Web form loads at <http://localhost:5000>
- ✅ You can submit a travel request
- ✅ AI agent returns a formatted travel plan
- ✅ The plan includes real information from your tools

---

## 🎉 Celebrate

You've built the MVP of WanderAI! This is a real, working startup product. Your first customers can now use it to plan trips! 🌍✈️

**Next:** Challenge 3 - Add observability so you can see what's happening inside your agents!
