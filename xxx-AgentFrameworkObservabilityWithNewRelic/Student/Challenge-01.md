# 🌱 Challenge 1: Master the Foundations

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## 🎯 Objective

Understand how Microsoft Agent Framework works and the core concepts that will power WanderAI's AI agents.

By the end of this challenge, you should be able to:

- ✅ Explain what an AI agent is and how it differs from a simple LLM API call
- ✅ Understand "tool calling" and why agents need tools
- ✅ Describe the agent-tool lifecycle
- ✅ Know what OpenTelemetry is and why observability matters for AI
- ✅ Identify the key components of the complete solution

---

## 📚 Learning Path

### Part 1: Understand AI Agents (30 mins)

**Read these resources:**

1. [Microsoft Agent Framework GitHub](https://github.com/microsoft/agent-framework)
2. [Agent Framework Documentation](https://learn.microsoft.com/en-us/agent-framework/overview/agent-framework-overview)
3. [ChatAgent Concepts](https://learn.microsoft.com/en-us/agent-framework/tutorials/agents/run-agent?pivots=programming-language-python#create-the-agent-1)

**Key Questions to Answer:**

- What is a `ChatAgent`?
- What does "tool calling" mean?
- How does an agent decide when to call a tool vs. respond to the user?
- What's the relationship between instructions, tools, and responses?

### Part 2: Agent Application Architecture (30 mins)

In the next challenge, you will build your own Flask web app from scratch using the Microsoft Agent Framework. For now, focus on understanding the following concepts:

- How a Flask app is structured (see [Flask Quickstart](https://flask.palletsprojects.com/en/3.0.x/quickstart/))
- How agents are created and configured using the [Microsoft Agent Framework documentation](https://learn.microsoft.com/en-us/agent-framework/overview/agent-framework-overview)
- What "tool calling" means and how tools are registered with an agent
- The typical flow of a user request through a Flask route, agent logic, and response

**Questions to consider:**

- At what point can the agent call tools?
- How does the agent decide which tool to use?
- What happens if a tool fails?

### Part 3: Introduction to Observability (20 mins)

**Read:**

- [OpenTelemetry Concepts](https://opentelemetry.io/docs/concepts/)
- [Why Observability Matters](https://docs.newrelic.com/docs/using-new-relic/welcome-new-relic/get-started/introduction-new-relic/#observability)

**Key Concepts:**

**Traces** = A record of all the work done to fulfill a user request

- Shows the full journey from request to response
- Includes every step, tool call, and decision
- Example: "User asked for travel plan → agent decided → called get_weather → tool returned → agent formatted response"

**Metrics** = Measurements over time (numbers that change)

- Example: "Average response time was 2.5 seconds"
- Example: "3 requests per second"

**Logs** = Text records of events

- Example: "Tool get_weather() called for Barcelona"
- Example: "Error: API returned 500 status"

**Why AI agents need observability:**

- AI is non-deterministic (same input might give different outputs)
- Tool calling adds complexity (is the right tool being called?)
- Latency can come from multiple sources (LLM, tools, network)
- Debugging production AI failures requires understanding the full trace

---

## 📝 Knowledge Check

Answer these questions to validate your learning:

### Question 1: Agent vs. Simple LLM

**What's the difference between calling an LLM API directly vs. using an agent?**

*Hint: Think about who decides when to call tools.*

### Question 2: Tool Calling

**Why does an agent need tools like `get_weather()`?**

*Hint: What information does the LLM model have access to?*

### Question 3: Observability Value

**Why can't you just use print() statements to debug an AI agent in production?**

*Hint: Think about multiple concurrent requests.*

### Question 4: Application Architecture

**Describe the basic architecture of an agent-powered Flask app:**

- The Flask application setup
- The tool functions
- The agent creation
- The main request handler

*Draw a simple diagram of how requests flow through the system, based on your understanding from the docs.*

### Question 5: Observability Layers

**Match each concept to its use case:**

| Concept | Use Case |
|---------|----------|
| Traces | Understanding every decision an agent made |
| Metrics | Detecting when response times slow down |
| Logs | Finding the exact line of code that failed |

---

## 🎬 What's Next?

Once you've studied the concepts and answered the knowledge check questions:

1. **Challenge 2** - You'll build your first agent application from scratch
2. You'll create a Flask web app that serves travel plans
3. You'll implement the same tools but understand them deeply

---

## 💡 Tips

- 📖 Don't skip reading the docs—they answer most questions
- 🤔 Ask "why?" for every design decision you see
- 📝 Take notes on concepts you find unclear
- 💬 Ask mentors for clarification on tricky parts

---

## ✅ Challenge Complete When

You can answer all the knowledge check questions and explain:

1. How Microsoft Agent Framework works
2. What tool calling is and why it matters
3. Why observability is critical for AI systems
4. The overall architecture of an agent-powered Flask app

**No code to write yet—this is learning!** 🧠

Move to Challenge 2 when you're ready to start building! 🚀
