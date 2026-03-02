# HiveQL Migration Guide: Hive 2/3 to Hive 4.0

This document provides a comprehensive, step-by-step guide for migrating HiveQL scripts from Apache Hive 2.x/3.x to Apache Hive 4.0 (released March 2024).

---

## Table of Contents

1. [Overview of Breaking Changes](#1-overview-of-breaking-changes)
2. [Step-by-Step Migration Checklist](#2-step-by-step-migration-checklist)
3. [Detailed Migration Steps](#3-detailed-migration-steps)
4. [New Features in Hive 4.0](#4-new-features-in-hive-40)
5. [Configuration Changes](#5-configuration-changes)
6. [File-by-File Change Summary](#6-file-by-file-change-summary)

---

## 1. Overview of Breaking Changes

| Area | Hive 2/3 Behavior | Hive 4.0 Behavior | Impact |
|------|-------------------|-------------------|--------|
| **ACID Tables** | Opt-in via TBLPROPERTIES + CLUSTERED BY | All managed tables are ACID by default | HIGH |
| **Execution Engine** | MapReduce or Tez (configurable) | Tez only (MapReduce removed) | HIGH |
| **Datetime Parsing** | Lenient (SimpleDateFormat) | Strict (java.time.DateTimeFormatter) | HIGH |
| **NULL Ordering** | NULLS FIRST for ASC | NULLS LAST for ASC (SQL standard) | HIGH |
| **ORC Compression** | Default ZLIB | Default ZSTD | MEDIUM |
| **ROLLUP/CUBE Syntax** | `GROUP BY x WITH ROLLUP` | `GROUP BY ROLLUP(x)` (old deprecated) | MEDIUM |
| **MAPJOIN Hint** | `/*+ MAPJOIN(t) */` | Deprecated; use `/*+ BROADCAST(t) */` | MEDIUM |
| **Reserved Keywords** | Partial ANSI enforcement | Strict ANSI SQL keyword enforcement | MEDIUM |
| **Dynamic Partitioning** | Required `SET hive.exec.dynamic.partition=true` | Enabled by default | LOW |
| **Vectorized Execution** | Required explicit SET | Enabled by default | LOW |
| **CBO (Cost-Based Optimizer)** | Required explicit SET | Enabled by default | LOW |
| **Auto Statistics** | Manual ANALYZE needed | Auto-gathered on INSERT/LOAD | LOW |

---

## 2. Step-by-Step Migration Checklist

### Pre-Migration
- [ ] Inventory all HQL scripts and identify version-specific syntax
- [ ] Back up existing Hive metastore
- [ ] Document current `hive-site.xml` configuration
- [ ] Test scripts in a Hive 4.0 staging environment first

### Syntax Migration
- [ ] Remove `TBLPROPERTIES ('transactional'='true')` from managed tables
- [ ] Replace `GROUP BY x, y WITH ROLLUP` with `GROUP BY ROLLUP(x, y)`
- [ ] Replace `GROUP BY x, y WITH CUBE` with `GROUP BY CUBE(x, y)`
- [ ] Replace `/*+ MAPJOIN(t) */` hints with `/*+ BROADCAST(t) */` or remove
- [ ] Replace `UNION` with `UNION DISTINCT` for clarity
- [ ] Add `IF NOT EXISTS` to CREATE TABLE statements for idempotency
- [ ] Remove `INSERT INTO TABLE` redundant `TABLE` keyword

### Configuration Migration
- [ ] Remove `SET hive.execution.engine=tez` (now default and only engine)
- [ ] Remove `SET hive.vectorized.execution.enabled=true` (now default)
- [ ] Remove `SET hive.cbo.enable=true` (now default)
- [ ] Remove `SET hive.exec.dynamic.partition=true` (now default)
- [ ] Review `SET hive.auto.convert.join=true` (now default)

### Behavioral Migration
- [ ] Audit all `ORDER BY` queries for NULL ordering assumptions
- [ ] Add explicit `NULLS FIRST` or `NULLS LAST` to all ORDER BY clauses
- [ ] Validate all date/timestamp parsing with strict formatter
- [ ] Replace invalid date literals (e.g., month 13, Feb 30)
- [ ] Verify reserved keyword usage and add backtick escaping
- [ ] Update ORC compression settings from ZLIB to ZSTD where desired
- [ ] Review type compatibility in UNION/INTERSECT/EXCEPT operations

### Post-Migration
- [ ] Run all scripts against Hive 4.0 environment
- [ ] Validate query results match expected output
- [ ] Monitor compaction behavior (auto-compaction is improved)
- [ ] Review EXPLAIN plans with the new CBO defaults

---

## 3. Detailed Migration Steps

### 3.1 ACID Tables (Managed Tables Are Now Transactional by Default)

**What Changed:**
In Hive 4.0, ALL managed (non-external) tables stored as ORC are ACID/transactional by default. This means:
- `TBLPROPERTIES ('transactional'='true')` is no longer needed
- `CLUSTERED BY` is no longer required for ACID support
- All managed tables support `INSERT`, `UPDATE`, `DELETE`, and `MERGE INTO`

**Before (Hive 2/3):**
```sql
CREATE TABLE transactions_acid (
    txn_id BIGINT,
    account_id INT
)
CLUSTERED BY (account_id) INTO 4 BUCKETS
STORED AS ORC
TBLPROPERTIES ('transactional'='true');
```

**After (Hive 4.0):**
```sql
CREATE TABLE transactions_acid (
    txn_id BIGINT,
    account_id INT
)
CLUSTERED BY (account_id) INTO 4 BUCKETS  -- Optional, kept for performance
STORED AS ORC;
-- ACID is automatic for managed ORC tables
```

**Impact:** Scripts that explicitly set transactional properties will still work (no error), but the settings are redundant.

---

### 3.2 Execution Engine (Tez Only)

**What Changed:**
MapReduce execution engine has been removed. Tez is the default and only execution engine.

**Before (Hive 2/3):**
```sql
SET hive.execution.engine=tez;
SET hive.vectorized.execution.enabled=true;
SET hive.cbo.enable=true;
```

**After (Hive 4.0):**
```sql
-- All three settings are now defaults. Remove these SET statements.
-- MapReduce is no longer available.
```

**Impact:** Any script setting `hive.execution.engine=mr` will fail in Hive 4.0.

---

### 3.3 Datetime Formatter (Strict Validation)

**What Changed:**
Hive 4.0 switches from `java.text.SimpleDateFormat` (lenient) to `java.time.format.DateTimeFormatter` (strict). Invalid dates now return NULL instead of rolling over.

**Before (Hive 2/3):**
```sql
SELECT unix_timestamp('2023-13-01', 'yyyy-MM-dd');
-- Returns: timestamp for 2024-01-01 (month 13 rolls over)

SELECT cast('2023-02-30' AS DATE);
-- Returns: 2023-03-02 (adjusts invalid day)
```

**After (Hive 4.0):**
```sql
SELECT unix_timestamp('2023-13-01', 'yyyy-MM-dd');
-- Returns: NULL (strict validation rejects month 13)

SELECT cast('2023-02-30' AS DATE);
-- Returns: NULL (strict validation rejects Feb 30)
```

**Rollback option:** `SET hive.datetime.formatter=SIMPLE;` (not recommended for production)

**Impact:** HIGH - Any ETL pipeline relying on lenient date parsing will silently produce NULLs.

---

### 3.4 NULL Ordering (SQL Standard)

**What Changed:**
Default NULL ordering for `ORDER BY ASC` changed from NULLS FIRST to NULLS LAST (SQL standard).

**Before (Hive 2/3):**
```sql
SELECT * FROM sales ORDER BY amount;
-- NULLs appear FIRST (top of results)
```

**After (Hive 4.0):**
```sql
SELECT * FROM sales ORDER BY amount;
-- NULLs appear LAST (bottom of results)
```

**Best Practice:** Always use explicit `NULLS FIRST` or `NULLS LAST`:
```sql
SELECT * FROM sales ORDER BY amount ASC NULLS FIRST;
```

---

### 3.5 ROLLUP and CUBE Syntax

**What Changed:**
The old `GROUP BY x, y WITH ROLLUP` syntax is deprecated. Use standard SQL syntax.

**Before (Hive 2/3):**
```sql
SELECT product_id, sale_date, SUM(amount)
FROM sales
GROUP BY product_id, sale_date
WITH ROLLUP;
```

**After (Hive 4.0):**
```sql
SELECT product_id, sale_date, SUM(amount)
FROM sales
GROUP BY ROLLUP(product_id, sale_date);
```

---

### 3.6 MAPJOIN Hint

**What Changed:**
The `/*+ MAPJOIN(t) */` hint is deprecated. Auto-convert join is enabled by default.

**Before (Hive 2/3):**
```sql
SET hive.auto.convert.join=true;
SELECT /*+ MAPJOIN(p) */ s.sale_id, p.product_name
FROM sales s JOIN ext_products p ON s.product_id = p.product_id;
```

**After (Hive 4.0):**
```sql
-- Auto-convert is default. Use BROADCAST hint if explicit control needed.
SELECT /*+ BROADCAST(p) */ s.sale_id, p.product_name
FROM sales s JOIN ext_products p ON s.product_id = p.product_id;
```

---

### 3.7 ORC Compression Default

**What Changed:**
Default ORC compression algorithm changed from ZLIB to ZSTD.

**Before (Hive 2/3):**
```sql
ALTER TABLE sales SET TBLPROPERTIES ('orc.compress'='ZLIB');
```

**After (Hive 4.0):**
```sql
-- ZSTD is now the default. Explicitly set if needed.
ALTER TABLE sales SET TBLPROPERTIES ('orc.compress'='ZSTD');
```

---

## 4. New Features in Hive 4.0

### 4.1 MERGE INTO (Upsert)
```sql
MERGE INTO target_table AS target
USING source_table AS source
ON target.id = source.id
WHEN MATCHED THEN UPDATE SET col1 = source.col1
WHEN NOT MATCHED THEN INSERT VALUES (source.id, source.col1);
```

### 4.2 Iceberg Table Integration
```sql
CREATE TABLE iceberg_sales (
    sale_id BIGINT,
    amount DECIMAL(12,2)
)
STORED BY ICEBERG;
```

### 4.3 INTERSECT ALL / EXCEPT ALL
```sql
SELECT customer_id FROM sales_2023
INTERSECT ALL
SELECT customer_id FROM sales_2024;
```

### 4.4 typeof() UDF
```sql
SELECT typeof(column_name) FROM table_name;
```

### 4.5 EXPLAIN CBO
```sql
EXPLAIN CBO SELECT customer_id, SUM(amount) FROM sales GROUP BY customer_id;
```

### 4.6 Rebalance Compaction
Evens out file sizes across an ACID table for better query performance.

### 4.7 Lockless Reads
Readers no longer block on writers, enabling zero-wait read operations with optimistic concurrency control.

---

## 5. Configuration Changes

| Property | Hive 2/3 Default | Hive 4.0 Default | Action |
|----------|-----------------|------------------|--------|
| `hive.execution.engine` | `mr` | `tez` (only option) | Remove SET |
| `hive.vectorized.execution.enabled` | `false` | `true` | Remove SET |
| `hive.cbo.enable` | `false` | `true` | Remove SET |
| `hive.exec.dynamic.partition` | `false` | `true` | Remove SET |
| `hive.auto.convert.join` | `false` | `true` | Remove SET |
| `hive.stats.autogather` | `false` | `true` | Remove SET |
| `hive.datetime.formatter` | `SIMPLE` | `DATETIME` | Review date logic |
| `hive.support.sql11.reserved.keywords` | `false` | `true` | Escape keywords |
| `orc.compress` (default) | `ZLIB` | `ZSTD` | Update if needed |

---

## 6. File-by-File Change Summary

| File | Changes Made |
|------|-------------|
| `01_create_databases_and_basic_tables.hql` | Added IF NOT EXISTS, STORED AS TEXTFILE for external table, documented ACID-by-default |
| `02_partitioned_bucketed_table.hql` | Removed `SET hive.exec.dynamic.partition=true` (now default), added IF NOT EXISTS |
| `03_insert_and_dynamic_partition.hql` | Removed redundant TABLE keyword from INSERT INTO |
| `04_acid_transactional_table.hql` | Removed `TBLPROPERTIES ('transactional'='true')`, added MERGE INTO example |
| `05_window_functions.hql` | Added PERCENT_RANK() and NTILE() examples, improved formatting |
| `06_cte_and_subquery.hql` | Added explicit column aliases, INNER JOIN keyword, column list in SELECT |
| `07_json_parsing.hql` | Added json_tuple() as preferred alternative, IF NOT EXISTS |
| `08_complex_data_types.hql` | Added typeof() UDF example, IF NOT EXISTS |
| `09_lateral_view_explode.hql` | Added LATERAL VIEW OUTER and posexplode() examples |
| `10_union_all_and_union_distinct.hql` | Changed UNION to UNION DISTINCT (explicit form) |
| `11_analytics_aggregation_cube_rollup.hql` | Migrated WITH ROLLUP/CUBE to GROUP BY ROLLUP()/CUBE(), added GROUPING() |
| `12_mapjoin_and_query_optimization.hql` | Replaced MAPJOIN hint with BROADCAST, removed auto.convert.join SET |
| `13_materialized_view.hql` | Removed BUILD IMMEDIATE/REFRESH COMPLETE, added ALTER...REBUILD, added query rewriting |
| `14_stats_and_analyze.hql` | Added column-level statistics, auto-gather documentation |
| `15_temp_table_and_views.hql` | Added IF NOT EXISTS, CREATE OR REPLACE VIEW example |
| `16_regexp_and_string_functions.hql` | Added initcap(), char_length(), replace() examples |
| `17_date_functions.hql` | Changed to current_date() form, added extract(), date_sub(), last_day() |
| `18_orc_table_properties_and_compaction.hql` | Changed ZLIB to ZSTD, added bloom filter settings |
| `19_insert_overwrite_and_ctas.hql` | Added STORED AS ORC to CTAS, replaced year() with extract() |
| `20_performance_settings_and_explain.hql` | Commented out default SETs, added EXPLAIN CBO |
| `21_datetime_formatter_behavior_change.hql` | Documented strict vs lenient behavior with examples |
| `22_reserved_keywords_and_ansi_behavior.hql` | Added more reserved keywords (date, position), added SELECT with backticks |
| `23_null_ordering_behavior.hql` | Added explicit ASC/DESC with NULLS FIRST/LAST, documented behavior change |
| `24_acid_compaction_and_locking_behavior.hql` | Added SHOW LOCKS, compaction pooling settings, documented lockless reads |
| `25_set_operations_and_type_promotion.hql` | Added INTERSECT ALL/EXCEPT ALL, changed to INTERSECT/EXCEPT DISTINCT |
