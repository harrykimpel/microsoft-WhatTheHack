# Challenge 07 - AI Security Solution

## Quick Start

```bash
# Install dependencies
pip install -r requirements.txt

# Run vulnerable agent demo
python vulnerable_agent.py

# Run secure agent demo
python secure_agent.py

# Run detector standalone
python prompt_injection_detector.py

# Run full test suite
python test_injection_attacks.py
```

## Files Overview

| File | Purpose |
|------|---------|
| `vulnerable_agent.py` | Demonstrates prompt injection vulnerability |
| `prompt_injection_detector.py` | Multi-layer detection system |
| `security_monitoring.py` | OpenTelemetry + New Relic integration |
| `secure_agent.py` | Hardened agent with defense-in-depth |
| `test_injection_attacks.py` | Comprehensive test suite |
| `attack_examples.json` | Test attack patterns |
| `requirements.txt` | Python dependencies |

## Architecture

```
User Input
    ↓
┌─────────────────────────────────┐
│  Prompt Injection Detector       │
│  - Rule-based (fast)             │
│  - LLM-based (accurate)          │
│  - Heuristic (obfuscation)       │
└──────────────┬──────────────────┘
               ↓
┌─────────────────────────────────┐
│   Security Monitoring            │
│   - OpenTelemetry                │
│   - Custom Metrics               │
│   - Security Events              │
└──────────────┬──────────────────┘
               ↓
          Risk > 0.7?
               ↓
        ┌──────┴──────┐
        ↓              ↓
    Block         Secure Agent
                       ↓
                 Output Validation
                       ↓
                   Response
```

## Detection Strategies

### 1. Rule-Based Detection
- Pattern matching for known attacks
- Keyword detection
- Delimiter abuse detection
- Fast (<50ms)

### 2. Heuristic Detection
- L33tspeak detection
- Encoding pattern recognition
- Statistical anomalies
- Moderate speed

### 3. LLM-Based Detection (Optional)
- AI-powered analysis
- Novel attack detection
- High accuracy
- Slower (1-2s)

## Security Features

✅ **Input Validation**
- All queries analyzed before processing
- Risk scoring 0.0-1.0
- Configurable blocking threshold

✅ **Hardened System Prompt**
- Explicit security instructions
- Clear delimiters
- Output constraints

✅ **Output Validation**
- Checks for leaked information
- Prevents successful injection
- Safe fallback responses

✅ **Comprehensive Monitoring**
- OpenTelemetry distributed tracing
- Custom metrics to New Relic
- Security event logging

## Running Tests

The test suite validates:

1. **Vulnerable Agent**: Confirms it can be exploited
2. **Secure Agent**: Blocks 90%+ of attacks
3. **False Positives**: <10% on legitimate queries
4. **Performance**: <100ms average detection latency

```bash
python test_injection_attacks.py
```

Expected output:
```
✓ Vulnerable Agent: 75% attacks succeeded
✓ Secure Agent: 92% attacks blocked
✓ False Positive Rate: 6%
✓ Average Detection Latency: 45ms

🎉 ALL TESTS PASSED!
```

## Integrating with New Relic

1. **Install New Relic Agent**:
```bash
pip install newrelic
```

2. **Configure Environment**:
```bash
export NEW_RELIC_LICENSE_KEY="your-license-key"
export NEW_RELIC_APP_NAME="WanderAI-Security"
```

3. **Enable Monitoring**:
```python
from secure_agent import SecureAgent
from security_monitoring import SecurityMonitor

monitor = SecurityMonitor(service_name="wanderai")
agent = SecureAgent(monitor=monitor, enable_monitoring=True)
```

4. **View in New Relic**:
- Metrics: `security.prompt_injection.*`
- Events: `PromptInjectionAttempt`
- Traces: `security.prompt_injection.detect`

## NRQL Queries

### Attack Detection Rate
```sql
SELECT count(*) 
FROM PromptInjectionAttempt 
WHERE wasBlocked = true 
SINCE 24 hours ago
```

### Risk Score Distribution
```sql
SELECT histogram(riskScore, 10, 10) 
FROM PromptInjectionAttempt 
SINCE 1 hour ago
```

### Attack Types Breakdown
```sql
SELECT count(*) 
FROM PromptInjectionAttempt 
FACET attackType 
SINCE 1 day ago
```

### Detection Latency
```sql
SELECT average(duration) 
FROM Span 
WHERE name = 'security.prompt_injection.detect' 
SINCE 1 hour ago
```

## Customization

### Adjust Risk Threshold

```python
agent = SecureAgent(risk_threshold=0.6)  # More strict
agent = SecureAgent(risk_threshold=0.8)  # More lenient
```

### Add Custom Patterns

```python
detector.rule_detector.patterns[AttackType.CUSTOM] = [
    r"custom pattern here",
    r"another pattern"
]
```

### Enable LLM Detection

```python
from openai import OpenAI

llm_client = OpenAI(api_key="your-key")
detector = PromptInjectionDetector(
    llm_client=llm_client,
    enable_llm_detection=True
)
```

## Troubleshooting

**Q: Detection is too slow**
- Disable LLM detection: `enable_llm_detection=False`
- Use caching for repeated prompts
- Optimize pattern matching

**Q: Too many false positives**
- Increase risk threshold to 0.8 or 0.9
- Review rule-based patterns
- Add legitimate query whitelist

**Q: Attacks getting through**
- Lower risk threshold to 0.6
- Add more attack patterns
- Enable LLM-based detection
- Review system prompt hardening

**Q: Metrics not appearing in New Relic**
- Verify New Relic license key
- Check OTLP exporter configuration
- Wait up to 60 seconds for data
- Verify network connectivity

## Production Checklist

- [ ] Configure New Relic license key
- [ ] Set appropriate risk threshold
- [ ] Enable OpenTelemetry tracing
- [ ] Set up New Relic alerts
- [ ] Test with production traffic sample
- [ ] Monitor false positive rate
- [ ] Document incident response process
- [ ] Regular pattern updates
- [ ] Performance benchmarking
- [ ] User feedback mechanism

## Learning Resources

- [OWASP Top 10 for LLMs](https://owasp.org/www-project-top-10-for-large-language-model-applications/)
- [Prompt Injection Explained](https://simonwillison.net/2023/Apr/14/worst-that-can-happen/)
- [OpenTelemetry Python](https://opentelemetry.io/docs/instrumentation/python/)
- [New Relic APM](https://docs.newrelic.com/docs/apm/)

## License

Educational use only. See main repository LICENSE.

## Support

For questions or issues, refer to the Coach's Guide or contact the hack facilitators.
