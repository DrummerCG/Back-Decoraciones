## consultar producto por codigo
SELECT * FROM producto WHERE(id='1');

## consultar todas las referencias
SELECT * FROM referencia;

## consultar todos las descripciones de referencia
SELECT descripcion FROM referencia;

## consultar todos las referencias que no son principales
SELECT * FROM referencia WHERE !principal;

## consultar todos los producto con sus referencias (JOIN)
SELECT 
producto.id, 
producto.nombre, 
producto.descripcion AS descripcion_producto, 
referencia.id AS id_referencia, 
referencia.tamano, 
referencia.precio, 
referencia.principal, 
referencia.descripcion AS descripcion_referencia 
FROM producto JOIN referencia 
ON producto.id = referencia.producto_id;