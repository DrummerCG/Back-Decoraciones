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