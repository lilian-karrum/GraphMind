# GraphMind — Complete setup walkthrough (Windows / VS Code)

## 0. Prerequisites
- Python 3.10+ (check with `py --version`)
- VS Code and Python extension
- Internet access for package installation
- Neo4j AuraDB instance (for live graph mode)
- Optional: an OpenAI API key for LLM-based planning (may incur charges)

## 1. Run the offline demonstration first
Open the extracted `GraphMind_Prototype` folder in VS Code. In its terminal:

```powershell
py -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe -m streamlit run app.py
```

Open the local URL displayed by Streamlit (often http://localhost:8501). In the sidebar leave `Connect to Neo4j` and `LLM agent planning` OFF. This mode uses synthetic Python records and deterministic routing; it is **not** a real LLM agent.

## 2. Create your live graph in Neo4j AuraDB
1. Visit https://console.neo4j.io/ and sign in/create an account.
2. Create a database instance, choosing an available free tier if offered.
3. Save the connection URI, database name, username, and password shown by Aura. Keep these private.
4. Open the database's Query workspace (or Neo4j Browser).
5. Open `seed.cypher` in VS Code. Run each semicolon-terminated statement in order. If your workspace supports executing the entire script, you may run it all at once.
6. Verify your graph with:

```cypher
MATCH (n) RETURN labels(n) AS labels, count(*) AS count ORDER BY labels;
```

Expected seeded totals: 3 Room, 5 Equipment, 6 Sensor, 4 Anomaly, 1 Rule (19 nodes). Relationship totals: 5 CONTAINS, 6 HAS_SENSOR, 4 DETECTED_IN, 3 TRIGGERS (18 relationships).

View the graph with:

```cypher
MATCH p=(r:Room)-[:CONTAINS|HAS_SENSOR]->(x) RETURN p LIMIT 30;
```

## 3. Configure Neo4j credentials
Make a copy of `.env.example` named `.env` (on Windows PowerShell: `Copy-Item .env.example .env`). Edit `.env`:

```dotenv
NEO4J_URI=neo4j+s://your-instance.databases.neo4j.io
NEO4J_USERNAME=neo4j
NEO4J_PASSWORD=your-real-password
NEO4J_DATABASE=neo4j
OPENAI_API_KEY=
OPENAI_MODEL=gpt-4.1-mini
```

Use the **actual** URI, credentials and database name from your instance. `.env` must stay private; never upload it to GitHub. Restart Streamlit, enable `Connect to Neo4j`, and visit `Data Explorer` to confirm live records appear. If connection fails, check the URI, credentials, and whether the seed queries ran.

## 4. Enable real LLM tool selection (optional but recommended for agentic demonstration)
1. Obtain an OpenAI API key from https://platform.openai.com/ (API billing is separate from ChatGPT subscriptions).
2. In `.env`, set `OPENAI_API_KEY` to your key and `OPENAI_MODEL` to a model available in your API account that supports JSON response format.
3. Restart Streamlit and enable `LLM agent planning`.
4. Ask: `Why is the Kitchen consuming more energy than expected?`
5. Expand `View tool trace and Cypher`. The LLM chooses one or more approved retrieval tools, Python executes predefined read-only queries, and the LLM generates an evidence-grounded answer.

The agent is deliberately constrained: it does not generate arbitrary Cypher or control physical devices. The planning step is LLM-selected when enabled, and deterministic when disabled.

## 5. Demonstrate these questions
- `Which rooms have equipment rated above 2 kW?` — filtered graph traversal
- `Which sensors are in the Lab?` — room-to-sensor relationship
- `Show all anomalies in the building.` — anomaly-to-room relationship
- `Why is the Kitchen consuming more energy than expected?` — multiple tools and cautious synthesis

Explain: a room-level anomaly cannot prove which appliance caused it, and equipment *rated* power is not the same as actual consumption.

## 6. Presentation script (about 3 minutes)
**Opening:** “GraphMind is a small knowledge-graph assistant for a fictional smart building. Neo4j represents rooms, equipment, sensors, and anomalies as connected entities.”

**Graph:** “The graph makes relationships explicit. Instead of joining several tables, I can traverse from a Room to its Equipment or Sensors using Cypher.”

**Query:** “This question retrieves equipment rated above 2 kW. The query is parameterized and read-only.”

**Agent:** “With LLM planning enabled, the model chooses from approved tools. The application executes those tools against Neo4j, and the model explains the results. The trace lets us inspect what was retrieved.”

**Limitations:** “All values are synthetic. The graph provides context, not proof of causality. I do not let the model run unrestricted database writes or control devices.”

## 7. Troubleshooting
- `py` not recognized: install Python and select **Add Python to PATH**.
- `No module named streamlit`: use the `.venv` Python commands above, not a different Python interpreter.
- Port 8501 in use: `python -m streamlit run app.py --server.port 8502`.
- Neo4j authentication error: verify username/password and URI in `.env`; restart Streamlit.
- No live rows: run `seed.cypher` and verify the node counts.
- OpenAI authentication/model error: check API key, billing, and model availability; disable LLM planning to keep demoing the graph.
- If the PowerShell activation script is blocked, use `.\.venv\Scripts\python.exe` directly as shown in Step 1.
