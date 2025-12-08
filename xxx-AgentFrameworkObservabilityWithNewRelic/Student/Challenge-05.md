# Challenge 05 - Monitoring Best Practices

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## 🎯 Objective

Level up your observability game! Learn industry best practices for monitoring AI-driven applications.

By the end of this challenge:

- ✅ Custom dashboards tailored to travel planning
- ✅ Alerts that notify you when things go wrong
- ✅ Key metrics tracked (latency, errors, token usage)
- ✅ Smart analysis of agent behavior
- ✅ Actionable insights from your data

---

## 🤔 Why This Matters

You're now sending telemetry to New Relic, but without **dashboards** and **alerts**:

- ❌ You're manually checking traces all the time
- ❌ You don't notice problems until customers complain
- ❌ You can't track performance trends over time
- ❌ You don't know which agents are slow/fast

Best practices turn raw telemetry into **actionable intelligence**!

---

## 📚 Key Concepts

### 1. Dashboards

A **dashboard** is a visual summary of your system's health:

- Response time trends
- Error rates
- Tool usage patterns
- Customer satisfaction metrics

### 2. Alerts

An **alert** notifies you when something is wrong:

- Average response time exceeds threshold
- Error rate spikes
- Tool fails repeatedly
- LLM token usage is high

### 3. Metrics Worth Tracking

For a travel planning agent, you want to know:

