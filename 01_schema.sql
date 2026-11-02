-- Sistema de inventario para pequeños negocios
-- PostgreSQL 14+
BEGIN;
CREATE TABLE IF NOT EXISTS categorias (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre VARCHAR(80) NOT NULL UNIQUE
);
CREATE TABLE IF NOT EXISTS productos (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  categoria_id BIGINT NOT NULL REFERENCES categorias(id),
  nombre VARCHAR(120) NOT NULL,
  sku VARCHAR(30) NOT NULL UNIQUE,
  precio NUMERIC(10,2) NOT NULL CHECK (precio >= 0),
  stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
  stock_minimo INTEGER NOT NULL DEFAULT 5 CHECK (stock_minimo >= 0),
  creado_en TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS movimientos (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  producto_id BIGINT NOT NULL REFERENCES productos(id),
  tipo VARCHAR(7) NOT NULL CHECK (tipo IN ('ENTRADA', 'SALIDA')),
  cantidad INTEGER NOT NULL CHECK (cantidad > 0),
  nota TEXT,
  realizado_en TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_productos_categoria ON productos(categoria_id);
CREATE INDEX IF NOT EXISTS idx_movimientos_producto_fecha ON movimientos(producto_id, realizado_en DESC);
-- Registra un movimiento y actualiza existencias de forma atómica.
CREATE OR REPLACE FUNCTION registrar_movimiento(
  p_producto_id BIGINT, p_tipo VARCHAR, p_cantidad INTEGER, p_nota TEXT DEFAULT NULL
) RETURNS BIGINT LANGUAGE plpgsql AS $$
DECLARE v_id BIGINT;
BEGIN
  IF p_tipo NOT IN ('ENTRADA', 'SALIDA') OR p_tipo IS NULL THEN
    RAISE EXCEPTION 'Tipo no válido: use ENTRADA o SALIDA';
  END IF;
  IF p_cantidad IS NULL OR p_cantidad <= 0 THEN
    RAISE EXCEPTION 'La cantidad debe ser mayor a cero';
  END IF;
  IF p_tipo = 'ENTRADA' THEN
    UPDATE productos SET stock = stock + p_cantidad WHERE id = p_producto_id;
  ELSE
    UPDATE productos SET stock = stock - p_cantidad
      WHERE id = p_producto_id AND stock >= p_cantidad;
  END IF;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Producto inexistente o stock insuficiente';
  END IF;
  INSERT INTO movimientos(producto_id, tipo, cantidad, nota)
  VALUES (p_producto_id, p_tipo, p_cantidad, p_nota) RETURNING id INTO v_id;
  RETURN v_id;
END; $$;
COMMIT;
