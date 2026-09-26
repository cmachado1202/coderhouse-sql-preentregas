-- Pre-entrega 2: estructura, carga y mantenimiento de retail_project.
-- Crear una base nueva con CREATE DATABASE retail_project; desde una conexión
-- administrativa. Conectarse a esa base antes de ejecutar este archivo.

BEGIN;

CREATE TABLE categorias (
    categoria_id SERIAL PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE clientes (
    cliente_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(25),
    fecha_alta DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE productos (
    producto_id SERIAL PRIMARY KEY,
    categoria_id INTEGER NOT NULL REFERENCES categorias(categoria_id),
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(12,2) NOT NULL CHECK (precio > 0),
    stock INTEGER NOT NULL CHECK (stock >= 0),
    marca VARCHAR(80) NOT NULL
);

CREATE TABLE ventas (
    venta_id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(cliente_id),
    producto_id INTEGER NOT NULL REFERENCES productos(producto_id),
    fecha_venta DATE NOT NULL,
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(12,2) NOT NULL CHECK (precio_unitario > 0)
);

INSERT INTO categorias (nombre) VALUES
    ('Tecnologia'), ('Hogar'), ('Libreria');

INSERT INTO clientes (nombre, email, telefono, fecha_alta) VALUES
    ('Ana Ruiz', 'ana.ruiz@example.test', '1111111111', '2026-01-05'),
    ('Bruno Diaz', 'bruno.diaz@example.test', '2222222222', '2026-01-07'),
    ('Carla Rios', 'carla.rios@example.test', '3333333333', '2026-01-12'),
    ('Diego Paz', 'diego.paz@example.test', '4444444444', '2026-02-03'),
    ('Elena Soto', 'elena.soto@example.test', '5555555555', '2026-02-10'),
    ('Fabian Luna', 'fabian.luna@example.test', '6666666666', '2026-03-02'),
    ('Gala Mora', 'gala.mora@example.test', '7777777777', '2026-03-10'),
    ('Hugo Vera', 'hugo.vera@example.test', '8888888888', '2026-03-15');

INSERT INTO productos (categoria_id, nombre, precio, stock, marca) VALUES
    (1, 'Auriculares', 25000, 30, 'Norte'),
    (1, 'Teclado', 40000, 20, 'Norte'),
    (1, 'Mouse', 18000, 25, 'Sur'),
    (2, 'Lampara', 22000, 15, 'Casa'),
    (2, 'Taza', 6500, 50, 'Casa'),
    (2, 'Organizador', 12000, 20, 'Casa'),
    (3, 'Cuaderno', 9000, 40, 'Papel'),
    (3, 'Agenda', 15000, 25, 'Papel');

-- Precio unitario histórico: una modificación posterior del catálogo no altera ventas.
INSERT INTO ventas (cliente_id, producto_id, fecha_venta, cantidad, precio_unitario) VALUES
    (1, 1, '2026-01-08', 2, 25000),
    (2, 2, '2026-01-10', 1, 40000),
    (3, 4, '2026-01-12', 2, 22000),
    (1, 1, '2026-01-22', 1, 25000),
    (4, 7, '2026-01-25', 3, 9000),
    (5, 5, '2026-02-05', 4, 6500),
    (2, 3, '2026-02-09', 2, 18000),
    (3, 4, '2026-02-12', 1, 22000),
    (6, 8, '2026-02-16', 2, 15000),
    (1, 2, '2026-02-21', 1, 40000),
    (4, 7, '2026-03-02', 2, 9000),
    (5, 6, '2026-03-04', 3, 12000),
    (6, 1, '2026-03-08', 1, 25000),
    (2, 2, '2026-03-12', 2, 40000),
    (3, 8, '2026-03-14', 1, 15000),
    (1, 1, '2026-03-17', 1, 25000),
    (2, 5, '2026-03-19', 2, 6500),
    (5, 4, '2026-03-21', 1, 22000),
    (1, 3, '2026-03-24', 1, 18000),
    (2, 7, '2026-03-25', 1, 9000);

COMMIT;

-- Inspeccionar primero las filas alcanzadas por cada modificación.
SELECT producto_id, nombre, precio
FROM productos WHERE categoria_id = 1 ORDER BY producto_id;

UPDATE productos
SET precio = ROUND(precio * 1.10, 2)
WHERE categoria_id = 1;

-- Venta temporal identificada expresamente para practicar DELETE con WHERE.
INSERT INTO ventas (venta_id, cliente_id, producto_id, fecha_venta, cantidad, precio_unitario)
VALUES (9999, 1, 1, '2026-03-31', 1, 25000);
SELECT venta_id FROM ventas WHERE venta_id = 9999;
DELETE FROM ventas WHERE venta_id = 9999;

SELECT COUNT(*) AS clientes FROM clientes; -- 8
SELECT COUNT(*) AS productos FROM productos; -- 8
SELECT COUNT(*) AS ventas FROM ventas; -- 20
