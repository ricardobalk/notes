CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    product VARCHAR(100),
    quantity INT,
    price DECIMAL(10,2),
    sale_date TIMESTAMP DEFAULT NOW()
);

INSERT INTO sales (product, quantity, price, sale_date) VALUES
('Laptop', 5, 1200.00, '2024-01-01'),
('Keyboard', 10, 50.00, '2024-01-02'),
('Mouse', 8, 25.00, '2024-01-03'),
('Monitor', 3, 300.00, '2024-01-04'),
('Headset', 6, 80.00, '2024-01-05'),
('Docking Station', 2, 200.00, '2024-01-06');