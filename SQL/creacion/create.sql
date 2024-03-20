CREATE TABLE producto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT
);

CREATE TABLE referencia (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tamano DECIMAL (10,5),
  precio DECIMAL (10,5),
  principal TINYINT(1),
  descripcion TEXT,
  producto_id INT NOT NULL,
  FOREIGN KEY (producto_id) REFERENCES producto(id) ON DELETE CASCADE
);