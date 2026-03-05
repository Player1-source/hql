# HiveQL Modernization Report: Hive 2.x to Apache Hive 4.2.0

## 1. Version Inference

**Inferred source version: Hive 2.x**

Evidence signals detected across the repository:

| Signal | File(s) | Likely Version |
|--------|---------|----------------|
| `SET hive.exec.dynamic.partition=true` | 02 | 2.x (default in 4.2.0) |
| `SET hive.exec.dynamic.partition.mode=nonstrict` | 02 | 2.x (default in 4.2.0) |
| `TBLPROPERTIES ('transactional'='true')` | 04 | 2.x (auto in 4.2.0) |
| `GROUP BY ... WITH ROLLUP/CUBE` | 11 | <=2.x (deprecated syntax) |
| `/*+ MAPJOIN(p) */` hint | 12 | <=2.x (legacy hint) |
| `SET hive.auto.convert.join=true` | 12 | 2.x (default in 4.2.0) |
| `SET hive.execution.engine=tez` | 20 | 2.x (only engine in 4.2.0) |
| `SET hive.vectorized.execution.enabled=true` | 20 | 2.x (default in 4.2.0) |
| `SET hive.cbo.enable=true` | 20 | 2.x (default in 4.2.0) |
| Lenient datetime parsing (month=13) | 21 | 2.x (SimpleDateFormat) |
| `orc.compress='ZLIB'` | 18 | 2.x (ZSTD is 4.2.0 default) |
| `ORDER BY` without explicit NULLS | 23 | 2.x (behavior change) |

---

## 2. Script Classification

### DDL (Data Definition Language)
| File | Statements |
|------|-----------|
| 01 | CREATE DATABASE, CREATE TABLE (managed), CREATE EXTERNAL TABLE |
| 02 | CREATE TABLE (partitioned, bucketed) |
| 04 | CREATE TABLE (ACID transactional) |
| 07 | CREATE TABLE (JSON events) |
| 08 | CREATE TABLE (complex types) |
| 13 | CREATE MATERIALIZED VIEW |
| 15 | CREATE TEMPORARY TABLE, CREATE VIEW |
| 19 | CREATE TABLE AS SELECT (CTAS) |
| 22 | CREATE TABLE (reserved keywords) |

### DML (Data Manipulation Language)
| File | Statements |
|------|-----------|
| 03 | INSERT INTO with dynamic partitioning |
| 04 | INSERT INTO, UPDATE, DELETE |
| 19 | INSERT OVERWRITE |
| 24 | INSERT INTO (batch inserts) |

### Query Constructs
| File | Constructs |
|------|-----------|
| 05 | Window functions (SUM OVER, RANK OVER) |
| 06 | CTE (WITH clause), JOIN, HAVING |
| 07 | get_json_object() |
| 08 | MAP/ARRAY/STRUCT access |
| 09 | LATERAL VIEW explode() |
| 10 | UNION ALL, UNION DISTINCT |
| 11 | ROLLUP, CUBE aggregations |
| 12 | JOIN optimization |
| 16 | regexp_extract, upper, substr |
| 17 | Date functions |
| 25 | UNION ALL, INTERSECT, EXCEPT |

### Performance and Engine
| File | Constructs |
|------|-----------|
| 02 | Dynamic partition configuration |
| 12 | MAPJOIN hint, auto-convert join |
| 14 | ANALYZE TABLE (statistics) |
| 18 | ORC compression, compaction |
| 20 | Engine settings, EXPLAIN ANALYZE |

### Advanced/Operational
| File | Constructs |
|------|-----------|
| 18 | COMPACT, SHOW COMPACTIONS |
| 24 | Compaction workflow, locking |

### Data Type Sensitivities
| File | Constructs |
|------|-----------|
| 21 | Datetime parsing (strict java.time) |
| 23 | NULL ordering behavior |
| 25 | Type promotion in set operations |

---

## 3. Breaking Changes and Risk Scan

### HIGH Impact

| # | Issue | File(s) | Risk |
|---|-------|---------|------|
| 1 | **GROUP BY WITH ROLLUP/CUBE deprecated** -- Must use ANSI GROUP BY ROLLUP()/CUBE() syntax | 11 | Query failure in strict ANSI mode |
| 2 | **Strict java.time datetime parsing** -- Invalid dates (month=13, Feb 30) return NULL instead of rolling over | 21 | Silent data loss if downstream depends on rollover behavior |
| 3 | **Type mismatch in UNION** -- Casting DECIMAL to STRING fails in ANSI mode | 25 | Query failure or incorrect results |

### MEDIUM Impact

| # | Issue | File(s) | Risk |
|---|-------|---------|------|
| 4 | **Redundant transactional property** -- Managed ORC is ACID by default | 04 | Confusion, not functional breakage |
| 5 | **Legacy MAPJOIN hint** -- Unnecessary with auto-conversion | 12 | Performance degradation if hint conflicts with CBO |
| 6 | **ZLIB compression** -- ZSTD is the 4.2.0 default with better ratio and speed | 18 | Performance gap (not breakage) |
| 7 | **NULL ordering ambiguity** -- Bare ORDER BY may sort NULLs differently than Hive 2.x | 23 | Incorrect sort order in applications |

