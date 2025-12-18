# Challenge 06 - LLM Evaluation and Quality Gates

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)**

## Introduction

You can't just ship AI without testing. What if the agent returns a non-existent destination? What if the itinerary is way too long or short? What if recommendations are unsafe (war zones, extreme weather)? What if the response includes toxicity or negativity?

In this challenge, you'll build an automated quality gate for your AI agents using New Relic's AI Monitoring platform. Quality gates ensure that only high-quality travel plans reach your customers.

## Description

Your goal is to implement a comprehensive evaluation and quality assurance system for your AI-generated travel plans. This involves several layers of evaluation working together.

### Layer 1: Custom Events for New Relic AI Monitoring

The foundation of enterprise AI evaluation is capturing AI interactions as structured events. New Relic's AI Monitoring uses a special attribute `newrelic.event.type` that automatically populates:

- **Model Inventory** - Track every LLM and version used
    [New Relic Model Inventory](https://docs.newrelic.com/docs/ai-monitoring/explore-ai-data/view-model-data/#model-inventory)
    ![Model Inventory Screenshot](../Images/newrelic-ai-monitoring-model-inventory.png)
- **Model Comparison** - Compare quality across models
    [New Relic Model Comparison](https://docs.newrelic.com/docs/ai-monitoring/explore-ai-data/compare-model-performance/)
    ![Model Comparison Screenshot](../Images/newrelic-ai-monitoring-model-comparison.png)
- **Quality Evaluation** - Detect issues like toxicity and safety concerns
    [New Relic LLM Evaluation](https://docs.newrelic.com/docs/ai-monitoring/explore-ai-data/view-model-data/#llm-evaluation)
    ![LLM Evaluation Screenshot](../Images/newrelic-ai-monitoring-llm-evaluation.png)

    ![LLM Evaluation Settings Screenshot](../Images/newrelic-ai-monitoring-llm-evaluation-settings.png)
- **Insights Dashboards** - See AI behavior and trends

You need to emit three custom events after each LLM interaction:

- `LlmChatCompletionMessage` for the user prompt (role: "user", sequence: 0)
- `LlmChatCompletionMessage` for the LLM response (role: "assistant", sequence: 1)
- `LlmChatCompletionSummary` for the summary of the interaction

### Layer 2: Rule-Based Evaluation

Implement deterministic checks against business rules:

- Response must include day-by-day structure
- Response must include weather information
- Response length must be within reasonable bounds (not too short, not too long)
- Response must include required sections (accommodation, transportation)

### Layer 3: LLM-Based Quality Evaluation (Optional)

Use another LLM to evaluate responses for:

- **Safety** - Recommendations should avoid dangerous conditions
- **Accuracy** - Plausible destinations and activities
- **Completeness** - Addresses all user requirements

### Layer 4: Integration into Your Application

Integrate the evaluation system into your Flask application:

- Run evaluation after generating each travel plan
- Track evaluation metrics (passed/failed, scores)
- Optionally block low-quality responses from reaching users

### Accessing New Relic AI Monitoring

Once you emit the custom events, you can access New Relic's curated AI Monitoring experience:

- **Model Inventory** - See all models used, versions, vendors
- **Model Comparison** - Compare performance across models
- **LLM Evaluation** - See toxicity, negativity, and quality issues detected automatically

**Hint**: You may need to pin the "AI Monitoring" section in New Relic's sidebar via "All capabilities" to see it.
![AI Monitoring Sidebar Screenshot](../Images/newrelic-ai-monitoring.png)

## Success Criteria

To complete this challenge successfully, you should be able to:

- Demonstrate that custom events (`LlmChatCompletionMessage`, `LlmChatCompletionSummary`) are being sent to New Relic
- Show that the Model Inventory in New Relic displays your models
- Verify that rule-based evaluation is running on generated travel plans
- Demonstrate that evaluation metrics are being tracked (passed/failed counts, scores)
- Show that you can view AI monitoring data in New Relic's AI Monitoring section

## Learning Resources

- [New Relic AI Monitoring](https://docs.newrelic.com/docs/ai-monitoring/intro-to-ai-monitoring/)
- [New Relic Custom Events](https://docs.newrelic.com/docs/data-apis/custom-data/custom-events/report-custom-event-data/)
- [LLM Evaluation Best Practices](https://docs.newrelic.com/docs/ai-monitoring/explore-ai-data/view-model-data/)
- [GitHub Actions CI/CD](https://docs.github.com/en/actions)

## Tips

- Start with the custom events first - they unlock the AI Monitoring features in New Relic
- Include trace correlation (span_id, trace_id) in your custom events to link them to your traces
- Rule-based evaluation is fast and deterministic - use it for basic quality checks
- LLM-based evaluation is more expensive but catches subtle issues
- Consider caching evaluation results for identical responses
- Look for the "AI Monitoring" section in New Relic's sidebar (you may need to pin it via "All capabilities")

## Advanced Challenges (Optional)

- Set up a CI/CD pipeline with GitHub Actions that runs evaluation tests before deployment
- Implement A/B testing to compare two agent versions and their quality scores
- Add a feedback loop that lets users rate plans and uses ratings in evaluation
- Create custom dashboards showing evaluation trends over time
- Implement automatic prompt tuning based on evaluation results
