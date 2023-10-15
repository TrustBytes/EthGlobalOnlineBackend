const Database = require("@tableland/sdk");

// This table has schema: `counter INTEGER PRIMARY KEY`
const tableName = "healthbot_80001_1"; // Our pre-defined health check table

const db = new Database();

// Type is inferred due to `Database` instance definition
const { results } = await db.prepare(`SELECT * FROM ${tableName};`).all();
console.log(results);