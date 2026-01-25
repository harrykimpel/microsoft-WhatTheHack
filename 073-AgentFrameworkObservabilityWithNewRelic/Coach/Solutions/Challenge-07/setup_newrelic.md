# New Relic Setup Guide for Challenge 07

## Prerequisites

- New Relic account (free tier available at https://newrelic.com)
- New Relic License Key (get from: Account Settings → API Keys)
- Python 3.10+

## Step 1: Install New Relic Agent

```bash
pip install newrelic
```

## Step 2: Generate Configuration File

```bash
newrelic-admin generate-config YOUR_LICENSE_KEY newrelic.ini
```

## Step 3: Configure OpenTelemetry Export

Edit `newrelic.ini` or set environment variables:

```bash
export NEW_RELIC_LICENSE_KEY="your-license-key-here"
export NEW_RELIC_APP_NAME="WanderAI-Security"
export OTEL_EXPORTER_OTLP_ENDPOINT="https://otlp.nr-data.net:4317"
export OTEL_EXPORTER_OTLP_HEADERS="api-key=YOUR_LICENSE_KEY"
```

## Step 4: Initialize OpenTelemetry in Your Application

Create `otel_config.py`:

```python
from opentelemetry import trace, metrics
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.sdk.metrics import MeterProvider
from opentelemetry.sdk.metrics.export import PeriodicExportingMetricReader
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.exporter.otlp.proto.grpc.metric_exporter import OTLPMetricExporter
from opentelemetry.sdk.resources import Resource
import os

def initialize_observability():
    """Initialize OpenTelemetry with New Relic backend"""
    
    # Get configuration from environment
    license_key = os.getenv("NEW_RELIC_LICENSE_KEY")
    app_name = os.getenv("NEW_RELIC_APP_NAME", "WanderAI-Security")
    
    if not license_key:
        raise ValueError("NEW_RELIC_LICENSE_KEY environment variable not set")
    
    # Create resource with service information
    resource = Resource.create({
        "service.name": app_name,
        "service.instance.id": os.getenv("HOSTNAME", "local"),
    })
    
    # Configure trace exporter to New Relic
    otlp_exporter = OTLPSpanExporter(
        endpoint="https://otlp.nr-data.net:4317",
        headers={
            "api-key": license_key
        }
    )
    
    # Set up tracer provider
    tracer_provider = TracerProvider(resource=resource)
    tracer_provider.add_span_processor(
        BatchSpanProcessor(otlp_exporter)
    )
    trace.set_tracer_provider(tracer_provider)
    
    # Configure metrics exporter to New Relic
    metric_exporter = OTLPMetricExporter(
        endpoint="https://otlp.nr-data.net:4317",
        headers={
            "api-key": license_key
        }
    )
    
    # Set up meter provider
    metric_reader = PeriodicExportingMetricReader(
        metric_exporter,
        export_interval_millis=60000  # Export every 60 seconds
    )
    meter_provider = MeterProvider(
        resource=resource,
        metric_readers=[metric_reader]
    )
    metrics.set_meter_provider(meter_provider)
    
    print(f"OpenTelemetry initialized for {app_name}")
    print("Exporting to New Relic OTLP endpoint")

# Call this at application startup
if __name__ == "__main__":
    initialize_observability()
```

## Step 5: Update Your Application

Modify your application entry point:

```python
# app.py or main.py
from otel_config import initialize_observability
from secure_agent import SecureAgent
from security_monitoring import SecurityMonitor

# Initialize observability first
initialize_observability()

# Then create your components
monitor = SecurityMonitor(service_name="wanderai-security")
agent = SecureAgent(monitor=monitor, enable_monitoring=True)

# Run your application
if __name__ == "__main__":
    # Your application logic here
    pass
```

## Step 6: Import Dashboard

1. Log in to New Relic
2. Go to **Dashboards** → **Import dashboard**
3. Upload `newrelic_dashboard.json`
4. The dashboard will be created with all security widgets

Alternatively, create widgets manually using the NRQL queries from `nrql_queries.md`

## Step 7: Set Up Alerts

### High Attack Volume Alert

```sql
SELECT count(*) 
FROM PromptInjectionAttempt 
WHERE wasBlocked = true
```

Alert condition: `> 10` in 5 minutes

### High Risk Score Alert

```sql
SELECT max(riskScore) 
FROM PromptInjectionAttempt
```

Alert condition: `> 0.95`

### Detection Performance Alert

```sql
SELECT average(detectionLatencyMs) 
FROM PromptInjectionAttempt
```

Alert condition: `> 200ms`

### To create alerts:

1. Go to **Alerts & AI** → **Alert conditions**
2. Click **Create alert condition**
3. Select **NRQL query**
4. Paste the query above
5. Configure thresholds
6. Set notification channels

## Step 8: Verify Data Flow

Run your application and check:

```bash
python test_injection_attacks.py
```

Then in New Relic:

1. **Explorer** → Find your app → Check for data
2. **Dashboards** → Open security dashboard
3. **Distributed Tracing** → Look for `security.*` spans
4. **Metrics** → Search for `security.prompt_injection.*`
5. **Events** → Query `PromptInjectionAttempt`

Expected: Data should appear within 30-60 seconds

## Step 9: Create Custom Views

### Query Builder Examples

**Recent Attacks:**
```sql
FROM PromptInjectionAttempt 
SELECT timestamp, riskScore, attackType, promptSnippet 
WHERE wasBlocked = true 
SINCE 1 hour ago 
LIMIT 100
```

**Attack Trends:**
```sql
FROM PromptInjectionAttempt 
SELECT count(*) 
FACET attackType 
TIMESERIES 
SINCE 24 hours ago
```

**Performance Impact:**
```sql
FROM Span 
SELECT average(duration) 
WHERE name LIKE 'security%' 
TIMESERIES 
SINCE 1 hour ago
```

## Troubleshooting

### No Data Appearing

1. **Check license key**: Verify `NEW_RELIC_LICENSE_KEY` is set correctly
2. **Check endpoint**: Ensure using `https://otlp.nr-data.net:4317`
3. **Check network**: Verify firewall allows outbound HTTPS
4. **Check logs**: Look for OTLP export errors in application logs
5. **Wait longer**: Initial data can take up to 2 minutes

### Metrics Not Showing

1. **Verify meter provider**: Ensure `metrics.set_meter_provider()` was called
2. **Check export interval**: Default is 60 seconds
3. **Force flush**: Call `meter_provider.force_flush()` to send immediately
4. **Check metric names**: Use exact names from `security_monitoring.py`

### Traces Not Appearing

1. **Verify tracer provider**: Ensure `trace.set_tracer_provider()` was called
2. **Check span processor**: Ensure `BatchSpanProcessor` is added
3. **Force flush**: Call `tracer_provider.force_flush()` before exit
4. **Check sampling**: Verify spans are being created

### Dashboard Queries Failing

1. **Check account ID**: Replace `0` in dashboard JSON with your account ID
2. **Check event names**: Ensure `PromptInjectionAttempt` events are being sent
3. **Check time range**: Extend time range if no recent data
4. **Simplify query**: Test with basic `SELECT * FROM PromptInjectionAttempt`

## Best Practices

1. **Use environment variables** for configuration (don't hardcode keys)
2. **Set appropriate flush intervals** (60s for metrics, batch for traces)
3. **Monitor export errors** in application logs
4. **Set up alerts** before going to production
5. **Test thoroughly** with `test_injection_attacks.py`
6. **Review dashboards daily** to understand attack patterns
7. **Tune thresholds** based on your traffic patterns

## Advanced Configuration

### Use New Relic Python Agent Directly

```python
import newrelic.agent

# Initialize agent
newrelic.agent.initialize('newrelic.ini')

# Record custom events directly
newrelic.agent.record_custom_event('PromptInjectionAttempt', {
    'riskScore': 0.95,
    'attackType': 'direct_override',
    'wasBlocked': True
})
```

### Combine OpenTelemetry + New Relic Agent

```python
# Get both benefits
initialize_observability()  # OpenTelemetry
newrelic.agent.initialize('newrelic.ini')  # New Relic agent

# Now you have:
# - OpenTelemetry standard instrumentation
# - New Relic specific features
# - Custom events and metrics in both
```

## Resources

- [New Relic OpenTelemetry Documentation](https://docs.newrelic.com/docs/more-integrations/open-source-telemetry-integrations/opentelemetry/opentelemetry-introduction/)
- [New Relic Python Agent](https://docs.newrelic.com/docs/apm/agents/python-agent/)
- [NRQL Query Reference](https://docs.newrelic.com/docs/query-your-data/nrql-new-relic-query-language/get-started/introduction-nrql-new-relics-query-language/)
- [Dashboard API](https://docs.newrelic.com/docs/apis/nerdgraph/examples/nerdgraph-dashboards/)

## Support

For issues specific to New Relic integration:
- New Relic Docs: https://docs.newrelic.com
- New Relic Community: https://discuss.newrelic.com
- New Relic Support: https://support.newrelic.com

For issues with the security implementation:
- Refer to Coach's Guide
- Review solution code
- Contact hack facilitators
