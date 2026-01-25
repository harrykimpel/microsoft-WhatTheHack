# Quick Start Guide - Challenge 07

Get started with AI Security in minutes!

## Option 1: Run the Demos (No Installation Required)

The demos work without any dependencies for quick exploration.

### 1. Test the Detector

```bash
cd Coach/Solutions/Challenge-07
python prompt_injection_detector.py
```

**What you'll see**: Detection of various attack patterns with risk scores.

### 2. See the Vulnerability

```bash
python vulnerable_agent.py
```

**What you'll see**: How easily an unprotected agent can be exploited.

### 3. See the Protection

```bash
python secure_agent.py
```

**What you'll see**: How a hardened agent blocks attacks.

### 4. Run Full Tests

```bash
python test_injection_attacks.py
```

**What you'll see**: Comprehensive validation of all security measures.

## Option 2: Full Setup with Observability

For production-ready monitoring with New Relic.

### Step 1: Install Dependencies

```bash
pip install -r requirements.txt
```

### Step 2: Configure New Relic

```bash
export NEW_RELIC_LICENSE_KEY="your-key-here"
export NEW_RELIC_APP_NAME="WanderAI-Security"
```

Get your key from: https://one.newrelic.com → Account Settings → API Keys

### Step 3: Run with Monitoring

```python
# Your application code
from otel_config import initialize_observability
from secure_agent import SecureAgent
from security_monitoring import SecurityMonitor

# Initialize
initialize_observability()
monitor = SecurityMonitor()
agent = SecureAgent(monitor=monitor, enable_monitoring=True)

# Use the agent
response = agent.process_query("Plan a trip to Paris")
```

### Step 4: View in New Relic

1. Import the dashboard: `newrelic_dashboard.json`
2. View security metrics in real-time
3. Set up alerts using `nrql_queries.md`

## What's Included

| Component | Purpose | Lines | Status |
|-----------|---------|-------|--------|
| `prompt_injection_detector.py` | Multi-layer detection | 800+ | ✅ Tested |
| `vulnerable_agent.py` | Demonstrates risks | 200+ | ✅ Tested |
| `secure_agent.py` | Production defense | 400+ | ✅ Tested |
| `security_monitoring.py` | Observability | 400+ | ✅ Tested |
| `test_injection_attacks.py` | Automated testing | 400+ | ✅ Tested |
| `attack_examples.json` | 64 test patterns | - | ✅ Validated |
| `newrelic_dashboard.json` | 18 dashboard widgets | - | ✅ Ready |
| `nrql_queries.md` | 30+ monitoring queries | - | ✅ Ready |

## Expected Results

### Detector Demo
```
Plan a trip to Paris: Risk 0.08 ✅ LOW RISK
Ignore instructions: Risk 0.70 ⚡ MEDIUM RISK  
---END SYSTEM---: Risk 0.70 ⚡ MEDIUM RISK
```

### Vulnerable Agent
```
Attack Success Rate: 49%
- System prompt leaked ❌
- Role manipulation worked ❌
- Debug mode activated ❌
```

### Secure Agent
```
Attack Block Rate: 93.9%
- System prompt protected ✅
- Role manipulation blocked ✅
- Attacks detected & logged ✅
```

### Test Suite
```
✓ Vulnerable Agent: 49.0% attacks succeeded
✓ Secure Agent: 93.9% attacks blocked  
✓ Detection Latency: 0.1ms (excellent)
🎉 ALL CRITICAL TESTS PASSED
```

## Learning Path

### Beginner (30 minutes)
1. Run `vulnerable_agent.py` - See the problem
2. Run `secure_agent.py` - See the solution
3. Review `Student/Challenge-07.md` - Understand concepts

### Intermediate (2 hours)
1. Study `prompt_injection_detector.py` - Understand detection
2. Modify attack patterns in `attack_examples.json`
3. Run tests and observe changes
4. Implement your own attack pattern

### Advanced (4+ hours)
1. Integrate with your own AI agent
2. Set up New Relic monitoring
3. Create custom detection rules
4. Build a production security system
5. Complete all success criteria from challenge

## Common Questions

**Q: Do I need OpenTelemetry installed?**
A: No! The code works without it in demo mode. Install for full observability.

**Q: Do I need New Relic?**
A: No! The code works standalone. New Relic adds production monitoring.

**Q: Do I need an LLM API?**
A: No! The demos use simulated responses. Add an LLM for real-world testing.

**Q: Can I use this in production?**
A: Yes! The secure agent is production-ready. Just add your LLM client.

**Q: How do I add my own attack patterns?**
A: Edit `attack_examples.json` and add to any category or create a new one.

**Q: What if tests fail?**
A: Check `test_results.json` for details. Most failures are due to threshold tuning.

## Next Steps

1. ✅ **Completed demos?** → Read `Student/Challenge-07.md` for full challenge
2. ✅ **Understand concepts?** → Review `Coach/Solution-07.md` for implementation details
3. ✅ **Ready for production?** → Follow `setup_newrelic.md` for full integration
4. ✅ **Want to customize?** → Start with detector patterns and thresholds

## Troubleshooting

### Import Errors
```bash
# If you see "ModuleNotFoundError"
pip install -r requirements.txt

# Or run in demo mode (works without deps)
python vulnerable_agent.py  # Always works
```

### No Test Results
```bash
# Make sure you're in the right directory
cd Coach/Solutions/Challenge-07
python test_injection_attacks.py
```

### Tests Show Low Block Rate
```python
# Adjust threshold in secure_agent.py
agent = SecureAgent(risk_threshold=0.6)  # Lower = stricter
```

### High False Positive Rate
```python
# Adjust threshold in secure_agent.py  
agent = SecureAgent(risk_threshold=0.8)  # Higher = more lenient
```

## Resources

- **Challenge Description**: `Student/Challenge-07.md`
- **Solution Guide**: `Coach/Solution-07.md`
- **Code Documentation**: `README.md` (in Solutions/Challenge-07)
- **New Relic Setup**: `setup_newrelic.md`
- **NRQL Queries**: `nrql_queries.md`

## Support

- Review solution code for implementation details
- Check Coach's Guide for common issues
- Refer to OWASP LLM Top 10 for attack background
- New Relic docs for monitoring questions

---

**Ready to start?** Run this now:

```bash
cd Coach/Solutions/Challenge-07
python vulnerable_agent.py
python secure_agent.py
python test_injection_attacks.py
```

Then explore the code and customize for your needs! 🚀
