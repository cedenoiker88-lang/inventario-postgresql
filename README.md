# Sistema de inventario con PostgreSQL

Proyecto de portafolio: base de datos de inventario para pequeños negocios, con control de stock y reportes SQL.

## Funcionalidades
- Catálogo de categorías y productos con códigos SKU únicos.
- Registro de entradas y salidas mediante función SQL transaccional.
- Protección contra cantidades negativas y salidas sin stock.
- Reportes de inventario, productos por reponer, movimientos y valor por categoría.

## Tecnologías
PostgreSQL 14+ · SQL · PL/pgSQL · pgAdmin 4

## Cómo ejecutarlo
1. Abre **pgAdmin 4** y crea una base de datos llamada `inventario_portafolio`.
2. Selecciona la base de datos y abre **Query Tool**.
3. Abre y ejecuta `sql/01_schema.sql`.
4. Abre y ejecuta `sql/02_datos_demo.sql` (reinicia los datos de prueba cada vez que se ejecuta).
5. Abre y ejecuta `sql/03_reportes.sql`. Puedes ejecutar cada `SELECT` por separado para ver cada reporte.

> Advertencia: el archivo `02_datos_demo.sql` usa `TRUNCATE`; ejecútalo solo en la base de datos de prueba, nunca sobre datos reales.

## Ejemplos de uso
```sql
-- Registrar 4 unidades nuevas del producto 3
SELECT registrar_movimiento(3, 'ENTRADA', 4, 'Nueva compra');

-- Registrar la venta de 2 unidades del producto 3
SELECT registrar_movimiento(3, 'SALIDA', 2, 'Venta');

-- Consultar las existencias actualizadas
SELECT sku, nombre, stock FROM productos ORDER BY id;
```

## Estructura del repositorio
```text
inventario-postgresql/
├── README.md
├── .gitignore
└── sql/
    ├── 01_schema.sql
    ├── 02_datos_demo.sql
    └── 03_reportes.sql
```

## Próximas mejoras
- Interfaz web para gestionar inventario.
- Usuarios y autenticación.
- Pruebas automáticas de reglas de negocio.

## Capturas para el portafolio
Después de ejecutar el proyecto, agrega capturas de la estructura de tablas y de los reportes de pgAdmin. No incluyas contraseñas ni información privada.

## Autor
Sustituye esta sección por tu nombre profesional y enlace de GitHub.
