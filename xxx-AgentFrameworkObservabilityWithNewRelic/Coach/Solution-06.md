# Challenge 06 - LLM Evaluation & Quality Gates - Coach's Guide

[< Previous Solution](./Solution-05.md) - **[Home](./README.md)**

## Notes & Guidance

Guide attendees to implement the core of New Relic's AI Monitoring platform: custom events that unlock model inventory, comparison, and LLM-based quality evaluation (toxicity, negativity, safety).

## Core Concept: Custom Events as Foundation

The `newrelic.event.type` attribute in logger.info() calls is THE mechanism that:

- **Populates Model Inventory** - Tracks every LLM and version
- **Enables Model Comparison** - Compares performance across models
- **Powers Quality Dashboards** - Shows AI behavior and trends
- **Unlocks LLM Evaluation** - Integrates toxicity/negativity checks

## Key Points

1. **Custom Events First** - Emit `LlmChatCompletionMessage` (2x) and `LlmChatCompletionSummary`
2. **LLM-Based Evaluation** - Use another LLM to check responses for toxicity, negativity, safety
3. **Rule-Based Checks** - Add business logic validation (structure, completeness, etc.)
4. **CI/CD Integration** - Automate quality gates and block bad responses

## Implementation Path

- Reference: `web_app.py` lines 439-509 (custom events template)
- Create `evaluation.py` with TravelPlanEvaluator class
- Integrate evaluation into Flask routes
- Add metrics/counters for New Relic dashboard
- Test with different models and prompts

## Tips

- Start with the custom events—everything else builds on them.
- Show attendees how to view events in New Relic.
- Demonstrate LLM evaluation catching toxicity/negativity (run with `NEGATIVITY_PROMPT_ENABLE=true`).
- Explain model inventory and comparison features.

## Common Pitfalls

- Skipping custom events (missing the core value).
- Not testing LLM-based evaluation thoroughly.
- Overcomplicating rule-based checks.
- Not setting up metrics in New Relic.

## Success Criteria

- Custom events are emitted for every LLM interaction.
- Model inventory and comparison visible in New Relic.
- LLM-based evaluation detects toxicity/negativity.
- Rule-based checks work for business logic.
- Quality metrics displayed in dashboard.
- Attendees understand how New Relic AI Monitoring works.
