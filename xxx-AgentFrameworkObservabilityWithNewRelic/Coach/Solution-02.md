# Challenge 02 - Build Your MVP - Coach's Guide

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

Guide attendees as they build their first agent-powered Flask app from scratch using the Microsoft Agent Framework.

## #Key Points

- Start simple: Minimal Flask app first.
- Agent creation: Use Agent Framework docs.
- Tool registration: Define and register tools.
- Incremental build: Test in small steps.

### Tips

- Check Flask basics understanding.
- Point out common mistakes (e.g., forgetting to register tools).
- Encourage debugging with print/log statements.
- Reference Flask Quickstart and Agent Framework examples.

### Pitfalls

- Overcomplicating the initial app.
- Not testing incrementally.
- Confusing Flask logic with agent logic.

### Success Criteria

- Working Flask app with agent responding to user input.
- At least one tool registered and callable.
- Readable, logically organized code.

### Example solution implementation

The [Example solution implementation](./Solutions/Challenge-02/) folder contains sample implementation of the challenge 2. It contains:

- **[web_app.py](./Solutions/Challenge-02/web_app.py)**: Python Flask web application with Agent framework implementation
- **[templates/index.html](./Solutions/Challenge-02/templates/index.html)**: sample web UI form
- **[templates/result.html](./Solutions/Challenge-02/templates/result.html)**: sample web UI travel planner result view
- **[templates/error.html](./Solutions/Challenge-02/templates/error.html)**: sample web UI error view
- **[static/styles.css](./Solutions/Challenge-02/static/styles.css)**: CSS files for HTML views
