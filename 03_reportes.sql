-- REPORTE 1: Inventario y valor de existencias
SELECT p.sku, p.nombre, c.nombre AS categoria, p.precio, p.stock,
       (p.precio * p.stock) AS valor_inventario
FROM productos p JOIN categorias c ON c.id = p.categoria_id
ORDER BY c.nombre, p.nombre;

-- REPORTE 2: Productos con bajo stock
SELECT sku, nombre, stock, stock_minimo
FROM productos
WHERE stock <= stock_minimo
ORDER BY stock ASC, nombre;

-- REPORTE 3: Historial de entradas y salidas
SELECT m.id, p.nombre AS producto, m.tipo, m.cantidad, m.nota, m.realizado_en
FROM movimientos m JOIN productos p ON p.id = m.producto_id
ORDER BY m.realizado_en DESC, m.id DESC;

-- REPORTE 4: Valor del inventario por categoría
SELECT c.nombre AS categoria, COUNT(p.id) AS productos,
       COALESCE(SUM(p.precio * p.stock), 0) AS valor_total
FROM categorias c LEFT JOIN productos p ON p.categoria_id = c.id
GROUP BY c.id, c.nombre ORDER BY valor_total DESC;

-- REPORTE 5: Movimientos por producto
SELECT p.sku, p.nombre,
       COALESCE(SUM(CASE WHEN m.tipo = 'ENTRADA' THEN m.cantidad ELSE 0 END), 0) AS unidades_entrantes,
       COALESCE(SUM(CASE WHEN m.tipo = 'SALIDA' THEN m.cantidad ELSE 0 END), 0) AS unidades_salientes
FROM productos p LEFT JOIN movimientos m ON m.producto_id = p.id
GROUP BY p.id, p.sku, p.nombre ORDER BY p.nombre;
