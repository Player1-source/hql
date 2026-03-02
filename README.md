# HiveQL Reference Scripts - Apache Hive 4.0

A progressive collection of 25 HiveQL scripts covering major Apache Hive features, **migrated to Apache Hive 4.0** (latest version, released March 2024).

## Migration from Hive 2/3 to Hive 4.0

This repository has been migrated from Hive 2/3 syntax to Hive 4.0. See **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)** for:
- Complete list of breaking changes and their impact
- Step-by-step migration checklist
- Before/after code examples for every change
- New Hive 4.0 features demonstrated in the scripts
- Configuration property changes (defaults that changed)

## Key Changes in Hive 4.0

- **ACID by default**: All managed ORC tables are transactional without extra config
- **Tez-only execution**: MapReduce support removed; Tez is the default engine
- **Strict datetime parsing**: Invalid dates return NULL instead of rolling over
- **SQL-standard NULL ordering**: NULLS LAST for ASC (was NULLS FIRST)
- **Standard ROLLUP/CUBE syntax**: `GROUP BY ROLLUP(x, y)` replaces `WITH ROLLUP`
- **BROADCAST hint**: Replaces deprecated `MAPJOIN` hint
- **ZSTD compression**: Default ORC compression changed from ZLIB to ZSTD
- **New features**: MERGE INTO, Iceberg integration, INTERSECT ALL/EXCEPT ALL, typeof() UDF

## Scripts

| # | File | Topic |
|---|------|-------|
| 01 | `01_create_databases_and_basic_tables.hql` | Database creation, managed vs external tables |
| 02 | `02_partitioned_bucketed_table.hql` | Partitioning and bucketing |
| 03 | `03_insert_and_dynamic_partition.hql` | Dynamic partition inserts |
| 04 | `04_acid_transactional_table.hql` | ACID tables, INSERT/UPDATE/DELETE/MERGE |
| 05 | `05_window_functions.hql` | Window functions (SUM, RANK, PERCENT_RANK, NTILE) |
| 06 | `06_cte_and_subquery.hql` | Common Table Expressions and subqueries |
| 07 | `07_json_parsing.hql` | JSON parsing with get_json_object and json_tuple |
| 08 | `08_complex_data_types.hql` | MAP, ARRAY, STRUCT types and typeof() |
| 09 | `09_lateral_view_explode.hql` | LATERAL VIEW, explode, posexplode |
| 10 | `10_union_all_and_union_distinct.hql` | UNION ALL and UNION DISTINCT |
| 11 | `11_analytics_aggregation_cube_rollup.hql` | ROLLUP, CUBE, GROUPING SETS |
| 12 | `12_mapjoin_and_query_optimization.hql` | BROADCAST hint, auto join optimization |
| 13 | `13_materialized_view.hql` | Materialized views and auto-rewriting |
| 14 | `14_stats_and_analyze.hql` | Table and column statistics |
| 15 | `15_temp_table_and_views.hql` | Temporary tables and views |
| 16 | `16_regexp_and_string_functions.hql` | Regexp and string functions |
| 17 | `17_date_functions.hql` | Date functions and extract() |
| 18 | `18_orc_table_properties_and_compaction.hql` | ORC properties and ZSTD compression |
| 19 | `19_insert_overwrite_and_ctas.hql` | INSERT OVERWRITE and CTAS |
| 20 | `20_performance_settings_and_explain.hql` | Performance defaults and EXPLAIN CBO |
| 21 | `21_datetime_formatter_behavior_change.hql` | Strict datetime parsing behavior |
| 22 | `22_reserved_keywords_and_ansi_behavior.hql` | ANSI SQL reserved keywords |
| 23 | `23_null_ordering_behavior.hql` | NULL ordering (SQL standard) |
| 24 | `24_acid_compaction_and_locking_behavior.hql` | Compaction and lockless reads |
| 25 | `25_set_operations_and_type_promotion.hql` | INTERSECT, EXCEPT, type promotion |
