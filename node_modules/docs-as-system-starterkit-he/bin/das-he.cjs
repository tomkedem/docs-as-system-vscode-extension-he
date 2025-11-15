#!/usr/bin/env node

const { run } = require("../src/init.cjs");

run().catch(err => {
  console.error("[das-he][ERROR]", err.message || err);
  process.exit(1);
});
