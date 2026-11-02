-- Ejecutar en una base de datos de prueba después de 01_schema.sql.
-- Reinicia los registros de ejemplo para poder ejecutar este archivo varias veces.
BEGIN;
TRUNCATE TABLE movimientos, productos, categorias RESTART IDENTITY CASCADE;
INSERT INTO categorias(nombre) VALUES ('Bebidas'), ('Snacks'), ('Limpieza');
INSERT INTO productos(categoria_id, nombre, sku, precio, stock, stock_minimo) VALUES
 (1, 'Agua 500 ml', 'BEB-001', 0.60, 20, 8),
 (1, 'Jugo natural', 'BEB-002', 1.50, 6, 10),
 (2, 'Galletas', 'SNA-001', 0.75, 15, 5),
 (2, 'Papas fritas', 'SNA-002', 1.00, 4, 6),
 (3, 'Jabón líquido', 'LIM-001', 2.90, 12, 4);
-- Movimientos de demostración (stock inicial ya cargado arriba).
SELECT registrar_movimiento(1, 'SALIDA', 3, 'Venta en mostrador');
SELECT registrar_movimiento(2, 'ENTRADA', 10, 'Reposición de proveedor');
SELECT registrar_movimiento(4, 'SALIDA', 2, 'Venta en mostrador');
COMMIT;