### LOW Impact

| # | Issue | File(s) | Risk |
|---|-------|---------|------|
| 8 | **Redundant SET statements** -- Dynamic partition, engine, vectorization, CBO are now defaults | 02, 12, 20 | No functional impact; clutter |
| 9 | **Missing column aliases with AS** -- ANSI SQL prefers explicit AS keyword | 06 | Warning, not breakage |
| 10 | **Implicit UNION DISTINCT** -- Bare UNION works but explicit DISTINCT is clearer | 10 | No functional impact; readability |
| 11 | **Missing IF NOT EXISTS guards** -- CREATE statements may fail on re-run | 01, 04, 07, 08, 22 | Re-run failures |
| 12 | **Missing STORED AS ORC on CTAS** -- Default may vary; explicit is safer | 19 | Potential format mismatch |

---

## 4. Modernization Suggestions (Numbered)

### Suggestion 1 -- Remove redundant SET statements
- **Impact:** LOW
- **Files:** 02, 12, 20
- **Before:** `SET hive.exec.dynamic.partition=true;`, `SET hive.execution.engine=tez;`, etc.
- **After:** Removed (these are all defaults in Hive 4.2.0)
- **Why:** Reduces clutter; these settings are the only valid values or defaults in 4.2.0

### Suggestion 2 -- Remove redundant TBLPROPERTIES ('transactional'='true')
- **Impact:** MEDIUM
- **Files:** 04
- **Before:** `TBLPROPERTIES ('transactional'='true')`
- **After:** Removed (managed ORC = ACID by default)
- **Why:** Anti-pattern in 4.2.0; all managed ORC tables are automatically ACID-enabled

### Suggestion 3 -- Replace GROUP BY WITH ROLLUP/CUBE with ANSI syntax
- **Impact:** HIGH
- **Files:** 11
- **Before:** `GROUP BY product_id, sale_date WITH ROLLUP`
- **After:** `GROUP BY ROLLUP(product_id, sale_date)`
- **Why:** Legacy WITH ROLLUP/CUBE syntax is deprecated; ANSI syntax is required in 4.2.0

### Suggestion 4 -- Remove legacy MAPJOIN hint
- **Impact:** MEDIUM
- **Files:** 12
- **Before:** `SELECT /*+ MAPJOIN(p) */ s.sale_id, p.product_name ...`
- **After:** `SELECT s.sale_id, p.product_name ...`
- **Why:** Auto-join conversion (default on) handles this; manual hints may conflict with CBO

### Suggestion 5 -- Add strict java.time warnings
- **Impact:** HIGH
- **Files:** 21
- **Before:** `SELECT unix_timestamp('2023-13-01', 'yyyy-MM-dd');` (silently rolls over)
- **After:** Same query with WARNING comment: returns NULL in 4.2.0
- **Why:** java.time is strict; invalid dates return NULL instead of rolling over

### Suggestion 6 -- Change ORC compression from ZLIB to ZSTD
- **Impact:** MEDIUM
- **Files:** 18
- **Before:** `ALTER TABLE sales SET TBLPROPERTIES ('orc.compress'='ZLIB')`
- **After:** `ALTER TABLE sales SET TBLPROPERTIES ('orc.compress'='ZSTD')`
- **Why:** ZSTD provides better compression ratio and speed; it is the 4.2.0 default

### Suggestion 7 -- Make NULL ordering explicit
- **Impact:** MEDIUM
- **Files:** 23
- **Before:** `SELECT ... ORDER BY amount;`
- **After:** `SELECT ... ORDER BY amount ASC NULLS LAST;`
- **Why:** NULL ordering behavior may differ between versions; explicit is deterministic

### Suggestion 8 -- Fix type mismatch in UNION
- **Impact:** HIGH
- **Files:** 25
- **Before:** `SELECT customer_id, cast(amount AS STRING) FROM sales_archive`
- **After:** `SELECT customer_id, CAST(amount AS DECIMAL(12,2)) FROM sales_archive`
- **Why:** ANSI mode requires matching types; DECIMAL to STRING breaks type alignment

### Suggestion 9 -- Make UNION DISTINCT explicit
- **Impact:** LOW
- **Files:** 10
- **Before:** `SELECT ... UNION SELECT ...`
- **After:** `SELECT ... UNION DISTINCT SELECT ...`
- **Why:** Explicit DISTINCT improves readability and intent clarity

### Suggestion 10 -- Add column-level statistics
- **Impact:** LOW
- **Files:** 14
- **Before:** `ANALYZE TABLE sales COMPUTE STATISTICS;`
- **After:** Added `ANALYZE TABLE sales COMPUTE STATISTICS FOR COLUMNS ...;`
- **Why:** Column-level stats significantly improve CBO query planning in 4.2.0

### Suggestion 11 -- Add IF NOT EXISTS guards
- **Impact:** LOW
- **Files:** 01, 04, 07, 08, 15, 22
- **Before:** `CREATE TABLE customers (...)`
- **After:** `CREATE TABLE IF NOT EXISTS customers (...)`
- **Why:** Prevents re-run failures; idempotent DDL

