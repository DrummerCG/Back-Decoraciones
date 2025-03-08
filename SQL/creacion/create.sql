CREATE TABLE product (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT
);

CREATE TABLE reference (
  id INT AUTO_INCREMENT PRIMARY KEY,
  size DECIMAL (10,5),
  price DECIMAL (10,5),
  main TINYINT(1),
  description TEXT,
  product_id INT NOT NULL,
  FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE
);

CREATE TABLE reference_image (
  id INT AUTO_INCREMENT PRIMARY KEY,
  url VARCHAR(255),
  reference_id INT NOT NULL,
  FOREIGN KEY (reference_id) REFERENCES reference(id) ON DELETE CASCADE
);

CREATE TABLE solicitud (
  id INT AUTO_INCREMENT PRIMARY KEY,
  fecha_solicitud TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  tipo_solicitud VARCHAR(255) NOT NULL, 
  nombre_completo VARCHAR(255) NOT NULL,
  correo_electronico VARCHAR(255) NOT NULL,
  telefono VARCHAR(255) NOT NULL,
  direccion VARCHAR(255),
  nombre_producto VARCHAR(255),
  id_referencia INT,
  numero_serie VARCHAR(255),
  id_factura VARCHAR(255),
  motivo TEXT,
  estado VARCHAR(255) DEFAULT 'PENDIENTE',
  imagenes_base64 LONGTEXT
);