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
