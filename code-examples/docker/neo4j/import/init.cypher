// You can rename this file to init.cypher to run the auto import script.

LOAD CSV WITH HEADERS FROM 'file:///csv/00-company.csv' AS row
MERGE (c:Company {id: row.company_id})
SET c.name = row.company_name;

LOAD CSV WITH HEADERS FROM 'file:///csv/01-employee.csv' AS row
MERGE (e:Employee {id: row.employee_id})
SET e.name = row.employee_name;

LOAD CSV WITH HEADERS FROM 'file:///csv/02-relation-employee-company.csv' AS row
MATCH (e:Employee {id: row.employee_id})
MATCH (c:Company {id: row.company_id})
MERGE (e)-[:WORKS_AT]->(c);