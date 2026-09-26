-- Pre-entrega 4. Ejecutar después de pre-entrega-02/retail_project.sql.
-- Los importes son ingresos; no hay costos para calcular rentabilidad neta.

-- Q1: categorías que superan 100000 de ingresos históricos.
-- Tres tablas: ventas, productos, categorias. El filtro agregado va en HAVING.
SELECT c.nombre AS categoria,
       SUM(v.cantidad) AS unidades_vendidas,
       SUM(v.cantidad * v.precio_unitario) AS ingreso_total
FROM ventas AS v
JOIN productos AS p ON p.producto_id = v.producto_id
JOIN categorias AS c ON c.categoria_id = p.categoria_id
GROUP BY c.categoria_id, c.nombre
HAVING SUM(v.cantidad * v.precio_unitario) > 100000
ORDER BY ingreso_total DESC, c.nombre;

-- Q2: clientes registrados que aún no compraron, incluida la cuenta de ventas.
SELECT cl.cliente_id, cl.nombre,
       COALESCE(COUNT(v.venta_id), 0) AS cantidad_compras
FROM clientes AS cl
LEFT JOIN ventas AS v ON v.cliente_id = cl.cliente_id
GROUP BY cl.cliente_id, cl.nombre
HAVING COUNT(v.venta_id) = 0
ORDER BY cl.cliente_id;

-- Q3: producto comprado más veces por cliente (frecuencia de transacciones).
-- La última transacción corresponde al cliente, aunque fuera de otro producto.
WITH compras_por_producto AS (
    SELECT cl.cliente_id, cl.nombre AS cliente, p.producto_id,
           p.nombre AS producto, COUNT(*) AS veces_comprado
    FROM clientes AS cl
    JOIN ventas AS v ON v.cliente_id = cl.cliente_id
    JOIN productos AS p ON p.producto_id = v.producto_id
    GROUP BY cl.cliente_id, cl.nombre, p.producto_id, p.nombre
), ultima_compra AS (
    SELECT v.cliente_id, MAX(v.fecha_venta) AS ultima_transaccion
    FROM ventas AS v
    GROUP BY v.cliente_id
), ranking AS (
    SELECT cp.*,
           ROW_NUMBER() OVER (
               PARTITION BY cp.cliente_id
               ORDER BY cp.veces_comprado DESC, cp.producto_id
           ) AS posicion
    FROM compras_por_producto AS cp
)
SELECT r.cliente, r.producto, r.veces_comprado, u.ultima_transaccion
FROM ranking AS r
JOIN ultima_compra AS u ON u.cliente_id = r.cliente_id
WHERE r.posicion = 1
ORDER BY r.veces_comprado DESC, r.cliente_id;
