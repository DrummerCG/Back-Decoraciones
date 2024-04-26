## consultar producto por codigo
SELECT * FROM product WHERE(id='1');

## consultar todas las referencias
SELECT * FROM reference;

## consultar todos las descripciones de reference
SELECT descripcion FROM reference;

## consultar todos las references que no son principales
SELECT * FROM reference WHERE !principal;

## consultar todos los productos con sus references (JOIN)
SELECT 
product.id, 
product.name, 
product.description AS product_description, 
reference.id AS reference_id, 
reference.size, 
reference.price, 
reference.main, 
reference.description AS reference_description 
FROM product JOIN reference 
ON product.id = reference.product_id;

## consultar todos los productos con sus referencias (JOIN)
SELECT 
  product.id, 
  product.name, 
  product.description AS product_description, 
  reference.id AS reference_id, 
  reference.size, 
  reference.price, 
  reference.main, 
  reference.description AS reference_description,
  reference_image.url AS image_url -- Agrega la columna de URL de imagen
FROM product 
JOIN reference ON product.id = reference.product_id
LEFT JOIN reference_image ON reference.id = reference_image.reference_id; -- Realiza un LEFT JOIN con reference_image
