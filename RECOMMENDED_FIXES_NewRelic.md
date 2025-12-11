# Recommended Fixes: xxx-AgentFrameworkObservabilityWithNewRelic

**Priority:** HIGH PRIORITY items should be addressed before publication

---

## 🔴 HIGH PRIORITY FIXES

### 1. Fix Coach README.md Challenge Descriptions

**File:** `Coach/README.md`  
**Lines:** 15-26

**Current (Placeholder):**
```markdown
- Challenge 01: **[Title of Challenge](./Solution-01.md)**
	 - Description of challenge
```

**Recommended Fix:**
```markdown
- Challenge 01: **[Master the Foundations](./Solution-01.md)**
	 - Understand Microsoft Agent Framework and AI agent concepts (45 mins)
- Challenge 02: **[Build Your MVP](./Solution-02.md)**
	 - Create Flask app with AI travel planner agent (2-3 hours)
- Challenge 03: **[Add OpenTelemetry Instrumentation](./Solution-03.md)**
	 - Instrument application with traces, metrics, and logs (1.5-2 hours)
- Challenge 04: **[New Relic Integration](./Solution-04.md)**
	 - Connect observability pipeline to New Relic platform (1 hour)
- Challenge 05: **[Monitoring Best Practices](./Solution-05.md)**
	 - Build dashboards and configure alerts for production (1.5 hours)
- Challenge 06: **[LLM Evaluation & Quality Gates](./Solution-06.md)**
	 - Implement AI quality assurance and CI/CD gates (2-3 hours)
```

---

### 2. Add Suggested Hack Agenda

**File:** `Coach/README.md`  
**Section:** "Suggested Hack Agenda"

**Current:** Generic template text

**Recommended Addition:**
```markdown
## Suggested Hack Agenda

This hack is designed to be completed in 2-3 days with approximately 10-12 hours of active learning time.

### **Day 1 (4-5 hours)**
- **9:00 - 9:30** - Opening & Challenge 0 (Prerequisites)
  - Ensure all participants have working Codespaces or local dev environments
  - Verify GitHub Copilot is configured
- **9:30 - 10:15** - Challenge 1 (Master the Foundations)
  - Lecture on Microsoft Agent Framework concepts
  - Group discussion and knowledge check
- **10:15 - 10:30** - Break
- **10:30 - 12:30** - Challenge 2 (Build Your MVP)
  - Hands-on: Build Flask app with agent framework
  - Support participants who encounter issues
- **12:30 - 1:30** - Lunch
- **1:30 - 3:30** - Challenge 2 continued & demos
  - Teams demo their working travel planners
  - Q&A and troubleshooting

### **Day 2 (4-5 hours)**
- **9:00 - 9:15** - Day 1 Recap
- **9:15 - 11:00** - Challenge 3 (Add OpenTelemetry)
  - Lecture on observability concepts
  - Hands-on instrumentation
- **11:00 - 11:15** - Break
- **11:15 - 12:15** - Challenge 4 (New Relic Integration)
  - Configure OTLP exporters
  - View data in New Relic
- **12:15 - 1:15** - Lunch
- **1:15 - 3:00** - Challenge 5 (Monitoring Best Practices)
  - Build custom dashboards
  - Configure alerts
  - Share dashboards with team

### **Day 3 (3-4 hours)**
- **9:00 - 9:15** - Day 2 Recap
- **9:15 - 11:30** - Challenge 6 (LLM Evaluation & Quality Gates)
  - Lecture on AI quality assurance
  - Implement custom events for New Relic AI Monitoring
  - Build evaluation pipeline
  - Configure CI/CD quality gates
- **11:30 - 11:45** - Break
- **11:45 - 12:30** - Final presentations and wrap-up
  - Teams demo complete solutions
  - Discuss lessons learned
  - Q&A and next steps

### **Flexible/Self-Paced Option**
Participants can complete this hack at their own pace over 1-2 weeks, spending approximately:
- Challenges 0-1: 1.5 hours
- Challenge 2: 2-3 hours
- Challenge 3: 2 hours
- Challenge 4: 1 hour
- Challenge 5: 1.5 hours
- Challenge 6: 2.5 hours
```

---

### 3. Specify Azure Requirements

**File:** `Coach/README.md`  
**Section:** "Azure Requirements"

**Current:** Placeholder template text

