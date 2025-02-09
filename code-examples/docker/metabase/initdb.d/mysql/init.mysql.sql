CREATE TABLE website_traffic (
    id INT AUTO_INCREMENT PRIMARY KEY,
    visitor_id VARCHAR(50),
    page_viewed VARCHAR(255),
    time_spent INT,
    visit_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO website_traffic (visitor_id, page_viewed, time_spent, visit_date) VALUES
('user_1', '/home', 45, '2024-02-01 10:00:00'),
('user_2', '/product', 120, '2024-02-01 10:05:00'),
('user_3', '/checkout', 30, '2024-02-01 10:10:00'),
('user_4', '/home', 60, '2024-02-01 10:15:00'),
('user_5', '/about', 90, '2024-02-01 10:20:00'),
('user_6', '/contact', 20, '2024-02-01 10:25:00');