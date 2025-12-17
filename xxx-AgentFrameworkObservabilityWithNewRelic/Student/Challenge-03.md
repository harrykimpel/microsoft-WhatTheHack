# Challenge 03 - Add OpenTelemetry Instrumentation

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

Now that you have a working MVP, it's time to add observability to your WanderAI agents using OpenTelemetry. Right now, if something goes wrong with your agent, you have no visibility into which tool was called, how long operations take, or how to correlate logs to specific requests.

OpenTelemetry is the industry standard for observability in modern applications. By instrumenting your application, you'll be able to see traces showing the full journey of each request, capture timing information, and add structured context to your logs.

## Description

Your goal is to add comprehensive OpenTelemetry instrumentation to your travel planning application. This includes:

- **Initialize OpenTelemetry** - Set up the tracer provider and configure resource attributes to identify your service
- **Instrument Tool Functions** - Wrap each tool function with a span to capture timing and attributes
- **Instrument Flask Routes** - Add spans to your request handlers to track the full request lifecycle
- **Add Structured Logging** - Configure logging with context that correlates to your traces

### What You're Adding

**OpenTelemetry Initialization:**

- Create a resource identifying your service (e.g., "travel-planner")
- Set up the observability framework using the Agent Framework's built-in helpers
- Get a tracer for creating spans

**Tool Instrumentation:**

- Wrap each tool function (`get_random_destination`, `get_weather`, `get_datetime`) with `tracer.start_as_current_span()`
- Add relevant attributes to spans (e.g., location, destination)
- Log information within the span context

**Route Instrumentation:**

- Wrap the `/plan` route handler with a span
- Add request-specific attributes (destination, duration, HTTP method)
- Handle errors and mark spans appropriately

**Logging Configuration:**

- Set up structured logging that includes trace context
- Log meaningful events throughout the request lifecycle

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that OpenTelemetry SDK is initialized in your application
- Demonstrate that traces appear in the console when you make requests
- Show that tool function spans are captured with their attributes
- Verify that Flask route spans include request information
- Demonstrate that logs include trace context for correlation

## Learning Resources

- [OpenTelemetry Concepts](https://opentelemetry.io/docs/concepts/)
- [OpenTelemetry Python Documentation](https://opentelemetry.io/docs/instrumentation/python/)
- [OpenTelemetry Python API - Tracing](https://opentelemetry.io/docs/instrumentation/python/manual/)
- [OTLP Protocol](https://opentelemetry.io/docs/specs/otel/protocol/)
- [Agent Framework Observability](https://learn.microsoft.com/en-us/agent-framework/overview/agent-framework-overview)

## Tips

- Start small - Instrument one tool first, then expand to others
- Check the console - Traces should print when requests complete
- Use meaningful attributes - Include anything that helps debugging
- Don't overload - Every span and log should have a purpose
- Test without the agent first - Make sure basic Flask routes work before adding agent complexity
- The Agent Framework provides helper functions like `setup_observability()`, `get_tracer()`, and `get_meter()` that simplify setup
