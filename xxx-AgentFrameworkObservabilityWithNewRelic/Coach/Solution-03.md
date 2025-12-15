# Challenge 03 - Add OpenTelemetry Instrumentation - Coach's Guide

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

Help attendees instrument their agent app with OpenTelemetry for traces, metrics, and logs.

### Key Points

- Observability setup: Instrument Flask app and agent logic.
- Traces, metrics, logs: Understand and implement each.
- Debugging: Use observability to diagnose agent-tool issues.

### Tips

- Demonstrate OpenTelemetry setup if needed.
- Encourage checking traces/logs during testing.
- Discuss real-world observability scenarios.
- Reference OpenTelemetry docs and examples.

### Pitfalls

- Instrumenting only part of the app.
- Not verifying traces/logs output.

### Success Criteria

- App emits traces, metrics, and logs for key operations.
- Attendees can explain observability's role in debugging and monitoring.

### Example solution implementation

The [Example solution implementation](./Solutions/Challenge-03/) folder contains sample implementation of the challenge 2. It contains:

- **[web_app.py](./Solutions/Challenge-03/web_app.py)**: Python Flask web application with Agent framework implementation
- **[templates/index.html](./Solutions/Challenge-03/templates/index.html)**: sample web UI form
- **[templates/result.html](./Solutions/Challenge-03/templates/result.html)**: sample web UI travel planner result view
- **[templates/error.html](./Solutions/Challenge-03/templates/error.html)**: sample web UI error view
- **[static/styles.css](./Solutions/Challenge-03/static/styles.css)**: CSS files for HTML views

---

## Common Issues & Troubleshooting

### Issue 1: No Traces/Spans Appearing

**Symptom:** Code runs but no telemetry data is generated
**Cause:** OpenTelemetry not initialized or exporters not configured
**Solution:**

- Verify `setup_observability()` is called before creating tracer/meter
- Check that `get_tracer()` and `get_meter()` are called after setup
- Ensure spans are created with `with tracer.start_as_current_span("name"):`
- Add a console exporter temporarily to verify data is being generated

### Issue 2: Import Errors for OpenTelemetry

**Symptom:** `ModuleNotFoundError: No module named 'opentelemetry'`
**Cause:** OpenTelemetry packages not installed
**Solution:**

- Run `pip install opentelemetry-api opentelemetry-sdk`
- Install exporters: `pip install opentelemetry-exporter-otlp`
- Check requirements.txt includes all OTel dependencies
- Restart Python/terminal after installing

### Issue 3: Spans Not Nested Correctly

**Symptom:** Traces show flat structure instead of parent-child relationships
**Cause:** Context not propagated between spans
**Solution:**

- Use `with` statement for automatic context management
- Ensure child spans are created inside parent span's `with` block
- Don't create new event loops inside span contexts
- Use `tracer.start_as_current_span()` not `tracer.start_span()`

### Issue 4: Metrics Not Recording

**Symptom:** Counters/histograms created but values always zero
**Cause:** Metrics not being called or meter not configured
**Solution:**

- Verify `.add()` or `.record()` is actually being called
- Check that metric names don't have invalid characters
- Ensure meter is created from the same provider as tracer
- Add debug logging to confirm metric recording code executes

### Issue 5: Logs Not Correlating with Traces

**Symptom:** Logs appear but aren't linked to traces in backend
**Cause:** Logger not configured with OpenTelemetry handler
**Solution:**

- Add `LoggingHandler` from opentelemetry to root logger
- Include span context in log records
- Use structured logging with `extra={}` parameter
- Reference solution code for correct logging setup

---

## What Participants Struggle With

- **Understanding Span Hierarchy:** Use diagrams to show parent-child span relationships
- **Where to Add Instrumentation:** Guide them to instrument: HTTP requests, agent runs, tool calls, external API calls
- **Metric Types:** Explain when to use counters (events) vs. histograms (durations/distributions)
- **Attribute Naming:** Encourage semantic conventions (e.g., `http.method`, `destination.name`)
- **Too Much vs. Too Little:** Help them find balance—not every line needs a span

---

## Time Management

**Expected Duration:** 1 hour
**Minimum Viable:** 45 minutes (traces for main request flow)
**Stretch Goals:** +30 minutes (metrics, custom attributes, log correlation)

---

## Validation Checklist

Coach should verify participants have:

- [ ] OpenTelemetry SDK properly initialized with resource attributes
- [ ] Tracer created and spans wrap key operations (request handler, agent run, tool calls)
- [ ] Spans include relevant attributes (destination, duration, token count)
- [ ] At least one metric (counter or histogram) is recording data
- [ ] Logs include trace context for correlation
- [ ] Can explain what each span represents in the request flow
- [ ] Console or debug output shows telemetry is being generated
