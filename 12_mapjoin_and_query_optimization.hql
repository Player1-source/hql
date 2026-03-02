-- =============================================================================
-- 12. Map Join and Query Optimization
-- Hive 4.0 Migration Notes:
--   * hive.auto.convert.join=true is now the DEFAULT. No need to SET it.
--   * The /*+ MAPJOIN(t) */ hint is DEPRECATED.
--     Use /*+ BROADCAST(t) */ or rely on auto-convert (recommended).
--   * Hive 4.0 CBO automatically determines the optimal join strategy.
--   * hive.auto.convert.join.noconditionaltask.size controls the threshold
--     for auto broadcast join (default: 10MB).
-- =============================================================================

-- Hive 4.0: auto.convert.join is enabled by default. SET removed.
-- MAPJOIN hint replaced with BROADCAST hint (or rely on auto-convert).
SELECT /*+ BROADCAST(p) */ s.sale_id, p.product_name
FROM sales s
JOIN ext_products p
ON s.product_id = p.product_id;

-- Alternative: Let Hive CBO decide the join strategy automatically (preferred)
SELECT s.sale_id, p.product_name
FROM sales s
JOIN ext_products p
ON s.product_id = p.product_id;
