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
