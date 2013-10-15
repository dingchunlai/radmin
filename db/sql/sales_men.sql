
CREATE TABLE sales_men(
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  address VARCHAR(255),
  email VARCHAR(255) NOT NULL,
  city VARCHAR(150),
  telephone VARCHAR(100),
  deleted tinyint(1) DEFAULT '0',
  created_at DATETIME,  
  updated_at DATETIME 
) ENGINE InnoDB CHARACTER SET utf8;

CREATE INDEX sales_men_of_name ON sales_men (name(150));
CREATE INDEX sales_men_of_city ON sales_men (city(150));

ALTER TABLE `deco_firms` ADD COLUMN `sales_man_id` INT(11);
