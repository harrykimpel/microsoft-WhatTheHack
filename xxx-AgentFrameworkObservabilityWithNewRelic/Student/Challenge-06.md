# Challenge 06 - LLM Evaluation & Quality Gates

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)**

## 🎯 Objective

Build an automated quality gate for your AI agents! Ensure only good travel plans reach customers using New Relic's AI Monitoring platform.

By the end of this challenge:

- ✅ Unlock New Relic's AI Monitoring with custom events
- ✅ Build model inventory and compare LLM performance
- ✅ Evaluate responses for toxicity, negativity, and quality issues
- ✅ Create automated quality gates that block bad responses
- ✅ Monitor AI behavior with custom dashboards and alerts

---

## 🔑 The Core: New Relic AI Monitoring Custom Events

The foundation of enterprise AI evaluation is **capturing AI interactions as structured events**. New Relic's AI Monitoring uses a special attribute: `newrelic.event.type`.

When you log events with this attribute, New Relic automatically:

- 📊 Creates a **Model Inventory** - Track every LLM and version used
- 🔍 Enables **Model Comparison** - Compare quality across models
- 🛡️ Powers **Quality Evaluation** - Detect issues like toxicity, safety concerns
- 📈 Builds **Insights Dashboards** - See AI behavior and trends

### The Three Core Events

Your application logs three custom events after each LLM interaction:

```python
# Event 1: User message input
logger.info("[agent_response]", extra={
    "newrelic.event.type": "LlmChatCompletionMessage",
    "content": user_prompt,
    "role": "user",
    "sequence": 0,
    "is_response": False,
    "response.model": "gpt-4o-mini",
    "vendor": "openai",
    # ... trace/span context ...
})

# Event 2: Assistant response output
logger.info("[agent_response]", extra={
    "newrelic.event.type": "LlmChatCompletionMessage",
    "content": assistant_response,
    "role": "assistant",
    "sequence": 1,
    "is_response": True,
    "response.model": "gpt-4o-mini",
    "vendor": "openai",
    # ... trace/span context ...
})

# Event 3: Summary of the interaction
logger.info("[agent_response]", extra={
    "newrelic.event.type": "LlmChatCompletionSummary",
    "request.model": "gpt-4o-mini",
    "response.model": "gpt-4o-mini",
    "token_count": 1245,
    "response.number_of_messages": 2,
    "response.choices.finish_reason": "stop",
    "vendor": "openai",
    # ... trace/span context ...
})
```

**This is THE mechanism** that powers:

- Model tracking and inventory
- Token usage monitoring
- Quality detection (via LLM-based evaluation on the content)
- Comparative analysis across models and versions

---

## 🤔 Why This Matters

You can't just ship AI without testing. Consider:

- ❌ What if the agent returns a non-existent destination?
- ❌ What if the itinerary is way too long or short?
- ❌ What if recommendations are unsafe (war zones, extreme weather)?
- ❌ What if the response includes toxicity or negativity?

**Quality gates** ensure the AI meets standards before customers see it!

---

## 📚 Background Reading

