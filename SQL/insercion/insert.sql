INSERT INTO product (name, description) VALUES
  ('Camiseta roja', 'Camiseta de algodón de manga corta en color rojo'),
  ('Zapatos deportivos', 'Zapatos deportivos para correr de color azul'),
  ('Libro de cocina', 'Libro con recetas de cocina tradicional');

INSERT INTO reference (size, price, main, description, product_id) VALUES
  (10.5, 20.00, 1, 'Talla S', 1),
  (12.0, 25.00, 1, 'Talla M', 1),
  (14.0, 30.00, 0, 'Talla L', 1),
  (40.0, 100.00, 1, 'Talla única', 2),
  (42.0, 110.00, 0, 'Talla 42', 2),
  (44.0, 120.00, 0, 'Talla 44', 2),
  (200.0, 50.00, 1, 'Libro en rústica', 3);

INSERT INTO reference_image (url, reference_id) VALUES
  ('https://m.media-amazon.com/images/I/51r+tJ3RiPL._AC_SX679_.jpg', 1), -- Imagen para la referencia con ID 1
  ('https://m.media-amazon.com/images/I/51r+tJ3RiPL._AC_SX679_.jpg', 1), -- Otra imagen para la misma referencia
  ('https://m.media-amazon.com/images/I/51r+tJ3RiPL._AC_SX679_.jpg', 2), -- Imagen para la referencia con ID 2
  ('https://m.media-amazon.com/images/I/51r+tJ3RiPL._AC_SX679_.jpg', 3); -- Imagen para la referencia con ID 3
