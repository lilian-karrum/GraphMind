// GraphMind demonstration dataset: fictional readings, not measured building data.
CREATE CONSTRAINT room_id IF NOT EXISTS FOR (n:Room) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT equipment_id IF NOT EXISTS FOR (n:Equipment) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT sensor_id IF NOT EXISTS FOR (n:Sensor) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT anomaly_id IF NOT EXISTS FOR (n:Anomaly) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT rule_id IF NOT EXISTS FOR (n:Rule) REQUIRE n.id IS UNIQUE;
UNWIND [{id:'R1',name:'Kitchen',floor:1},{id:'R2',name:'Lab',floor:2},{id:'R3',name:'Mailroom',floor:1}] AS x MERGE (n:Room {id:x.id}) SET n += x;
UNWIND [{id:'E1',name:'Air Conditioner',ratedPowerKW:2.5,room:'R1'},{id:'E2',name:'Microwave',ratedPowerKW:1.2,room:'R1'},{id:'E3',name:'Server Rack',ratedPowerKW:3.2,room:'R2'},{id:'E4',name:'Printer',ratedPowerKW:0.6,room:'R3'},{id:'E5',name:'Coffee Machine',ratedPowerKW:1.4,room:'R1'}] AS x MATCH (r:Room {id:x.room}) MERGE (e:Equipment {id:x.id}) SET e.name=x.name,e.ratedPowerKW=x.ratedPowerKW MERGE (r)-[:CONTAINS]->(e);
UNWIND [{id:'S1',name:'Kitchen Power Meter',kind:'power',room:'R1'},{id:'S2',name:'Kitchen Temperature',kind:'temperature',room:'R1'},{id:'S3',name:'Lab Power Meter',kind:'power',room:'R2'},{id:'S4',name:'Lab Temperature',kind:'temperature',room:'R2'},{id:'S5',name:'Mailroom Power Meter',kind:'power',room:'R3'},{id:'S6',name:'Mailroom Temperature',kind:'temperature',room:'R3'}] AS x MATCH (r:Room {id:x.room}) MERGE (s:Sensor {id:x.id}) SET s.name=x.name,s.kind=x.kind MERGE (r)-[:HAS_SENSOR]->(s);
UNWIND [{id:'A1',room:'R1',kind:'High power',observed:2.7,expected:1.8,unit:'kW',severity:'High'},{id:'A2',room:'R2',kind:'High power',observed:3.5,expected:2.9,unit:'kW',severity:'Medium'},{id:'A3',room:'R1',kind:'High temperature',observed:28.0,expected:24.0,unit:'°C',severity:'Medium'},{id:'A4',room:'R3',kind:'High power',observed:0.9,expected:0.7,unit:'kW',severity:'Low'}] AS x MATCH (r:Room {id:x.room}) MERGE (a:Anomaly {id:x.id}) SET a.kind=x.kind,a.observed=x.observed,a.expected=x.expected,a.unit=x.unit,a.severity=x.severity MERGE (a)-[:DETECTED_IN]->(r);
MERGE (rule:Rule {id:'RULE1'}) SET rule.name='Investigate high power',rule.description='Inspect measured device usage before taking action';
MATCH (a:Anomaly {kind:'High power'}),(rule:Rule {id:'RULE1'}) MERGE (a)-[:TRIGGERS]->(rule);
