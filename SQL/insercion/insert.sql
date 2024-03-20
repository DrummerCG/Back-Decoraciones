INSERT INTO producto (nombre, descripcion) VALUES
  ('Camiseta roja', 'Camiseta de algodón de manga corta en color rojo'),
  ('Zapatos deportivos', 'Zapatos deportivos para correr de color azul'),
  ('Libro de cocina', 'Libro con recetas de cocina tradicional');

INSERT INTO referencia (tamano, precio, principal, descripcion, producto_id) VALUES
  (10.5, 20.00, 1, 'Talla S', 1),
  (12.0, 25.00, 1, 'Talla M', 1),
  (14.0, 30.00, 0, 'Talla L', 1),
  (40.0, 100.00, 1, 'Talla única', 2),
  (42.0, 110.00, 0, 'Talla 42', 2),
  (44.0, 120.00, 0, 'Talla 44', 2),
  (200.0, 50.00, 1, 'Libro en rústica', 3);
