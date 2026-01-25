# NRQL Queries for Security Monitoring

This document contains ready-to-use NRQL queries for monitoring prompt injection attacks in New Relic.

## Table of Contents

- [Attack Detection](#attack-detection)
- [Risk Analysis](#risk-analysis)
- [Performance Monitoring](#performance-monitoring)
- [Attack Patterns](#attack-patterns)
- [Alerting Queries](#alerting-queries)
- [Trend Analysis](#trend-analysis)

---

## Attack Detection

### Total Attacks Detected (24 hours)

```sql
SELECT count(*) as 'Total Attacks Detected'
FROM PromptInjectionAttempt 
WHERE wasBlocked = true 
SINCE 24 hours ago
```

### Attacks Detected (Real-time, Last Hour)

```sql
SELECT count(*) as 'Attacks' 
FROM PromptInjectionAttempt 
WHERE wasBlocked = true 
TIMESERIES 5 minutes 
SINCE 1 hour ago
```

### Attack Detection Rate (Percentage)

```sql
SELECT percentage(count(*), WHERE wasBlocked = true) as 'Detection Rate %'
FROM PromptInjectionAttempt 
SINCE 1 hour ago
```

### Attacks by Type

```sql
SELECT count(*) 
FROM PromptInjectionAttempt 
WHERE wasBlocked = true 
FACET attackType 
SINCE 24 hours ago
```

### Recent High-Risk Detections

```sql
SELECT timestamp, riskScore, attackType, promptSnippet, confidence
FROM PromptInjectionAttempt 
WHERE riskScore > 0.8
ORDER BY timestamp DESC
SINCE 1 hour ago 
LIMIT 50
```

---

## Risk Analysis

### Risk Score Distribution (Histogram)

```sql
SELECT histogram(riskScore, 10, 10) 
FROM PromptInjectionAttempt 
SINCE 1 hour ago
```

### Average Risk Score Over Time

```sql
SELECT average(riskScore) as 'Avg Risk Score'
FROM PromptInjectionAttempt 
TIMESERIES 5 minutes 
SINCE 1 hour ago
```

### Risk Score by Attack Type

```sql
SELECT average(riskScore) as 'Avg Risk', 
       max(riskScore) as 'Max Risk',
       count(*) as 'Count'
FROM PromptInjectionAttempt 
FACET attackType 
SINCE 24 hours ago
```

### High Confidence Detections

```sql
SELECT count(*) as 'High Confidence Blocks'
FROM PromptInjectionAttempt 
WHERE confidence > 0.8 AND wasBlocked = true 
SINCE 24 hours ago
```

### Confidence Score Distribution

```sql
SELECT histogram(confidence, 10, 10)
FROM PromptInjectionAttempt 
SINCE 1 hour ago
```

---

## Performance Monitoring

### Average Detection Latency

```sql
SELECT average(detectionLatencyMs) as 'Avg Latency (ms)'
FROM PromptInjectionAttempt 
SINCE 1 hour ago
```

### Detection Latency Percentiles

```sql
SELECT percentile(detectionLatencyMs, 50, 95, 99) 
FROM PromptInjectionAttempt 
SINCE 1 hour ago
```

### Latency Over Time

```sql
SELECT average(detectionLatencyMs) as 'Avg',
       percentile(detectionLatencyMs, 95) as 'P95',
       percentile(detectionLatencyMs, 99) as 'P99'
FROM PromptInjectionAttempt 
TIMESERIES 5 minutes 
SINCE 1 hour ago
```

### Latency by Detection Method

```sql
SELECT average(detectionLatencyMs) as 'Avg Latency'
FROM PromptInjectionAttempt 
FACET detectionMethod 
SINCE 1 hour ago
```

### Security Check Span Duration

```sql
SELECT average(duration) as 'Avg Duration (ms)'
FROM Span 
WHERE name = 'security.prompt_injection.detect' 
SINCE 1 hour ago
```

### Detection Throughput (per minute)

```sql
SELECT rate(count(*), 1 minute) as 'Detections/min'
FROM PromptInjectionAttempt 
TIMESERIES 5 minutes 
SINCE 1 hour ago
```

---

## Attack Patterns

### Top 10 Attack Patterns

```sql
SELECT count(*) as 'Count',
       average(riskScore) as 'Avg Risk'
FROM PromptInjectionAttempt 
WHERE wasBlocked = true 
FACET promptSnippet 
SINCE 24 hours ago 
LIMIT 10
```

### Attack Type Trends (24h)

```sql
SELECT count(*) 
FROM PromptInjectionAttempt 
WHERE wasBlocked = true 
FACET attackType 
TIMESERIES 1 hour 
SINCE 24 hours ago
```

### Most Dangerous Attack Types (by avg risk score)

```sql
SELECT average(riskScore) as 'Avg Risk Score',
       count(*) as 'Count'
FROM PromptInjectionAttempt 
FACET attackType 
WHERE wasBlocked = true
SINCE 24 hours ago 
ORDER BY average(riskScore) DESC
```

### Repeat Attack Patterns (same prompt snippet)

```sql
SELECT count(*) as 'Attempts',
       latest(timestamp) as 'Last Seen',
       latest(riskScore) as 'Risk Score'
FROM PromptInjectionAttempt 
FACET promptSnippet 
SINCE 24 hours ago 
HAVING count(*) > 5 
ORDER BY count(*) DESC
```

### Detection Methods Effectiveness

```sql
SELECT count(*) as 'Total Detected',
       percentage(count(*), WHERE wasBlocked = true) as 'Block Rate %'
FROM PromptInjectionAttempt 
FACET detectionMethod 
SINCE 24 hours ago
```

---

## Alerting Queries

### High Attack Volume (Alert Threshold)

```sql
SELECT count(*) as 'Attack Count'
FROM PromptInjectionAttempt 
WHERE wasBlocked = true 
SINCE 5 minutes ago
```
**Alert if:** `> 10` attacks in 5 minutes

### Critical Risk Score Detected

```sql
SELECT max(riskScore) as 'Max Risk Score'
FROM PromptInjectionAttempt 
SINCE 1 minute ago
```
**Alert if:** `> 0.95`

### Detection Latency Degradation

```sql
SELECT average(detectionLatencyMs) as 'Avg Latency'
FROM PromptInjectionAttempt 
SINCE 5 minutes ago
```
**Alert if:** `> 200ms`

### Sudden Spike in Attacks

```sql
SELECT rate(count(*), 1 minute) as 'Attacks per Minute'
FROM PromptInjectionAttempt 
WHERE wasBlocked = true
SINCE 5 minutes ago
```
**Alert if:** `> 50` attacks/min

### New Attack Type Detected

```sql
SELECT uniqueCount(attackType) as 'Unique Attack Types'
FROM PromptInjectionAttempt 
COMPARE WITH 1 hour ago
```
**Alert if:** New unique attack types appear

---

## Trend Analysis

### 7-Day Attack Volume Trend

```sql
SELECT count(*) as 'Attacks'
FROM PromptInjectionAttempt 
WHERE wasBlocked = true 
TIMESERIES 1 day 
SINCE 7 days ago
```

### Daily Attack Pattern (Hour of Day)

```sql
SELECT count(*) as 'Attacks'
FROM PromptInjectionAttempt 
WHERE wasBlocked = true 
FACET hour(timestamp) 
SINCE 7 days ago
```

### Week-over-Week Comparison

```sql
SELECT count(*) as 'This Week',
       count(*) - count(*) COMPARE WITH 1 week ago as 'Change'
FROM PromptInjectionAttempt 
WHERE wasBlocked = true 
SINCE 1 week ago
```

### Attack Type Evolution (Last 30 Days)

```sql
SELECT count(*) 
FROM PromptInjectionAttempt 
WHERE wasBlocked = true 
FACET attackType 
TIMESERIES 1 day 
SINCE 30 days ago
```

### Risk Score Trend

```sql
SELECT average(riskScore) as 'Avg Risk',
       percentile(riskScore, 95) as 'P95 Risk'
FROM PromptInjectionAttempt 
TIMESERIES 1 hour 
SINCE 24 hours ago
```

---

## Advanced Queries

### Correlation: Latency vs Risk Score

```sql
SELECT average(detectionLatencyMs) as 'Avg Latency'
FROM PromptInjectionAttempt 
FACET cases(
  WHERE riskScore < 0.3 as 'Low Risk',
  WHERE riskScore >= 0.3 AND riskScore < 0.7 as 'Medium Risk',
  WHERE riskScore >= 0.7 as 'High Risk'
)
SINCE 1 hour ago
```

### Detection Accuracy (requires user feedback data)

```sql
SELECT percentage(count(*), WHERE falsePositive IS NULL OR falsePositive = false) as 'Accuracy %'
FROM PromptInjectionAttempt 
WHERE wasBlocked = true 
SINCE 24 hours ago
```

### Prompt Length Analysis

```sql
SELECT average(promptLength) as 'Avg Length',
       max(promptLength) as 'Max Length'
FROM PromptInjectionAttempt 
FACET cases(
  WHERE wasBlocked = true as 'Blocked',
  WHERE wasBlocked = false as 'Allowed'
)
SINCE 1 hour ago
```

### Multi-Layer Detection Coverage

```sql
SELECT count(*) as 'Detections'
FROM PromptInjectionAttempt 
WHERE wasBlocked = true
FACET detectionMethod 
TIMESERIES 1 hour 
SINCE 24 hours ago
```

### Session-Based Attack Analysis (if session tracking enabled)

```sql
SELECT count(*) as 'Attacks per Session'
FROM PromptInjectionAttempt 
WHERE wasBlocked = true AND sessionId IS NOT NULL
FACET sessionId 
SINCE 24 hours ago 
HAVING count(*) > 3 
ORDER BY count(*) DESC 
LIMIT 20
```

---

## Custom Dashboard Widgets

### Billboard: Current Threat Level

```sql
SELECT 
  CASE 
    WHEN average(riskScore) > 0.7 THEN 'HIGH'
    WHEN average(riskScore) > 0.4 THEN 'MEDIUM'
    ELSE 'LOW'
  END as 'Threat Level'
FROM PromptInjectionAttempt 
SINCE 1 hour ago
```

### Pie Chart: Attack Distribution

```sql
SELECT count(*) 
FROM PromptInjectionAttempt 
WHERE wasBlocked = true
FACET attackType 
SINCE 24 hours ago
```

### Line Chart: Real-time Attack Stream

```sql
SELECT count(*) as 'Attacks'
FROM PromptInjectionAttempt 
WHERE wasBlocked = true
TIMESERIES 1 minute 
SINCE 30 minutes ago
```

### Table: Security Event Log

```sql
SELECT timestamp, riskScore, attackType, detectionMethod, promptSnippet
FROM PromptInjectionAttempt 
WHERE wasBlocked = true
ORDER BY timestamp DESC
SINCE 1 hour ago 
LIMIT 100
```

### Heatmap: Attack Intensity by Hour and Type

```sql
SELECT count(*) 
FROM PromptInjectionAttempt 
WHERE wasBlocked = true
FACET attackType, hour(timestamp) 
SINCE 7 days ago
```

---

## Tips for Using These Queries

1. **Adjust Time Windows**: Change `SINCE` clause based on your needs
2. **Add Filters**: Use `WHERE` to focus on specific attack types or users
3. **Customize Thresholds**: Adjust risk score thresholds based on your environment
4. **Combine Queries**: Use `COMPARE WITH` to track changes over time
5. **Create Alerts**: Convert queries to alert conditions for proactive monitoring
6. **Export Data**: Use `LIMIT` and export for deeper analysis
7. **Test First**: Validate queries in New Relic Query Builder before using in dashboards

## Query Performance Tips

- Use shorter time windows for faster queries (`SINCE 1 hour ago` vs `SINCE 7 days ago`)
- Add `LIMIT` to large result sets
- Use `FACET` wisely - too many facets slow down queries
- Use `TIMESERIES` with appropriate buckets (5 min for hours, 1 hour for days)
- Index on frequently queried attributes

## Next Steps

1. Import these queries into New Relic
2. Create custom dashboards
3. Set up alert conditions
4. Monitor regularly
5. Tune based on your traffic patterns
6. Share insights with your team

---

For more information on NRQL:
- [NRQL Reference](https://docs.newrelic.com/docs/query-your-data/nrql-new-relic-query-language/get-started/introduction-nrql-new-relics-query-language/)
- [NRQL Syntax](https://docs.newrelic.com/docs/query-your-data/nrql-new-relic-query-language/get-started/nrql-syntax-clauses-functions/)
