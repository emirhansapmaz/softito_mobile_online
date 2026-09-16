CREATE TABLE IF NOT EXISTS orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    order_number VARCHAR(50) NOT NULL UNIQUE,
    order_date DATE DEFAULT CURRENT_DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO orders (user_id, order_number, total_amount) VALUES 
(1, 'ORD-2024-001', 1250.50),
(1, 'ORD-2024-002', 450.00),
(2, 'ORD-2024-003', 890.90);

SELECT 
    users.fullname,
    users.email,
    orders.order_number
FROM users
INNER JOIN orders ON users.id = orders.user_id;
