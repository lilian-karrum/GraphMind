# GraphMind — Graph Intelligence Studio

A polished educational prototype demonstrating **knowledge graphs**, **Neo4j**, **graph retrieval**, and optional **LLM-based agent tool selection**. Uses a fictional smart-building dataset.

## Quick start (works without credentials)

```bash
python -m venv .venv
# Windows: .venv\Scripts\activate
# macOS/Linux: source .venv/bin/activate
pip install -r requirements.txt
streamlit run app.py
```

Open the local URL shown in your terminal (typically `http://localhost:8501`). The default mode uses bundled synthetic data, so it runs without Neo4j or an LLM API.

## Enable real Neo4j queries

1. Create a Neo4j AuraDB instance or use a local Neo4j database.
2. Copy `.env.example` to `.env` and enter your URI, username, and password.
3. Open Neo4j Query and run the statements in `seed.cypher` in order. The script uses `MERGE` to avoid duplicating entities.
4. Restart Streamlit and enable **Connect to Neo4j** in the sidebar.
5. Use **Data Explorer** and **Ask the Agent** to execute parameterized, read-only Cypher queries.

**Note:** The Knowledge Map is a curated static visualization of the bundled dataset, not a live visualization of arbitrary Neo4j records.

## Enable LLM-driven agent planning

1. Set `OPENAI_API_KEY` in `.env` and optionally `OPENAI_MODEL` to a model available to your account.
2. Restart the app and enable **LLM agent planning**.
3. Ask an investigative question (e.g., “Why is the Kitchen consuming more energy than expected?”).
4. Expand the trace to see the chosen tools and their retrieved evidence.

When the LLM mode is off, the app uses deterministic keyword routing and template answers. It does **not** claim autonomous agent behavior in that mode.

## Suggested 4-minute professor demo

1. **30 sec:** Explain nodes, relationships, labels, properties, and the graph ontology on Knowledge Map.
2. **45 sec:** Open Data Explorer and show a `MATCH` query with a relationship traversal.
3. **60 sec:** Ask “Which rooms have equipment rated above 2 kW?” Show the `powerful` tool and its query.
4. **75 sec:** Ask “Why is the Kitchen consuming more energy than expected?” Show the three retrieval tools, their results, and cautious explanation. If LLM mode is enabled, emphasize model-selected tools.
5. **30 sec:** Discuss grounding, provenance, and limitations: synthetic data, room-level vs device-level measurements, no control actions.

## What is implemented

- Nodes represented in seed: `Room`, `Equipment`, `Sensor`, `Anomaly`, `Rule`.
- Relationships: `CONTAINS`, `HAS_SENSOR`, `DETECTED_IN`, `TRIGGERS`.
- Read-only parameterized Cypher tools: equipment, sensors, anomalies, powerful equipment.
- Optional LLM tool planning and answer generation, with evidence shown in the UI.
- Built-in deterministic fallback; CSV export; polished dashboard.

## Limitations and responsible design

- Fictional measurements are illustrative, not real sensor data.
- Rated equipment power is not actual electricity consumption.
- Room-level anomalies cannot identify a device-level root cause without additional evidence.
- The application intentionally prohibits free-form LLM-generated Cypher and write operations.
- The system is not a production energy controller, and no physical devices are operated.
- API usage may incur charges when LLM mode is enabled.
