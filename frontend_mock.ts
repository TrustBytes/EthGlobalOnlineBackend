import { Database } from "@tableland/sdk";

// This table has schema: `counter INTEGER PRIMARY KEY`
const tableName: string = "healthbot_80001_1"; // Our pre-defined health check table

interface HealthBot {
  counter: number;
}

const db: Database<HealthBot> = new Database();

// Type is inferred due to `Database` instance definition
const { results } = await db.prepare(`SELECT * FROM ${tableName};`).all();
console.log(results);


