# Challenge 04 - New Relic Integration

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## 🎯 Objective

Connect your OpenTelemetry traces to New Relic so your team can see and analyze agent behavior in real-time!

By the end of this challenge:

- ✅ Traces flow from your app to New Relic
- ✅ You can view traces in the New Relic UI
- ✅ You can search and filter traces
- ✅ You understand service maps and dependencies
- ✅ Your entire team can see what your agents are doing

---

## 🤔 Why This Matters

Console output is great for development, but in production:

- ❌ You can't search 1 million traces
- ❌ You can't correlate across services
- ❌ You lose data after you restart the app
- ❌ Your team can't collaborate on debugging

New Relic is a **backend** that stores and analyzes your telemetry at scale!

---

## 📚 Background

Read these first:

1. **[New Relic OTLP Ingest](https://docs.newrelic.com/docs/opentelemetry/opentelemetry-introduction/)**
   - How New Relic receives OpenTelemetry data

2. **[Configuring OTLP Endpoint](https://docs.newrelic.com/docs/opentelemetry/best-practices/opentelemetry-otlp/)**
   - How to point your app to New Relic

3. **[New Relic AI Monitoring](https://docs.newrelic.com/docs/ai-monitoring/intro-to-ai-monitoring/)**
   - Special features for AI observability

---

## 🔑 Prerequisites

You'll need:

1. A New Relic account (free tier works fine)
2. Your **License Key** (found in Account Settings)
3. The New Relic OTLP endpoint (US: `https://otlp.nr-data.net`, EU: `https://otlp.eu01.nr-data.net`)

---

## 🛠️ Implementation Steps

### Step 1: Configure Environment Variables

Add to your `.env`:

```bash
# New Relic OTLP Configuration
# US region
OTEL_EXPORTER_OTLP_ENDPOINT=https://otlp.nr-data.net
# EU region
#OTEL_EXPORTER_OTLP_ENDPOINT='https://otlp.eu01.nr-data.net'
OTEL_EXPORTER_OTLP_HEADERS="api-key=YOUR_LICENSE_KEY_HERE"

# Service identification
OTEL_SERVICE_NAME=travel-planner
OTEL_SERVICE_VERSION=0.1.0
```

Replace `YOUR_LICENSE_KEY_HERE` with your actual [New Relic License Key](https://one.newrelic.com/launcher/api-keys-ui.api-keys-launcher).

### Step 2: Update Your OpenTelemetry Initialization

Replace the default console exporter with the OTLP exporter:

```python
from opentelemetry.semconv._incubating.attributes.service_attributes import SERVICE_NAME, SERVICE_VERSION
from opentelemetry._logs import set_logger_provider
from opentelemetry.sdk._logs.export import BatchLogRecordProcessor
from opentelemetry.sdk._logs import LoggerProvider, LoggingHandler
from opentelemetry.sdk.resources import Resource
from opentelemetry.exporter.otlp.proto.grpc._log_exporter import OTLPLogExporter
from opentelemetry.exporter.otlp.proto.grpc.metric_exporter import OTLPMetricExporter
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter

# Microsoft Agent Framework
from agent_framework import ChatAgent
from agent_framework.openai import OpenAIChatClient
from agent_framework.observability import setup_observability, get_tracer, get_meter

# Create a resource identifying your service
resource = Resource.create({
    SERVICE_NAME: "travel-planner",
    SERVICE_VERSION: "0.1.0",
    "environment": "production"  # Add any custom attributes
})

# Create OTLP exporters that will auto-read endpoint and headers from environment
# (OTEL_EXPORTER_OTLP_ENDPOINT and OTEL_EXPORTER_OTLP_HEADERS)
otlp_exporters = [
    OTLPSpanExporter(),  # Reads from OTEL_EXPORTER_OTLP_* env vars
    OTLPMetricExporter(),  # Reads from OTEL_EXPORTER_OTLP_* env vars
    OTLPLogExporter(),  # Reads from OTEL_EXPORTER_OTLP_* env vars
]

# Setup observability with the resource
setup_observability(resource, exporters=otlp_exporters)
# Get a tracer
tracer = get_tracer()
```

### Step 3: Configure Metrics and Logging Export (Optional but Recommended)

Add metrics and logs export too:

```python
# Get a meter
meter = get_meter()

# 📝 Configure Logging
logging.basicConfig(level=logging.INFO)
# Create a fresh logger provider with only OTLP exporter
logger_provider = LoggerProvider(resource=resource)
otlp_log_exporter = [e for e in otlp_exporters if type(
    e).__name__ == 'OTLPLogExporter'][0]
logger_provider.add_log_record_processor(
    BatchLogRecordProcessor(otlp_log_exporter))

# Get root logger to configure all loggers
root_logger = logging.getLogger()

# Remove old handlers and add new one with proper OTLP configuration
for handler in root_logger.handlers[:]:
    if isinstance(handler, LoggingHandler):
        root_logger.removeHandler(handler)

# Add new LoggingHandler to root logger (this will capture all loggers including Flask)
handler = LoggingHandler(logger_provider=logger_provider)
root_logger.addHandler(handler)
root_logger.setLevel(logging.INFO)
# set_logger_provider(logger_provider)

# Also attach to our named app logger explicitly
app_logger.addHandler(handler)

# Create a reference for backward compatibility
logger = app_logger
```

### Step 4: Add Custom Attributes for your AI traces and spans

Enhance your spans with AI-specific attributes:

```python
@app.route('/plan', methods=['POST'])
def plan_trip():
    with tracer.start_as_current_span("travel_plan_request") as span:
        # Travel-specific attributes
        duration = request.form.get('duration', '3')
        interests = request.form.getlist('interests')
        
        # Set attributes New Relic can use
        span.set_attribute("travel.duration_days", int(duration))
        span.set_attribute("travel.interests_count", len(interests))
        span.set_attribute("ai.model", model_id)  # Your model name
        span.set_attribute("http.method", "POST")
        span.set_attribute("http.route", "/plan")
        
        # ... rest of your code
```

### Step 5: Test the Connection

```bash
# 1. Make sure .env is loaded
source .env

# 2. Start your app
python web_app.py

# 3. Open the web user interface of our WandewrAI travel planner and submit a travel planning request
http://localhost:5000/

# 4. Check New Relic (wait a few seconds for data to appear)
```

---

## 🔍 Viewing Your Data in New Relic

### 1. Access the Traces

1. Log into **New Relic**
2. Navigate to **All entities** → **Services**
3. Find your service: **travel-planner**
4. Click **Traces**
5. You should see your recent traces!

### 2. Explore a Trace

Click on a trace to see:

- Full timeline of all spans
- Which tools were called
- How long each span took
- Attributes you set

### 3. Search and Filter

Use NRQL to search traces:

```
SELECT * FROM Span 
WHERE entity.name = 'travel-planner'
AND name = 'get_weather'
ORDER BY timestamp DESC
LIMIT 50
```

---

## 📊 Validating Your Integration

You should see:

1. ✅ Traces appearing in New Relic within seconds
2. ✅ Tool spans visible (get_weather, get_datetime, etc.)
3. ✅ Service map showing your app
4. ✅ Metrics like span count, duration, errors
5. ✅ All your custom attributes in trace details

---

## ⚠️ Troubleshooting

**Issue:** Traces not appearing in New Relic

- Check your License Key is correct
- Verify endpoint: `https://otlp.nr-data.net`
- Check app logs for export errors
- Make sure your firewall allows outbound HTTPS

**Issue:** "Connection refused" errors

- Verify internet connectivity
- Check that New Relic endpoint is accessible
- Look at Python logs for detailed error messages

**Issue:** Some attributes missing

- Make sure you're calling `span.set_attribute()` before the span ends
- Check attribute names are valid (lowercase, no spaces)

---

## 🎯 Next Steps in New Relic

Now that you can see traces, explore:

1. **Service Map** - See how services connect
2. **Trace Details** - Dive deep into individual requests
3. **Errors** - View failed requests and errors
4. **Metrics** - See performance over time
5. **Custom Dashboards** (Challenge 5) - Create your own views

---

## ✅ Challenge Checklist

- [ ] OTLP exporter installed
- [ ] New Relic endpoint configured
- [ ] License Key added to .env
- [ ] Tracer provider uses OTLP exporter
- [ ] App runs without errors
- [ ] Make a test request
- [ ] Trace appears in New Relic
- [ ] Custom attributes visible in New Relic
- [ ] Can search and filter traces
- [ ] Team can access New Relic and see traces

---

## 💡 Tips

1. **License Key Security** - Never commit `.env` to git
2. **Batch Exports** - Use BatchSpanProcessor for efficient sending
3. **Test Locally** - Make requests and watch traces appear live
4. **Custom Attributes** - Add anything useful for debugging

---

## 🎉 Milestone Reached

Your WanderAI agents are now **observable at scale**!

- ✅ Challenge 3: Local traces
- ✅ Challenge 4: Traces in New Relic
- **Challenge 5:** Build dashboards and optimize
- **Challenge 6:** Quality gates and automation

Your investors can now see exactly what your AI agents are doing! 📊