1. **[New Relic AI Monitoring](https://docs.newrelic.com/docs/ai-monitoring/intro-to-ai-monitoring/)**
   - Overview of AI Monitoring capabilities

2. **[New Relic Custom Events](https://docs.newrelic.com/docs/data-apis/custom-data/custom-events/report-custom-event-data/)**
   - How to send custom events to New Relic

3. **[LLM Evaluation Best Practices](https://docs.newrelic.com/docs/ai-monitoring/explore-ai-data/view-model-data/)**
   - Quality assessment and safety evaluation

4. **[GitHub Actions CI/CD](https://docs.github.com/en/actions)**
   - Automation in your repository

---

## 🎯 Evaluation Layers: From Events to Insights

### Layer 1: Custom Events (The Foundation)

First, emit the three custom events (`LlmChatCompletionMessage` x2, `LlmChatCompletionSummary`). This tells New Relic about every LLM interaction and **unlocks model inventory & comparison features**.

See `web_app.py` (lines 439-509) for the exact implementation. This is your baseline for all AI Monitoring.

### Layer 2: LLM-Based Quality Evaluation

Use another LLM to evaluate responses for **safety, toxicity, and quality issues**:

```python
from agent_framework import ChatAgent
from agent_framework.openai import OpenAIChatClient

async def evaluate_response_quality(travel_plan: str, destination: str) -> dict:
    """Use LLM to evaluate response for toxicity, negativity, safety."""
    
    evaluator = ChatAgent(
        chat_client=OpenAIChatClient(
            api_key=os.environ.get("OPENAI_API_KEY"),
            model_id="gpt-4o"  # Use a good model for evaluation
        ),
        instructions="""You are a quality assurance expert evaluating AI-generated travel plans.
        
Analyze the response for:
1. **Toxicity** - Does it contain offensive, rude, or harmful language?
2. **Negativity** - Is the tone unnecessarily negative or discouraging?
3. **Safety** - Are recommendations safe (no war zones, extreme weather warnings)?
4. **Accuracy** - Are destinations and recommendations plausible?
5. **Completeness** - Does it address the user's request fully?

Return ONLY a JSON object with your assessment."""
    )
    
    evaluation_prompt = f"""
Evaluate this travel plan for {destination}:

{travel_plan}

Return JSON with:
{{
    "toxicity_score": <0-10>,
    "negativity_score": <0-10>,
    "safety_score": <0-10>,
    "accuracy_score": <0-10>,
    "completeness_score": <0-10>,
    "pass": <true/false>,
    "issues": [<list of specific concerns>],
    "recommendation": "<APPROVE|REVIEW|REJECT>"
}}

Scores: 0=bad, 10=good. Issues should be specific and actionable.
"""
    
    response = await evaluator.run(evaluation_prompt)
    # Parse JSON from response and return
    return json.loads(response.messages[-1].contents[0].text)
```

### Layer 3: Rule-Based Evaluation

Check outputs against business rules (deterministic):

```python
def evaluate_travel_plan(response: str) -> dict:
    """Evaluate travel plan against quality rules."""
    
    results = {
        "passed": True,
        "issues": [],
        "score": 100
    }
    
    # Rule 1: Response must mention at least 2 activities
    if response.count("Day") < 1:
        results["issues"].append("No day-by-day structure found")
        results["passed"] = False
        results["score"] -= 30
    
    # Rule 2: Response must include weather
    if "weather" not in response.lower():
        results["issues"].append("Weather information missing")
        results["passed"] = False
        results["score"] -= 20
    
    # Rule 3: Response length sanity check
    words = len(response.split())
    if words < 100 or words > 2000:
        results["issues"].append(f"Response too short/long ({words} words)")
        results["passed"] = False
        results["score"] -= 15
    
    # Rule 4: Response must include specific sections
    required_sections = ["day 1", "day 2", "accommodation", "transportation"]
    for section in required_sections:
        if section.lower() not in response.lower():
            results["issues"].append(f"Missing section: {section}")
            results["score"] -= 10
    
    return results
```

### Layer 4: Data-Driven Evaluation

Track real metrics over time (user feedback and quality trends):

```python
class TravelPlanMetrics:
    """Track quality metrics of generated travel plans."""
    
    def __init__(self, datafile="metrics.json"):
        self.datafile = datafile
    
    def record(self, destination: str, response: str, was_rated: bool = None, rating: int = None):
        """Record a travel plan evaluation."""
        metrics = {
            "timestamp": datetime.now().isoformat(),
            "destination": destination,
            "word_count": len(response.split()),
            "has_weather": "weather" in response.lower(),
            "has_itinerary": "day" in response.lower(),
            "rating": rating,  # 1-5 from customer feedback
            "was_rated": was_rated
        }
        
        # Save to file or database
        with open(self.datafile, 'a') as f:
            f.write(json.dumps(metrics) + "\n")
    
    def get_average_rating(self, days=7) -> float:
        """Get average customer rating over last N days."""
        # Load metrics, filter by date, calculate average
        # This gives you real user feedback on quality
        pass
```

---

## 🛠️ Building Your Quality Gate with New Relic AI Monitoring

### Step 1: Emit Custom Events (The Foundation)

Implement the three custom event types in your agent's response handler. Use the reference in `web_app.py` (lines 439-509) as your template:

```python
import logging
import uuid
from opentelemetry.trace.span import format_trace_id

logger = logging.getLogger("travel_planner")

async def run_agent(user_prompt: str):
    """Run agent and emit New Relic AI Monitoring events."""
    
    with tracer.start_as_current_span("run_agent") as current_span:
        # Run the agent
        response = await agent.run(user_prompt)
        text_content = response.messages[-1].contents[0].text
        
        # Extract span context for trace correlation
        span_id = format(current_span.get_span_context().span_id, "016x")
        trace_id = format_trace_id(current_span.get_span_context().trace_id)
        
        # Event 1: User message
        logger.info("[agent_response]", extra={
            "newrelic.event.type": "LlmChatCompletionMessage",
            "content": user_prompt,
            "role": "user",
            "sequence": 0,
            "is_response": False,
            "response.model": "gpt-4o-mini",
            "vendor": "openai",
            "span_id": span_id,
            "trace_id": trace_id,
            "completion_id": str(uuid.uuid4()),
        })
        
        # Event 2: Assistant response
        logger.info("[agent_response]", extra={
            "newrelic.event.type": "LlmChatCompletionMessage",
            "content": text_content,
            "role": "assistant",
            "sequence": 1,
            "is_response": True,
            "response.model": "gpt-4o-mini",
            "vendor": "openai",
            "span_id": span_id,
            "trace_id": trace_id,
            "completion_id": str(uuid.uuid4()),
        })
        
        # Event 3: Summary
        logger.info("[agent_response]", extra={
            "newrelic.event.type": "LlmChatCompletionSummary",
            "request.model": "gpt-4o-mini",
            "response.model": "gpt-4o-mini",
            "token_count": response.usage_details.input_token_count + response.usage_details.output_token_count,
            "response.number_of_messages": 2,
            "response.choices.finish_reason": "stop",
            "vendor": "openai",
            "span_id": span_id,
            "trace_id": trace_id,
        })
    
    return response
```

**Why this matters:** These custom events automatically populate:

- 📊 **Model Inventory** - All models used (gpt-4o-mini, gpt-4o, etc.)
- 🔄 **Model Comparison** - Performance across models
- 📈 **Token Usage Dashboard** - Monitor cost and efficiency
- 🔍 **Interaction Log** - Every user/assistant message pair

### Step 2: Create Quality Evaluation Module

```python
import asyncio
import json
from agent_framework import ChatAgent
from agent_framework.openai import OpenAIChatClient

class TravelPlanEvaluator:
    """Evaluates generated travel plans for quality, safety, and tone."""
    
    def __init__(self):
        self.evaluator_agent = ChatAgent(
            chat_client=OpenAIChatClient(
                api_key=os.environ.get("OPENAI_API_KEY"),
                model_id="gpt-4o"
            ),
            instructions="""You are a quality assurance expert evaluating AI-generated travel plans.
            
Analyze responses for:
1. Toxicity - offensive, rude, or harmful language
2. Negativity - unnecessarily negative tone
3. Safety - recommendations (no war zones, dangerous conditions)
4. Accuracy - plausible destinations and activities
5. Completeness - addresses all user requirements

Return ONLY valid JSON."""
        )
    
    def rule_based_evaluation(self, response: str) -> dict:
        """Check against business rules."""
        score = 100
        issues = []
        
        # Rule checks
        if response.count("Day") < 1:
            issues.append("No day-by-day structure")
            score -= 30
        
        if "weather" not in response.lower():
            issues.append("Missing weather info")
            score -= 20
        
        words = len(response.split())
        if words < 100 or words > 2000:
            issues.append(f"Response length issue ({words} words)")
            score -= 15
        
        return {
            "score": score,
            "passed": score >= 70,
            "issues": issues
        }
    
    async def llm_based_evaluation(self, response: str, destination: str) -> dict:
        """Use LLM to check for toxicity, negativity, safety issues."""
        
        eval_prompt = f"""
Evaluate this travel plan for {destination}:

{response}

Return JSON:
{{
    "toxicity_score": <0-10>,
    "negativity_score": <0-10>,
    "safety_score": <0-10>,
    "accuracy_score": <0-10>,
    "completeness_score": <0-10>,
    "overall_score": <0-10>,
    "issues": [<specific concerns>],
    "pass": <true/false>
}}
"""
        
        eval_response = await self.evaluator_agent.run(eval_prompt)
        eval_text = eval_response.messages[-1].contents[0].text
        
        # Parse JSON (handle potential formatting issues)
        try:
            return json.loads(eval_text)
        except json.JSONDecodeError:
            return {"pass": False, "issues": ["Evaluation parse error"]}
    
    async def evaluate(self, response: str, destination: str) -> dict:
        """Run full evaluation pipeline."""
        
        rule_results = self.rule_based_evaluation(response)
        llm_results = await self.llm_based_evaluation(response, destination)
        
        return {
            "rule_based": rule_results,
            "llm_based": llm_results,
            "overall_passed": rule_results["passed"] and llm_results["pass"],
            "overall_score": (rule_results["score"] + llm_results.get("overall_score", 5)) / 2
        }
```

### Step 3: Integrate Evaluation into Your Flask App

```python
from evaluation import TravelPlanEvaluator

evaluator = TravelPlanEvaluator()

@app.route('/plan', methods=['POST'])
def plan_trip():
    with tracer.start_as_current_span("travel_plan_request") as span:
        try:
            destination = request.form.get('destination')
            
            # Generate plan (existing code)
            response = await agent.run(user_prompt)
            text_content = response.messages[-1].contents[0].text
            
            # EVALUATE the plan
            evaluation = asyncio.run(evaluator.evaluate(text_content, destination))
            
            # Record to metrics
            span.set_attribute("evaluation.passed", evaluation["overall_passed"])
            span.set_attribute("evaluation.score", evaluation["overall_score"])
            
            # If it failed, return error or use fallback
            if not evaluation["overall_passed"]:
                logger.warning(f"Plan failed evaluation: {evaluation}")
                # Option 1: Return error
                return render_template('error.html', 
                    error="Travel plan failed quality checks. Please try again."), 400
                # Option 2: Log and serve anyway (with warning)
                # It's your choice!
            
            return render_template('result.html', travel_plan=text_content)
            
        except Exception as e:
            return render_template('error.html', error=str(e)), 500
```

### Step 3: Add Evaluation Tests

Create `test_evaluation.py`:

```python
import asyncio
import pytest
from evaluation import TravelPlanEvaluator

@pytest.fixture
def evaluator():
    return TravelPlanEvaluator()

def test_plan_has_structure(evaluator):
    """Test that plans have day-by-day structure."""
    sample_plan = """
    Day 1: Arrival and exploration
    - Arrive at airport
    - Check into hotel
    - Explore Gothic Quarter
    
    Day 2: Museums
    - Visit Picasso Museum
    - Walk along beaches
    """
    
    result = evaluator.rule_based_evaluation(sample_plan)
    assert result["passed"]
    assert "Day" in sample_plan

def test_plan_includes_weather(evaluator):
    """Test that plans mention weather."""
    bad_plan = "Just wander around Barcelona."
    result = evaluator.rule_based_evaluation(bad_plan)
    assert not result["passed"]
    assert "Weather" in result["issues"]

@pytest.mark.asyncio
async def test_llm_evaluation(evaluator):
    """Test LLM-based evaluation."""
    sample_plan = "..."
    result = await evaluator.llm_based_evaluation(sample_plan, "Barcelona")
    assert "score" in result
    assert "passed" in result

# Run with: pytest test_evaluation.py
```

### Step 4: CI/CD Integration (GitHub Actions)

Create `.github/workflows/quality-gate.yml`:

```yaml
name: AI Quality Gate

on:
  push:
    branches: [main, develop]
  pull_request:

jobs:
  evaluate-ai:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.10'
      
      - name: Install dependencies
        run: |
          pip install -r requirements.txt
          pip install pytest pytest-asyncio
      
      - name: Run evaluation tests
        env:
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
        run: pytest test_evaluation.py -v
      
      - name: Test travel plan generation
        env:
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
        run: python -c "
          import asyncio
          from evaluation import TravelPlanEvaluator
          
          async def test():
              evaluator = TravelPlanEvaluator()
              # Generate test plans and evaluate...
              # If any fail, exit with error code
          
          asyncio.run(test())
        "
      
      - name: Report results
        if: always()
        run: echo "Quality gate complete"
```

---

## 📊 Monitoring Evaluation Results

Track your evaluation metrics in New Relic:

```python
# In your evaluation module:
evaluation_passed_counter = meter.create_counter(
    name="travel_plan.evaluation.passed",
    description="Evaluations that passed",
    unit="1"
)

evaluation_failed_counter = meter.create_counter(
    name="travel_plan.evaluation.failed",
    description="Evaluations that failed",
    unit="1"
)

evaluation_score_histogram = meter.create_histogram(
    name="travel_plan.evaluation.score",
    description="Evaluation score (0-100)",
    unit="1"
)

# Emit these metrics after each evaluation
if evaluation["overall_passed"]:
    evaluation_passed_counter.add(1)
else:
    evaluation_failed_counter.add(1)

evaluation_score_histogram.record(evaluation["overall_score"])
```

Create a dashboard showing:

- % of plans passing evaluation
- Distribution of evaluation scores
- Common issues found
- Trend over time (improving or degrading?)

---

## ✅ Challenge Checklist

- [ ] Evaluation module created
- [ ] Rule-based checks implemented
- [ ] LLM-based evaluation (optional)
- [ ] Integration into Flask app
- [ ] Evaluation tests written
- [ ] CI/CD workflow configured
- [ ] Metrics exported to New Relic
- [ ] Dashboard shows evaluation trends
- [ ] Team trained on quality gates
- [ ] Bad plans are blocked from users

---

## 🎯 Success Metrics

By the end, your system should:

- ✅ Only allow high-quality plans to users
- ✅ Track evaluation metrics over time
- ✅ Show if AI quality is improving
- ✅ Automatically test on every code change
- ✅ Catch regressions before production

---

## 💡 Advanced Ideas

1. **A/B Testing** - Test two agent versions and compare quality
2. **Feedback Loop** - Let users rate plans, use ratings in evaluation
3. **Multimodal Evaluation** - Test images, prices, maps alongside text
4. **Continuous Improvement** - Auto-retune prompts based on evaluation results

---

## 🎉 Hack Complete! 🎉

You've now built a **production-ready AI travel planning startup** with:

✅ **Challenge 1** - Understood Agent Framework concepts  
✅ **Challenge 2** - Built a working MVP  
✅ **Challenge 3** - Added OpenTelemetry instrumentation  
✅ **Challenge 4** - Integrated New Relic observability  
✅ **Challenge 5** - Built dashboards and alerts  
✅ **Challenge 6** - Implemented quality gates and CI/CD  

---

## 🚀 What's Next?

Deploy WanderAI! Your system is now:

- **Intelligent** - AI agents make travel plans
- **Observable** - You can see what's happening
- **Reliable** - Quality gates ensure excellence
- **Scalable** - Built for production
- **Professional** - Enterprise-grade monitoring

**Congratulations on building the future of travel! 🌍✈️🎉**