**Recommended Fix:**
```markdown
## Azure Requirements

This hack requires students to have access to the following:

### Required Azure Resources
- **None** - This hack does not require Azure resources
- All development is done in GitHub Codespaces or locally
- LLM access is provided through:
  - Option 1: GitHub Models (free tier, requires GitHub account)
  - Option 2: OpenAI API (requires API key, usage fees apply)
  - Option 3: Azure OpenAI Service (requires Azure subscription, optional)

### Required External Services
- **New Relic Account (Free Tier)**
  - Sign up at: https://newrelic.com/signup
  - Free tier includes:
    - 100 GB data ingest per month
    - 1 full platform user
    - Unlimited basic users
    - Full access to AI Monitoring features
  - Students need to obtain:
    - License Key (for OTLP ingestion)
    - Account credentials
  
### GitHub Requirements
- **GitHub Account** (free)
  - Required for Codespaces
  - Required for GitHub Models access (optional LLM provider)
  - GitHub Copilot recommended (30-day free trial available)

### Permissions Required
- No special Azure permissions needed
- No Azure subscription required (unless using Azure OpenAI)
- Students manage their own external service accounts

### Cost Estimates
- **New Relic:** Free tier sufficient for hack duration
- **GitHub Codespaces:** Free tier (60 hours/month) sufficient
- **OpenAI API:** $0.50-$2.00 per student for hack duration (if using OpenAI)
- **GitHub Models:** Free tier available
- **Total estimated cost per student:** $0-$2 (if using free tiers)
```

---

### 4. Fix Typo in Challenge-00.md

**File:** `Student/Challenge-00.md`  
**Line:** 74

**Current:**
```markdown
GitHub Codepspaces is available for developers in every organization.
```

**Fix:**
```markdown
GitHub Codespaces is available for developers in every organization.
```

---

### 5. Standardize Tool Function Names

**Affected Files:**
- `Student/Challenge-02.md`
- `Coach/Solutions/Challenge-02/web_app.py`

**Issue:** Inconsistent naming between `get_random_destination()` and `get_selected_destination()`

**Recommended Standard:** Use `get_random_destination()` throughout

**In Challenge-02.md (line 139):**
```python
def get_random_destination() -> str:
    """
    Return a random travel destination from a predefined list.
    
    Returns:
        A string with the selected destination
    
    Example: "You have selected Paris, France as your travel destination."
    """
    pass
```

---

### 6. Create Missing Solution Files

**Missing Files to Create:**

#### A. `Coach/Solutions/Challenge-05/dashboard-config.json`
```json
{
  "name": "WanderAI Agent Performance",
  "description": "Monitor AI travel planner agent performance",
  "permissions": "PUBLIC_READ_WRITE",
  "pages": [
    {
      "name": "Overview",
      "widgets": [
        {
          "title": "Request Rate",
          "configuration": {
            "nrql": "SELECT rate(count(*), 1 minute) FROM Metric WHERE metricName = 'travel_plan.requests.total' TIMESERIES"
          }
        },
        {
          "title": "Error Rate",
          "configuration": {
            "nrql": "SELECT rate(count(*), 1 minute) FROM Metric WHERE metricName = 'travel_plan.errors.total' TIMESERIES"
          }
        },
        {
          "title": "Average Response Time",
          "configuration": {
            "nrql": "SELECT average(travel_plan.response_time_ms) FROM Metric TIMESERIES"
          }
        },
        {
          "title": "Tool Usage Breakdown",
          "configuration": {
            "nrql": "SELECT count(*) FROM Metric WHERE metricName = 'travel_plan.tool_calls.total' FACET tool_name"
          }
        }
      ]
    }
  ]
}
```

#### B. `Coach/Solutions/Challenge-05/alert-conditions.md`
Create a markdown file documenting the alert configurations with screenshots and NRQL queries.

#### C. `Coach/Solutions/Challenge-06/evaluation.py`
Create a complete implementation of the TravelPlanEvaluator class referenced in Challenge-06.

---

## 🟡 MEDIUM PRIORITY FIXES

### 7. Enhance Coach Solution Guides

**All Solution-XX.md files need:**

**Template to add to each:**
```markdown
## Common Issues & Troubleshooting

### Issue 1: [Common Problem]
**Symptom:** [What participants see]
**Cause:** [Why it happens]
**Solution:** [How to fix]

### Issue 2: [Another Common Problem]
...

## What Participants Struggle With

- **Understanding [concept]:** Help them by...
- **Implementing [feature]:** Watch for...
- **Debugging [issue]:** Guide them to...

## Time Management

**Expected Duration:** [X hours]
**Minimum Viable:** [X hours] (for basic completion)
**Stretch Goals:** [Additional time] (for advanced features)

## Validation Checklist

Coach should verify participants have:
- [ ] [Checkpoint 1]
- [ ] [Checkpoint 2]
- [ ] [Checkpoint 3]
```

---

### 8. Add Architecture Diagrams

**Create:** `Images/architecture-overview.png`

**Recommended content:**
- Show progression from Challenge 2 → Challenge 6
- Illustrate: User → Flask → Agent → Tools
- Show: Application → OpenTelemetry → New Relic
- Highlight: Custom Events → AI Monitoring features

**Tools to create diagram:**
- draw.io
- Lucidchart  
- Microsoft Visio
- Or hand-drawn and scanned

---

### 9. Create Images Folder

**Create folder:** `xxx-AgentFrameworkObservabilityWithNewRelic/Images/`