- **Latency** - Is the agent responding fast?
- **Errors** - What's failing and why?
- **Tool Usage** - Which tools are most called?
- **Token Usage** - How expensive are we?
- **Quality** - Are responses good? (we'll improve this in Challenge 6)

---

## 🛠️ Part 1: Create a Dashboard

### Step 1: Add More Instrumentation

Before building dashboards, enhance your metrics collection:

```python
# In your web_app.py, after tracer setup:

meter = get_meter()

# Create custom counters and histograms
request_counter = meter.create_counter(
    name="travel_plan.requests.total",
    description="Total number of travel plan requests",
    unit="1"
)

error_counter = meter.create_counter(
    name="travel_plan.errors.total",
    description="Total number of errors",
    unit="1"
)

response_time_histogram = meter.create_histogram(
    name="travel_plan.response_time_ms",
    description="Travel plan response time in milliseconds",
    unit="ms"
)

tool_call_counter = meter.create_counter(
    name="travel_plan.tool_calls.total",
    description="Number of tool calls by tool name",
    unit="1"
)
```

### Step 2: Emit Metrics from Your Code

```python
import time

@app.route('/plan', methods=['POST'])
def plan_trip():
    start_time = time.time()
    request_counter.add(1, {"destination": destination})
    
    with tracer.start_as_current_span("travel_plan_request") as span:
        try:
            # ... your agent code ...
            
            # Track successful request
            elapsed_ms = (time.time() - start_time) * 1000
            response_time_histogram.record(elapsed_ms)
            
            return render_template('result.html', travel_plan=text_content)
            
        except Exception as e:
            error_counter.add(1, {"error_type": type(e).__name__})
            return render_template('error.html', error=str(e)), 500

def get_weather(location: str) -> str:
    with tracer.start_as_current_span("get_weather") as span:
        tool_call_counter.add(1, {"tool_name": "get_weather"})
        # ... your weather code ...
        return result
```

### Step 3: Create a New Relic Dashboard

1. Go to **New Relic** → **Dashboards** → **Create Dashboard**
2. Name it: "WanderAI Agent Performance"
3. Add widgets for:

#### **Widget 1: Request Rate**

```sql
SELECT rate(count(*), 1 minute) FROM Metric 
WHERE metricName = 'travel_plan.requests.total'
TIMESERIES
```

#### **Widget 2: Error Rate**

```sql
SELECT rate(count(*), 1 minute) FROM Metric 
WHERE metricName = 'travel_plan.errors.total'
TIMESERIES
```

#### **Widget 3: Average Response Time**

```sql
SELECT average(travel_plan.response_time_ms) 
FROM Metric 
TIMESERIES
```

#### **Widget 4: Tool Usage Breakdown**

```sql
SELECT count('travel_plan.tool_calls.total') FROM Metric 
WHERE metricName = 'travel_plan.tool_calls.total'
FACET tool_name
```

#### **Widget 5: Trace Count by Service**

```sql
SELECT count(*) FROM Span 
WHERE entity.name like '%travel-planner%'
FACET name 
TIMESERIES
```

---

## 🛠️ Part 2: Set Up Alerts

### Alert 1: High Error Rate

```sql
ALERT "High Error Rate in Travel Planner"

Trigger when:
SELECT count(*) FROM Metric
WHERE metricName = 'travel_plan.errors.total'

Is above 5 in 5 minutes

Notify: #ops-team in Slack
```

### Alert 2: Slow Response Times

```sql
ALERT "Slow Travel Plan Response"

Trigger when:
SELECT percentile(travel_plan.response_time_ms, 95) 
FROM Metric

Is above 25,000 (milliseconds)

Notify: #ops-team in Slack
```

### Alert 3: Tool Failures

```sql
ALERT "Weather Tool Failing"

Trigger when:
SELECT count(*) FROM Span 
WHERE gen_ai.tool.name = 'get_weather' AND error = true 

Is above 3 in 10 minutes

Notify: #backend-team in Slack
```

---

## 📊 Part 3: Analysis & Insights

### Key Metrics to Monitor

| Metric | Why It Matters | Target |
|--------|---|---|
| Response Time (p95) | Speed affects UX | < 3 seconds |
| Error Rate | Reliability | < 1% |
| Token Usage (avg) | Cost per request | < 500 tokens |
| Tool Success Rate | Accuracy | > 95% |
| Destination Diversity | Is agent varied? | > 8 different destinations |

### Custom NRQL Queries

#### **Query 1: Average token usage by model**

```sql
SELECT 
    average(gen_ai.usage.input_tokens) as 'Input tokens', 
    average(gen_ai.usage.output_tokens) as 'Output tokens', 
    average(gen_ai.usage.input_tokens+gen_ai.usage.output_tokens) as 'Total tokens'
FROM Span
facet gen_ai.response.model
```

#### **Query 2: Slowest tools**

```sql
SELECT average(duration.ms)
FROM Span
WHERE name IN  ('execute_tool get_weather','execute_tool get_datetime', 'execute_tool get_random_destination')
FACET name
TIMESERIES
```

#### **Query 3: Error breakdown**

```sql
SELECT count(*)
FROM Log
WHERE service.name like '%travel-planner%' 
AND message like '%error%'
SINCE 1 week ago
FACET message 
```

---

## ✅ Best Practices Checklist

### Instrumentation

- [ ] Counter metrics for requests
- [ ] Histogram metrics for timing
- [ ] Error tracking
- [ ] Tool-level instrumentation

### Dashboards

- [ ] Service overview (requests, errors, latency)
- [ ] Tool performance breakdown
- [ ] Error trends
- [ ] Resource usage (tokens, API calls)

### Alerts

- [ ] Alert for high error rate
- [ ] Alert for slow responses
- [ ] Alert for tool failures
- [ ] Alerts route to appropriate team (Slack/PagerDuty)

### Analysis

- [ ] Regular review of metrics
- [ ] Identify slow/problematic tools
- [ ] Track improvement over time
- [ ] Share insights with team

---

## 💡 Pro Tips

1. **Naming** - Use consistent, hierarchical names (travel_plan.*)
2. **Baselines** - Know what "normal" looks like before problems occur
3. **Alerts** - Start conservative, tune as you learn
4. **Dashboards** - Keep them focused; don't overwhelm with too many charts

---

## 🎯 Real-World Example

Let's say your dashboard shows:

- ✅ Request rate: 50/min (growing!)
- ❌ p95 latency: 4.2 seconds (was 2.5s yesterday)
- ⚠️ Error rate: 0.8% (threshold is 1%)

**Action Items:**

1. Check which tool is slow (dashboard shows `get_weather` is 3.0s)
2. Review `get_weather` traces in New Relic
3. Maybe the weather API is slow? Rate-limited?
4. Consider caching or a different API
5. Monitor the fix over the next hour

**This is production monitoring in action!** 🎯

---

## 🚀 Advanced (Optional)

### Service Level Indicators (SLIs)

Define what "good performance" means:

```
Travel Plan SLI:
- Latency: p95 < 3s
- Error: < 0.5%  
- Availability: > 99.5%
```

### Service Level Objectives (SLOs)

```
SLO: 99% of requests respond in < 3s
SLO: 99.5% of requests succeed
```

Create alerts for SLO violations to catch issues early!

---

## ✅ Challenge Checklist

- [ ] Enhanced metrics collection in code
- [ ] Metrics exported to New Relic
- [ ] Dashboard created with 5+ widgets
- [ ] At least 3 alerts configured
- [ ] Alerts connected to Slack/notification system
- [ ] Dashboards reviewed with team
- [ ] Custom NRQL queries written
- [ ] Team trained on dashboard usage

---

## 🎉 You're Now Production-Ready

With dashboards and alerts:

- ✅ Your team sees system health at a glance
- ✅ Problems are caught automatically
- ✅ You can correlate issues to root causes
- ✅ You're ready for customers!

**Next:** Challenge 6 - Quality gates to ensure AI outputs meet standards! ✅