### Suggestion 12 -- Add explicit AS keyword for column aliases
- **Impact:** LOW
- **Files:** 06, 08, 16, 19
- **Before:** `SUM(amount) total_spent`
- **After:** `SUM(amount) AS total_spent`
- **Why:** ANSI SQL compliance; explicit aliases are clearer

### Suggestion 13 -- Enable auto-compaction for ACID tables
- **Impact:** MEDIUM
- **Files:** 18, 24
- **Before:** Manual COMPACT commands only
- **After:** Added auto-compaction TBLPROPERTIES configuration
- **Why:** Auto-compaction reduces operational burden in 4.2.0

### Suggestion 14 -- Add explicit STORED AS ORC for CTAS and managed tables
- **Impact:** LOW
- **Files:** 07, 13, 19
- **Before:** CREATE TABLE / CTAS without explicit storage format
- **After:** Added `STORED AS ORC`
- **Why:** Explicit format prevents unexpected defaults; clarity

---

## 5. Iceberg v3 Migration Recommendation

**Recommendation: Not required for this repository.**

**Reasoning:**
- The repository consists of teaching/reference scripts, not production ETL pipelines
- No tables exhibit the Iceberg migration triggers:
  - No excessive partition explosion
  - No heavy JSON workloads requiring Variant type
  - No SCD (Slowly Changing Dimension) patterns
  - No frequent compaction bottlenecks at scale
  - No need for deletion vectors or Z-ordering

**Note:** For production workloads derived from these patterns, Iceberg v3 migration should be evaluated for:
- `transactions_acid` -- if transaction volume grows significantly
- `sales` -- if partition count exceeds thousands and compaction becomes a bottleneck
- `json_events` -- if JSON payload processing requires the Variant type

---

## 6. Cross-File Dependency Analysis

```
01_create_databases_and_basic_tables.hql
  Creates: retail_db, customers, ext_products
    Used by: 06 (customers), 12 (ext_products), 16 (customers)
    Foundation for all subsequent scripts

02_partitioned_bucketed_table.hql
  Creates: sales
    Used by: 03, 05, 06, 10, 11, 12, 13, 14, 15, 18, 19, 22, 23, 25
    Central fact table

03_insert_and_dynamic_partition.hql
  Requires: staging_sales (external dependency), sales (from 02)
    Populates: sales table

04_acid_transactional_table.hql
  Creates: transactions_acid
    Used by: 18, 24
    Independent of sales pipeline

07_json_parsing.hql
  Creates: json_events -- Self-contained

08_complex_data_types.hql
  Creates: nested_data
    Used by: 09 -- Self-contained

22_reserved_keywords_and_ansi_behavior.hql
  Creates: keyword_test -- Self-contained
```

---

## 7. Recommended Execution Order

Execute scripts in this order to satisfy all dependencies:

| Phase | Scripts | Purpose |
|-------|---------|---------|
| 1. Foundation | 01 | Create database and base tables |
| 2. Schema | 02, 04, 07, 08, 22 | Create remaining tables |
| 3. Data Load | 03 | Populate sales from staging |
| 4. Analytics | 05, 06, 09, 10, 11, 25 | Run analytical queries |
| 5. Optimization | 12, 14, 18, 20 | Performance tuning |
| 6. Derived Objects | 13, 15, 19 | Create views and derived tables |
| 7. Functions | 16, 17 | String and date functions |
| 8. Behavior | 21, 23 | Datetime and NULL ordering |
| 9. Operations | 24 | Compaction and locking |

---

## 8. Migration Risk Summary

| Risk Level | Count | Description |
|-----------|-------|-------------|
| **HIGH** | 3 | GROUP BY WITH ROLLUP/CUBE, strict java.time, UNION type mismatch |
| **MEDIUM** | 4 | Redundant transactional property, legacy MAPJOIN, ZLIB compression, NULL ordering |
| **LOW** | 5 | Redundant SETs, missing AS keyword, implicit UNION DISTINCT, missing IF NOT EXISTS, missing STORED AS |

**Overall Migration Risk: MEDIUM**
- 3 breaking changes require code modifications (all addressed in modernized scripts)
- 4 medium-risk items require attention but won't cause immediate failures
- 5 low-risk items are best-practice improvements

---

## 9. Next Steps

1. **Review modernized scripts** -- Each file contains a header with changes applied and verification steps
2. **Run verification steps** -- Execute the commented verification queries in each file against a Hive 4.2.0 environment
3. **Validate datetime behavior** -- Particularly script 21; ensure downstream processes handle NULL for invalid dates
4. **Update compression** -- Run script 18 to switch existing tables from ZLIB to ZSTD
5. **Enable auto-compaction** -- Configure auto-compaction for production ACID tables (script 18, 24)
6. **Monitor CBO plans** -- Run EXPLAIN on critical queries to verify optimal join strategies without MAPJOIN hints
7. **Consider Iceberg v3** -- For production workloads at scale, evaluate Iceberg migration for tables with heavy compaction or partition explosion
