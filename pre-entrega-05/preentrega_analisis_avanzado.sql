-- Pre-entrega 5. Ejecutar después de pre-entrega-02/retail_project.sql.
-- Se compara cada mes con el promedio mensual observado de su categoría.

WITH ventas_mensuales AS (
    SELECT DATE_TRUNC('month', v.fecha_venta)::date AS mes,
           c.categoria_id, c.nombre AS categoria,
           SUM(v.cantidad * v.precio_unitario) AS venta_mensual
    FROM ventas AS v
    JOIN productos AS p ON p.producto_id = v.producto_id
    JOIN categorias AS c ON c.categoria_id = p.categoria_id
    GROUP BY DATE_TRUNC('month', v.fecha_venta)::date,
             c.categoria_id, c.nombre
), metricas_ventana AS (
    SELECT vm.*,
           RANK() OVER (
               PARTITION BY vm.mes
               ORDER BY vm.venta_mensual DESC
           ) AS ranking_mes,
           SUM(vm.venta_mensual) OVER (
               PARTITION BY vm.categoria_id
               ORDER BY vm.mes
               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
           ) AS acumulado_categoria,
           AVG(vm.venta_mensual) OVER (
               PARTITION BY vm.categoria_id
           ) AS promedio_mensual_categoria
    FROM ventas_mensuales AS vm
)
SELECT m.mes, m.categoria, m.venta_mensual,
       m.ranking_mes, m.acumulado_categoria,
       ROUND(m.promedio_mensual_categoria, 2) AS promedio_mensual_categoria,
       CASE WHEN m.venta_mensual >= m.promedio_mensual_categoria
            THEN 'Exitoso' ELSE 'Bajo el promedio'
       END AS comparacion
FROM metricas_ventana AS m
ORDER BY m.mes, m.ranking_mes, m.categoria;
