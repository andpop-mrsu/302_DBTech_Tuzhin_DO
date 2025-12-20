-- db_init.sql для базы данных автомойки
-- Лабораторная работа 7


DROP TABLE IF EXISTS salary_calculations;
DROP TABLE IF EXISTS completed_services;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS service_prices;
DROP TABLE IF EXISTS wash_boxes;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS car_categories;
DROP TABLE IF EXISTS employees;

-- 1. Таблица сотрудников
CREATE TABLE employees (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(50) NOT NULL CHECK (position IN ('master', 'manager', 'administrator')),
    hire_date DATE NOT NULL,
    dismissal_date DATE,
    salary_percent DECIMAL(5,2) DEFAULT 30.00 CHECK (salary_percent BETWEEN 0 AND 100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Таблица категорий автомобилей
CREATE TABLE car_categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

-- 3. Таблица услуг
CREATE TABLE services (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    duration_minutes INTEGER NOT NULL CHECK (duration_minutes > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Таблица цен услуг по категориям 
CREATE TABLE service_prices (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    service_id INTEGER NOT NULL,
    car_category_id INTEGER NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE,
    FOREIGN KEY (car_category_id) REFERENCES car_categories(id) ON DELETE CASCADE,
    UNIQUE(service_id, car_category_id)
);

-- 5. Таблица боксов мойки
CREATE TABLE wash_boxes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- 6. Таблица записей
CREATE TABLE appointments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    customer_phone VARCHAR(20),
    car_model VARCHAR(100),
    car_category_id INTEGER NOT NULL,
    wash_box_id INTEGER NOT NULL,
    employee_id INTEGER NOT NULL,
    appointment_date DATETIME NOT NULL,
    duration_minutes INTEGER NOT NULL CHECK (duration_minutes > 0),
    total_price DECIMAL(10,2) NOT NULL CHECK (total_price >= 0),
    status VARCHAR(20) DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'completed', 'cancelled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_category_id) REFERENCES car_categories(id),
    FOREIGN KEY (wash_box_id) REFERENCES wash_boxes(id),
    FOREIGN KEY (employee_id) REFERENCES employees(id)
);

-- 7. Таблица выполненных услуг
CREATE TABLE completed_services (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    appointment_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    employee_id INTEGER NOT NULL,
    actual_duration_minutes INTEGER CHECK (actual_duration_minutes > 0),
    actual_price DECIMAL(10,2) NOT NULL CHECK (actual_price >= 0),
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id),
    FOREIGN KEY (service_id) REFERENCES services(id),
    FOREIGN KEY (employee_id) REFERENCES employees(id)
);

-- 8. Таблица расчетов зарплаты
CREATE TABLE salary_calculations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id INTEGER NOT NULL,
    calculation_date DATE NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_revenue DECIMAL(10,2) NOT NULL CHECK (total_revenue >= 0),
    salary_percent DECIMAL(5,2) NOT NULL CHECK (salary_percent BETWEEN 0 AND 100),
    calculated_salary DECIMAL(10,2) NOT NULL CHECK (calculated_salary >= 0),
    calculated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(id),
    CHECK (start_date <= end_date)
);

-- Индексы для ускорения поиска
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_appointments_status ON appointments(status);
CREATE INDEX idx_employees_active ON employees(is_active);
CREATE INDEX idx_completed_services_date ON completed_services(completed_at);
CREATE INDEX idx_salary_calculations_period ON salary_calculations(start_date, end_date);


-- Сотрудники
INSERT INTO employees (first_name, last_name, position, hire_date, salary_percent) VALUES
('Иван', 'Петров', 'master', '2023-01-15', 35.00),
('Анна', 'Сидорова', 'master', '2023-02-20', 32.50),
('Сергей', 'Козлов', 'manager', '2023-03-10', 25.00),
('Мария', 'Иванова', 'administrator', '2023-04-05', 28.00),
('Алексей', 'Смирнов', 'master', '2023-05-12', 30.00),
('Ольга', 'Кузнецова', 'master', '2023-06-18', 33.00);

-- Уволенный сотрудник 
INSERT INTO employees (first_name, last_name, position, hire_date, dismissal_date, salary_percent, is_active) VALUES
('Дмитрий', 'Васильев', 'master', '2022-11-01', '2023-07-01', 30.00, FALSE);

-- Категории автомобилей
INSERT INTO car_categories (name, description) VALUES
('Легковой', 'Легковые автомобили до 5 мест'),
('Внедорожник', 'Внедорожники и кроссоверы'),
('Минивэн', 'Минивэны и микроавтобусы'),
('Бизнес-класс', 'Автомобили бизнес-класса'),
('Премиум', 'Премиальные автомобили');

-- Услуги
INSERT INTO services (name, description, duration_minutes) VALUES
('Мойка кузова', 'Наружная мойка автомобиля', 30),
('Чистка салона', 'Полная чистка салона пылесосом', 45),
('Полировка', 'Полировка кузова', 90),
('Химчистка', 'Глубокая химчистка салона', 120),
('Мойка двигателя', 'Чистка двигателя', 60),
('Покрытие воском', 'Нанесение защитного воска', 40);

-- Цены услуг по категориям
INSERT INTO service_prices (service_id, car_category_id, price) VALUES
(1, 1, 500.00), (1, 2, 700.00), (1, 3, 800.00), (1, 4, 1000.00), (1, 5, 1500.00),
(2, 1, 800.00), (2, 2, 1000.00), (2, 3, 1200.00), (2, 4, 1500.00), (2, 5, 2000.00),
(3, 1, 2000.00), (3, 2, 2500.00), (3, 3, 3000.00), (3, 4, 4000.00), (3, 5, 6000.00),
(4, 1, 3000.00), (4, 2, 3500.00), (4, 3, 4000.00), (4, 4, 5000.00), (4, 5, 8000.00),
(5, 1, 1000.00), (5, 2, 1200.00), (5, 3, 1500.00), (5, 4, 1800.00), (5, 5, 2500.00),
(6, 1, 1500.00), (6, 2, 1800.00), (6, 3, 2000.00), (6, 4, 2500.00), (6, 5, 3500.00);

-- Боксы мойки
INSERT INTO wash_boxes (name) VALUES
('Бокс 1'), ('Бокс 2'), ('Бокс 3'), ('Бокс 4');

-- Записи
INSERT INTO appointments (customer_name, customer_phone, car_model, car_category_id, wash_box_id, employee_id, appointment_date, duration_minutes, total_price, status) VALUES
('Александр Сергеев', '+79161234567', 'Toyota Camry', 1, 1, 1, '2024-01-15 10:00:00', 30, 500.00, 'completed'),
('Екатерина Морозова', '+79162345678', 'Honda CR-V', 2, 2, 2, '2024-01-15 11:00:00', 45, 1000.00, 'completed'),
('Михаил Волков', '+79163456789', 'Mercedes S-Class', 4, 3, 1, '2024-01-15 14:00:00', 90, 4000.00, 'completed'),
('Ольга Николаева', '+79164567890', 'Volkswagen Caravelle', 3, 4, 2, '2024-01-16 09:00:00', 120, 4000.00, 'scheduled'),
('Денис Соколов', '+79165678901', 'BMW X5', 5, 1, 5, '2024-01-16 11:00:00', 60, 2500.00, 'scheduled');

-- Выполненные услуги
INSERT INTO completed_services (appointment_id, service_id, employee_id, actual_duration_minutes, actual_price) VALUES
(1, 1, 1, 35, 500.00),
(2, 1, 2, 40, 700.00),
(2, 2, 2, 50, 1000.00),
(3, 3, 1, 95, 4000.00);

-- Расчеты зарплаты
INSERT INTO salary_calculations (employee_id, calculation_date, start_date, end_date, total_revenue, salary_percent, calculated_salary) VALUES
(1, '2024-01-15', '2024-01-01', '2024-01-15', 4500.00, 35.00, 1575.00),
(2, '2024-01-15', '2024-01-01', '2024-01-15', 1700.00, 32.50, 552.50),
(6, '2024-01-15', '2024-01-01', '2024-01-15', 0.00, 33.00, 0.00);


CREATE VIEW IF NOT EXISTS wash_box_occupancy AS
SELECT 
    wb.name as box_name,
    COUNT(a.id) as total_appointments,
    SUM(a.duration_minutes) as total_minutes,
    AVG(a.duration_minutes) as avg_duration
FROM wash_boxes wb
LEFT JOIN appointments a ON wb.id = a.wash_box_id
GROUP BY wb.id, wb.name;

CREATE VIEW IF NOT EXISTS employee_statistics AS
SELECT 
    e.id,
    e.first_name || ' ' || e.last_name as employee_name,
    e.position,
    e.is_active,
    COUNT(DISTINCT a.id) as total_appointments,
    COUNT(DISTINCT cs.id) as completed_services,
    COALESCE(SUM(cs.actual_price), 0) as total_revenue
FROM employees e
LEFT JOIN appointments a ON e.id = a.employee_id
LEFT JOIN completed_services cs ON e.id = cs.employee_id
GROUP BY e.id;

CREATE VIEW IF NOT EXISTS service_popularity AS
SELECT 
    s.name as service_name,
    COUNT(cs.id) as times_performed,
    SUM(cs.actual_price) as total_revenue,
    AVG(cs.actual_duration_minutes) as avg_duration
FROM services s
LEFT JOIN completed_services cs ON s.id = cs.service_id
GROUP BY s.id;

CREATE TRIGGER IF NOT EXISTS update_appointment_status 
AFTER INSERT ON completed_services
BEGIN
    UPDATE appointments 
    SET status = 'completed' 
    WHERE id = NEW.appointment_id;
END;

CREATE TRIGGER IF NOT EXISTS check_box_availability 
BEFORE INSERT ON appointments
BEGIN
    SELECT 
        CASE 
            WHEN EXISTS (
                SELECT 1 FROM appointments a2 
                WHERE a2.wash_box_id = NEW.wash_box_id 
                AND a2.appointment_date <= datetime(NEW.appointment_date, '+' || NEW.duration_minutes || ' minutes')
                AND datetime(a2.appointment_date, '+' || a2.duration_minutes || ' minutes') >= NEW.appointment_date
                AND a2.status != 'cancelled'
            ) 
            THEN RAISE(ABORT, 'Бокс занят в это время')
        END;
END;

PRAGMA foreign_keys = ON;