/* Criando Base */

-- Criar o database, se não existir
CREATE DATABASE IF NOT EXISTS fiapx;

USE fiapx;

CREATE USER 'user_fiap'@'%' IDENTIFIED BY 'pass_fiap';
GRANT SELECT, INSERT, UPDATE, DELETE ON fiapx.* TO 'user_fiap'@'%';
FLUSH PRIVILEGES;

CREATE TABLE users (
    id VARCHAR(36) NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE video_processings (
    id VARCHAR(36) NOT NULL PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    original_file_name VARCHAR(255) NOT NULL,
    status ENUM('Pending', 'Processing', 'Completed', 'Failed') NOT NULL DEFAULT 'Pending',
    s3_input_path VARCHAR(1024) NOT NULL,
    s3_output_path VARCHAR(1024) NULL,
    failure_reason TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at DATETIME NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_user_id ON video_processings(user_id);
CREATE INDEX idx_status ON video_processings(status);

-- INSERT INTO users (id, name, email, password_hash) VALUES ('1', 'Admin User', 'admin@example.com', '');