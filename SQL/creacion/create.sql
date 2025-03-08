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

CREATE TABLE request (
  id INT AUTO_INCREMENT PRIMARY KEY,
  request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  request_type VARCHAR(255) NOT NULL, 
  fullname VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  phone VARCHAR(255) NOT NULL,
  address VARCHAR(255),
  product_name VARCHAR(255),
  reference_id INT,
  serial_number VARCHAR(255),
  invoice_id VARCHAR(255),
  reason TEXT,
  status VARCHAR(255) DEFAULT 'PENDING',
  images_base64 LONGTEXT
);