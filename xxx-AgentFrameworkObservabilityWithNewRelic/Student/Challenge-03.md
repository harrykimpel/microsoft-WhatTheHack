# 📊 Challenge 3: Add OpenTelemetry Instrumentation

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## 🎯 Objective

Add comprehensive observability to your WanderAI agents using OpenTelemetry!

By the end of this challenge:

- ✅ Every agent request creates a **trace** showing the full journey
- ✅ Tool calls are captured with timing and results
- ✅ Logs include structured context for debugging
- ✅ Metrics capture performance data
- ✅ You can see traces in console/OTLP output

---

## 🤔 Why This Matters

Right now, if something goes wrong with an agent:

- ❌ You don't know which tool was called
- ❌ You can't see timing information  
- ❌ You can't correlate logs to specific requests
- ❌ You can't measure performance metrics

OpenTelemetry fixes all of this! It's the **standard** for AI observability.

---

## 📚 Background Reading

Before you start, read:

1. **[OpenTelemetry Concepts](https://opentelemetry.io/docs/concepts/)**
   - Understand: Traces, Spans, Context, Signals

2. **[OpenTelemetry Python Documentation](https://opentelemetry.io/docs/instrumentation/python/)**
   - Focus on: Manual instrumentation, Span creation, Attributes

3. **[OTLP Protocol](https://opentelemetry.io/docs/specs/otel/protocol/)**
   - Know what: Traces, metrics, logs look like when exported

---

## 🎯 What You're Adding

### 1. OpenTelemetry Initialization

```python
from opentelemetry.sdk.resources import Resource
from opentelemetry.semconv._incubating.attributes.service_attributes import SERVICE_NAME
from agent_framework import ChatAgent
from agent_framework.openai import OpenAIChatClient
from agent_framework.observability import setup_observability, get_tracer, get_meter

# Create a resource identifying your service
resource = Resource.create({SERVICE_NAME: "travel-planner"})

# Setup observability
setup_observability()
# Get a tracer
tracer = get_tracer()
```

### 2. Instrument Your Tools

Wrap each tool function with a span:

```python
def get_weather(location: str) -> str:
    """Get weather for a location."""
    
    # Create a span for this tool call
    with tracer.start_as_current_span("get_weather") as span:
        # Set attributes that will help you debug
        span.set_attribute("location", location)
        
        # Simulate API call
        result = f"The weather in {location} is sunny with a high of {randint(0, 30)}°C."
        
        # Add success info
        span.set_attribute("weather_retrieved", True)
        
        return result
```

### 3. Instrument Your Main Agent Logic

Wrap the entire agent.run() call:

```python
@app.route('/plan', methods=['POST'])
def plan_trip():
    # Extract form data...
    
    with tracer.start_as_current_span("plan_trip_request") as span:
        span.set_attribute("destination", destination)
        span.set_attribute("duration", duration)
        
        # Run agent
        response = asyncio.run(agent.run(user_prompt))
        
        # Add response attributes
        span.set_attribute("response.token_count", 
                          response.usage_details.input_token_count + 
                          response.usage_details.output_token_count)
        
        return render_template('result.html', ...)
```

### 4. Add Logging with Context

```python
import logging

logger = logging.getLogger(__name__)

def get_weather(location: str) -> str:
    # Log the request
    logger.info(f"Getting weather for {location}")
    
    try:
        result = get_weather_api(location)
        
        # Log success with context
        logger.info(f"Weather retrieved", extra={
            "location": location,
            "result": result
        })
        return result
        
    except Exception as e:
        # Log error with context
        logger.error(f"Weather API failed", extra={
            "location": location,
            "error": str(e)
        })
        raise
```

---

## 🛠️ Implementation Steps

### Step 1: Initialize OpenTelemetry in Your App

At the top of `web_app.py`, add:

```python
from opentelemetry.sdk.resources import Resource
from opentelemetry.semconv._incubating.attributes.service_attributes import SERVICE_NAME, SERVICE_VERSION
from agent_framework import ChatAgent
from agent_framework.openai import OpenAIChatClient
from agent_framework.observability import setup_observability, get_tracer, get_meter

import logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Load environment variables
load_dotenv()

# Create named logger for application logs (before getting root logger)
app_logger = logging.getLogger("travel_planner")
app_logger.setLevel(logging.INFO)

# Create a resource identifying your service
resource = Resource.create({
    SERVICE_NAME: "travel-planner",
    SERVICE_VERSION: "0.1.0"
})

# Setup observability
setup_observability(resource)
# Get a tracer
tracer = get_tracer()

# 📝 Configure Logging
logging.basicConfig(level=logging.INFO)
# Create a reference for backward compatibility
logger = app_logger
```

### Step 2: Instrument Tool Functions

Wrap each tool with `tracer.start_as_current_span()`:

```python
def get_random_destination() -> str:
    with tracer.start_as_current_span("get_random_destination") as span:
        # ... implement logic to gather a random destination
        destination = "..."
        span.set_attribute("destination", destination)
        logger.info(f"Destination selected: {destination}")
        return f"Destination: {destination}"

def get_weather(location: str) -> str:
    with tracer.start_as_current_span("get_weather") as span:
        span.set_attribute("location", location)
        logger.info(f"Getting weather for {location}")
        # ... implement weather logic
        span.set_attribute("weather.successful", True)
        return result

def get_datetime() -> str:
    with tracer.start_as_current_span("get_datetime") as span:
        from datetime import datetime
        dt = datetime.now().isoformat()
        logger.info(f"Current datetime: {dt}")
        span.set_attribute("datetime", dt)
        return dt
```

### Step 3: Instrument Flask Routes

```python
@app.route('/plan', methods=['POST'])
def plan_trip():
    with tracer.start_as_current_span("http.post.plan") as span:
        try:
            # Extract form data
            destination = request.form.get('destination', '')
            duration = request.form.get('duration', '3')
            
            # Set span attributes
            span.set_attribute("http.method", "POST")
            span.set_attribute("http.route", "/plan")
            span.set_attribute("travel.date", date)
            span.set_attribute("travel.duration", int(duration))
            
            # Build prompt
            user_prompt = f"""Plan me a {duration}-day trip to a random destination starting on {date}."""
            
            # Run agent
            loop = asyncio.new_event_loop()
            asyncio.set_event_loop(loop)
            response = loop.run_until_complete(agent.run(user_prompt))
            loop.close()
            
            # Log success
            logger.info(f"Travel plan generated", extra={
                "destination": destination,
                "duration": duration
            })
            
            # Extract result
            text_content = response.messages[-1].contents[0].text
            
            # Return response
            return render_template('result.html', travel_plan=text_content)
            
        except Exception as e:
            span.set_attribute("error", True)
            logger.error(f"Failed to plan trip: {str(e)}")
            return render_template('error.html', error=str(e)), 500
```

---

## 🔍 Validating Your Instrumentation

When you run your app and submit a request, you should see traces printed to the console:

```
{
  "name": "get_weather",
  "context": {
    "trace_id": "4bf92f3577b34da6a3ce929d0e0e4736",
    "span_id": "00f067aa0ba902b7"
  },
  "attributes": {
    "location": "Barcelona, Spain"
  },
  "start_time": "2024-12-04T15:30:00.000000Z",
  "end_time": "2024-12-04T15:30:01.250000Z"
}
```

You should also see structured logs with context.

---

## ✅ Challenge Checklist

- [ ] OpenTelemetry SDK installed
- [ ] Tracer provider initialized
- [ ] Console exporter configured
- [ ] Tool functions instrumented with spans
- [ ] Flask routes instrumented
- [ ] Logging configured with context
- [ ] Run app and verify traces appear in console
- [ ] Tool attributes are captured
- [ ] Execution time is measured

---

## 💡 Tips

1. **Start small** - Instrument one tool first, then expand
2. **Check the console** - Traces should print when requests complete
3. **Use meaningful attributes** - Include anything that helps debugging
4. **Don't overload** - Every span/log should have a purpose
5. **Test without the agent first** - Make sure basic Flask routes work

---

## 📊 Expected Output

When you make a travel planning request, your console should show:

```
INFO:travel_planner:Travel plan requested for Barcelona, Spain (3 days)
{trace: http.post.plan, date: 12/04/2025 16:08:00, duration: 3}
  {trace: get_random_destination, destination: Barcelona, Spain}
  {trace: get_weather, location: Barcelona, Spain}
  {trace: get_datetime}
{trace: http.post.plan} completed in 2.5s
```

---

## 🎉 Next Steps

- ✅ Challenge 3 complete: Your app now has full tracing!
- **Challenge 4:** Send these traces to New Relic for analysis
- **Challenge 5:** Build dashboards and alerts based on this data
- **Challenge 6:** Use traces to evaluate and gate AI quality

---

## 🧪 What's Different from Challenge 2

| Aspect | Challenge 2 | Challenge 3 |
|--------|-------------|------------|
| Visibility | None | Full traces in console |
| Debugging | Blind | Can see tool calls, timing, results |
| Performance | Unknown | Can measure |
| Logging | Simple print() | Structured, contextual logs |
| Production Ready | No | Getting there! |

**You're building enterprise-grade observability!** 🎯
