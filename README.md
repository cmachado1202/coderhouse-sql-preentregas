# Preentregas de SQL y PostgreSQL

**Carolina Machado · Coderhouse**

Este repositorio reúne las siete preentregas del curso. Los ejemplos de datos son ficticios.

| Carpeta | Entregable | Tema |
|---|---|---|
| `pre-entrega-01` | PDF | Modelo ER y normalización para PetStop |
| `pre-entrega-02` | `retail_project.sql` | Tablas, restricciones, carga y DML |
| `pre-entrega-03` | PDF | Cuatro consultas de NULL y COALESCE |
| `pre-entrega-04` | `pre-entrega-modulo4.sql` | JOIN, agrupación y HAVING |
| `pre-entrega-05` | `preentrega_analisis_avanzado.sql` | CTE, ranking y acumulados |
| `pre-entrega-06` | PDF | Selección y costos de índices |
| `pre-entrega-07` | PDF | Roles y permisos |

## Ejecución de los scripts

Crear una base vacía `retail_project` en PostgreSQL y conectarse a ella. Ejecutar `pre-entrega-02/retail_project.sql` completo una sola vez; después, ejecutar los scripts de las preentregas 4 y 5. La carga deja ocho clientes, ocho productos y veinte ventas. Los precios de catálogo cambian con el `UPDATE`; las ventas conservan el precio histórico. El script de estructura no borra objetos existentes y requiere una base vacía.

Las preentregas 1, 3, 6 y 7 tienen formato PDF porque esas consignas piden un documento. Los scripts y ejemplos no contienen datos de clientes reales ni credenciales de producción.

La plataforma marcaba las siete preentregas como vencidas y deshabilitaba el envío al revisarlas el 26/09/2026. Publicar aquí los archivos no cambia ese estado en Coderhouse.