**Add files:**
1. `WthVideoCover.jpg` - Marketing/thumbnail image
2. `architecture-overview.png` - System architecture
3. `challenge-progression.png` - Visual showing 6 challenges
4. `wanderai-logo.png` - Fictional startup logo (optional but fun)

---

### 10. Add .env.template File

**Create:** `Coach/Solutions/Challenge-02/.env.template`

```bash
# OpenAI Configuration (Option 1)
# OPENAI_API_KEY=sk-...
# GITHUB_MODEL_ID=gpt-4o-mini

# GitHub Models Configuration (Option 2)
# GITHUB_ENDPOINT=https://models.inference.ai.azure.com
# GITHUB_TOKEN=ghp_...
# GITHUB_MODEL_ID=gpt-4o-mini

# Azure OpenAI Configuration (Option 3)
# AZURE_OPENAI_ENDPOINT=https://your-resource.openai.azure.com/
# AZURE_OPENAI_API_KEY=...
# AZURE_OPENAI_MODEL_ID=gpt-4o-mini

# Weather API (Optional)
# OPENWEATHER_API_KEY=...

# New Relic Configuration (Added in Challenge 4)
# OTEL_EXPORTER_OTLP_ENDPOINT=https://otlp.nr-data.net
# OTEL_EXPORTER_OTLP_HEADERS=api-key=YOUR_LICENSE_KEY_HERE
# OTEL_SERVICE_NAME=travel-planner
# OTEL_SERVICE_VERSION=0.1.0
```

---

## 🟢 LOW PRIORITY ENHANCEMENTS

### 11. Add FAQ Section to Main README

**Add before "Contributors" section:**

```markdown
## Frequently Asked Questions

### Do I need Azure for this hack?
No, this hack does not require Azure resources. You can use GitHub Models (free) or OpenAI API (paid) for LLM access.

### How much does this hack cost?
Using free tiers: $0. Using OpenAI API: approximately $0.50-$2 per participant.

### How long does this hack take?
Self-paced: 10-12 hours over 1-2 weeks. Instructor-led: 2-3 days.

### What if I can't get New Relic working?
New Relic offers a free tier and excellent documentation. If you're blocked, you can complete Challenges 0-3 using console output, then add New Relic integration later.

### Can I use a different observability platform?
The hack is designed for New Relic, but the OpenTelemetry instrumentation (Challenge 3) is platform-agnostic. You could adapt Challenges 4-6 for other platforms like Datadog, Dynatrace, or Splunk.

### Do I need to know Python?
Basic Python knowledge is helpful but not required. The challenges provide starter code and GitHub Copilot can assist with coding.
```

---

### 12. Add Prerequisites Validation Script

**Create:** `Student/validate-prerequisites.sh`

```bash
#!/bin/bash

echo "🔍 Validating What The Hack Prerequisites..."
echo ""

# Check Python
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo "✅ Python: $PYTHON_VERSION"
else
    echo "❌ Python 3 not found"
    exit 1
fi

# Check pip
if command -v pip3 &> /dev/null; then
    echo "✅ pip: $(pip3 --version)"
else
    echo "❌ pip not found"
    exit 1
fi

# Check Git
if command -v git &> /dev/null; then
    echo "✅ Git: $(git --version)"
else
    echo "❌ Git not found"
    exit 1
fi

# Check for .env file
if [ -f .env ]; then
    echo "✅ .env file found"
    
    # Check for required env vars
    if grep -q "OPENAI_API_KEY\|GITHUB_TOKEN" .env; then
        echo "✅ LLM API key configured"
    else
        echo "⚠️  No LLM API key found in .env"
    fi
else
    echo "⚠️  .env file not found (will need to create)"
fi

echo ""
echo "🎉 Prerequisites validation complete!"
```

---

## Implementation Priority

### Week 1 (8-12 hours):
1. Fix Coach README.md (Items 1-3)
2. Fix typo (Item 4)
3. Standardize naming (Item 5)
4. Create missing solution files (Item 6)

### Week 2 (6-8 hours):
5. Enhance Coach solution guides (Item 7)
6. Add architecture diagrams (Item 8)
7. Create Images folder (Item 9)
8. Add .env.template (Item 10)

### Week 3 (4-6 hours):
9. Add FAQ section (Item 11)
10. Add validation script (Item 12)
11. Final review and testing

---

## Testing Recommendations

Before publishing, recommend:

1. **Pilot Test** with 2-3 participants
2. **Coach Dry Run** with someone unfamiliar with the content
3. **Technical Review** by Microsoft Agent Framework team
4. **New Relic Review** by New Relic team
5. **Documentation Review** for clarity and completeness

---

## Summary

**Current State:** 85% complete, high quality content
**With High Priority Fixes:** 95% complete, publication-ready
**With All Fixes:** 100% complete, best-in-class hack

The content is **excellent** and very close to ready. The recommended fixes are mostly about **completeness and polish** rather than fundamental issues.

Great work by the contributors! 🎉
