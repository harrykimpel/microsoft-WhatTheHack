# Challenge 04 - New Relic Integration - Coach's Guide

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)** - [Next Solution >](./Solution-05.md)

## Notes & Guidance

Guide attendees to integrate their instrumented app with New Relic using OTLP for backend monitoring.

### Key Points

- OTLP export: Configure OpenTelemetry to export to New Relic.
- Backend monitoring: Value of centralized monitoring and alerting.
- Troubleshooting: Help resolve integration issues (API keys, endpoints).

### Tips

- Provide New Relic account setup instructions.
- Show how to view traces/metrics in New Relic dashboard.
- Encourage setting up basic alerts/dashboards.

### Pitfalls

- Incorrect endpoint or API key.
- Not verifying data in New Relic.

### Success Criteria

- App exports observability data to New Relic.
- Attendees can view traces/metrics/logs in curated experiences and dashboards.

### Example solution implementation

The [Example solution implementation](./Solutions/Challenge-04/) folder contains sample implementation of the challenge 2. It contains:

- **[web_app.py](./Solutions/Challenge-04/web_app.py)**: Python Flask web application with Agent framework implementation
- **[templates/index.html](./Solutions/Challenge-04/templates/index.html)**: sample web UI form
- **[templates/result.html](./Solutions/Challenge-04/templates/result.html)**: sample web UI travel planner result view
- **[templates/error.html](./Solutions/Challenge-04/templates/error.html)**: sample web UI error view
- **[static/styles.css](./Solutions/Challenge-04/static/styles.css)**: CSS files for HTML views

---

## Common Issues & Troubleshooting

### Issue 1: No Data Appearing in New Relic

**Symptom:** App runs, but New Relic shows no traces/metrics
**Cause:** OTLP endpoint or API key misconfigured
**Solution:**

- Verify `OTEL_EXPORTER_OTLP_ENDPOINT` is set to `https://otlp.nr-data.net:4317`
- Check `OTEL_EXPORTER_OTLP_HEADERS` includes `api-key=<YOUR_LICENSE_KEY>`
- Ensure license key is an INGEST key (not a User key)
- Test connectivity: `curl -v https://otlp.nr-data.net:4317`
- Wait 1-2 minutes for data to appear (initial delay is normal)

### Issue 2: 401/403 Authentication Errors

**Symptom:** Exporter logs show authentication failures
**Cause:** Invalid or wrong type of New Relic license key
**Solution:**

- Get a new INGEST license key from New Relic: API Keys → Create key → Ingest - License
- Check for extra whitespace or quotes in the key
- Verify the key matches the account you're viewing in New Relic
- For EU accounts, use `https://otlp.eu01.nr-data.net:4317`

### Issue 3: gRPC Connection Errors

**Symptom:** `grpc._channel._InactiveRpcError` or connection refused
**Cause:** Firewall blocking gRPC or wrong port
**Solution:**

- Ensure port 4317 (gRPC) is not blocked by firewall
- Try HTTP endpoint: `https://otlp.nr-data.net:4318/v1/traces`
- Check if corporate proxy requires configuration
- Verify no VPN is interfering with the connection

### Issue 4: Traces Appear But No Metrics/Logs

**Symptom:** Only some signal types visible in New Relic
**Cause:** Separate exporters needed for each signal type
**Solution:**

- Create separate OTLP exporters for traces, metrics, and logs
- Verify all three are passed to `configure_otel_providers()`
- Check New Relic for each signal type separately
- Ensure BatchProcessors are configured for each

### Issue 5: Service Name Not Showing Correctly

**Symptom:** Data appears under wrong service name or "unknown_service"
**Cause:** Resource attributes not set correctly
**Solution:**

- Set `SERVICE_NAME` in Resource: `Resource.create({SERVICE_NAME: "travel-planner"})`
- Verify resource is passed to all providers (tracer, meter, logger)
- Check `service.name` attribute in New Relic trace details

---

## What Participants Struggle With

- **Finding the Right Endpoint:** Help them understand US vs EU endpoints and gRPC vs HTTP
- **License Key Types:** Explain the difference between Ingest keys and User API keys
- **Waiting for Data:** Set expectations that first data may take 1-2 minutes to appear
- **Navigating New Relic UI:** Show them where to find: APM, Distributed Tracing, Metrics Explorer, Logs
- **Understanding OTLP:** Explain it's a standard protocol, not New Relic-specific

---

## Time Management

**Expected Duration:** 45 minutes
**Minimum Viable:** 30 minutes (traces appearing in New Relic)
**Stretch Goals:** +15 minutes (verify all signal types, explore New Relic features)

---

## Validation Checklist

Coach should verify participants have:

- [ ] Environment variables set for OTLP endpoint and API key
- [ ] OTLP exporters created for traces, metrics, and logs
- [ ] App runs without exporter errors in console
- [ ] Traces visible in New Relic Distributed Tracing
- [ ] Service name appears correctly in New Relic APM
- [ ] Can navigate to a specific trace and see span details
- [ ] Metrics visible in Metrics Explorer (if implemented)
- [ ] Logs visible and correlated with traces (if implemented)
