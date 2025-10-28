-- Missing semicolon
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
)

-- Invalid data type
CREATE TABLE products (
    id INTEGER,
    price MONEY_TYPE,
    name TEXT
);

-- Missing comma between columns
CREATE TABLE orders (
    id SERIAL PRIMARY KEY
    user_id INTEGER
    total DECIMAL(10,2)
);

-- Invalid constraint syntax
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL CONSTRAINT,
    age INTEGER CHECK > 0
);

-- Wrong foreign key syntax
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders,
    FOREIGN KEY order_id REFERENCES orders(id)
);

-- Invalid column name (reserved keyword without quotes)
CREATE TABLE transactions (
    select INTEGER,
    from VARCHAR(50),
    where TIMESTAMP
);

-- Missing parentheses in function
CREATE TABLE logs (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW
);

-- Invalid CHECK constraint
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    salary DECIMAL(10,2) CHECK salary BETWEEN 1000 AND 100000
);

-- Wrong ENUM syntax
CREATE TABLE status_table (
    id SERIAL PRIMARY KEY,
    status ENUM('active', 'inactive')
);

-- Invalid INDEX creation
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200),
    INDEX ON title
);
