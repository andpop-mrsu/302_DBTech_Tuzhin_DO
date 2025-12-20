<?php
// Подключение к базе данных
function getPDO() {
    static $pdo = null;
    if ($pdo === null) {
        try {
            $dbFile = __DIR__ . '/../data/carwash.db';
            
            // Создаем директорию если не существует
            $dbDir = dirname($dbFile);
            if (!is_dir($dbDir)) {
                mkdir($dbDir, 0777, true);
            }
            
            $pdo = new PDO('sqlite:' . $dbFile);
            $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
            
            // Включаем поддержку внешних ключей
            $pdo->exec('PRAGMA foreign_keys = ON');
            
        } catch (PDOException $e) {
            die('Ошибка подключения к БД: ' . $e->getMessage());
        }
    }
    return $pdo;
}

// Инициализация базы данных
function initDatabase() {
    $pdo = getPDO();
    
    // Таблица мастеров
    $pdo->exec("
        CREATE TABLE IF NOT EXISTS masters (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            first_name TEXT NOT NULL,
            last_name TEXT NOT NULL,
            position TEXT DEFAULT 'Мастер',
            hire_date DATE NOT NULL,
            salary_percent REAL DEFAULT 30.00,
            is_active INTEGER DEFAULT 1,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ");
    
    // Таблица графика работы
    $pdo->exec("
        CREATE TABLE IF NOT EXISTS schedule (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            master_id INTEGER NOT NULL,
            work_date DATE NOT NULL,
            start_time TEXT NOT NULL,
            end_time TEXT NOT NULL,
            FOREIGN KEY (master_id) REFERENCES masters(id) ON DELETE CASCADE
        )
    ");
    
    // Таблица выполненных работ
    $pdo->exec("
        CREATE TABLE IF NOT EXISTS completed_works (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            master_id INTEGER NOT NULL,
            service_name TEXT NOT NULL,
            car_model TEXT,
            work_date DATE NOT NULL,
            price REAL NOT NULL,
            FOREIGN KEY (master_id) REFERENCES masters(id) ON DELETE CASCADE
        )
    ");
    
    // Проверяем есть ли данные
    $stmt = $pdo->query("SELECT COUNT(*) as count FROM masters");
    $result = $stmt->fetch();
    
    if ($result['count'] == 0) {
        // Добавляем тестовые данные
        $pdo->exec("
            INSERT INTO masters (first_name, last_name, position, hire_date, salary_percent, is_active) VALUES
            ('Иван', 'Петров', 'Старший мастер', '2023-01-15', 35.00, 1),
            ('Анна', 'Сидорова', 'Мастер', '2023-02-20', 32.50, 1),
            ('Алексей', 'Смирнов', 'Мастер', '2023-05-12', 30.00, 1),
            ('Ольга', 'Кузнецова', 'Мастер', '2023-06-18', 33.00, 1)
        ");
        
        $pdo->exec("
            INSERT INTO schedule (master_id, work_date, start_time, end_time) VALUES
            (1, '2024-01-20', '09:00', '17:00'),
            (1, '2024-01-21', '09:00', '17:00'),
            (2, '2024-01-20', '10:00', '18:00'),
            (3, '2024-01-21', '12:00', '20:00')
        ");
        
        $pdo->exec("
            INSERT INTO completed_works (master_id, service_name, car_model, work_date, price) VALUES
            (1, 'Мойка кузова', 'Toyota Camry', '2024-01-15', 500.00),
            (1, 'Полировка', 'BMW X5', '2024-01-16', 2000.00),
            (2, 'Чистка салона', 'Honda CR-V', '2024-01-15', 1000.00),
            (3, 'Химчистка', 'Mercedes S-Class', '2024-01-17', 3000.00)
        ");
    }
}

// Получить всех мастеров (отсортированных по фамилии)
function getAllMasters() {
    $pdo = getPDO();
    $stmt = $pdo->query("SELECT * FROM masters ORDER BY last_name, first_name");
    return $stmt->fetchAll();
}

// Получить мастера по ID
function getMasterById($id) {
    $pdo = getPDO();
    $stmt = $pdo->prepare("SELECT * FROM masters WHERE id = ?");
    $stmt->execute([$id]);
    return $stmt->fetch();
}

// Добавить нового мастера
function addMaster($data) {
    $pdo = getPDO();
    $stmt = $pdo->prepare("
        INSERT INTO masters (first_name, last_name, position, hire_date, salary_percent, is_active)
        VALUES (?, ?, ?, ?, ?, ?)
    ");
    
    return $stmt->execute([
        $data['first_name'],
        $data['last_name'],
        $data['position'] ?? 'Мастер',
        $data['hire_date'],
        $data['salary_percent'] ?? 30.00,
        $data['is_active'] ?? 1
    ]);
}

// Обновить данные мастера
function updateMaster($id, $data) {
    $pdo = getPDO();
    $stmt = $pdo->prepare("
        UPDATE masters 
        SET first_name = ?, last_name = ?, position = ?, hire_date = ?, 
            salary_percent = ?, is_active = ?
        WHERE id = ?
    ");
    
    return $stmt->execute([
        $data['first_name'],
        $data['last_name'],
        $data['position'],
        $data['hire_date'],
        $data['salary_percent'],
        $data['is_active'],
        $id
    ]);
}

// Удалить мастера
function deleteMaster($id) {
    $pdo = getPDO();
    $stmt = $pdo->prepare("DELETE FROM masters WHERE id = ?");
    return $stmt->execute([$id]);
}

// Получить график работы мастера
function getMasterSchedule($master_id) {
    $pdo = getPDO();
    $stmt = $pdo->prepare("
        SELECT * FROM schedule 
        WHERE master_id = ? 
        ORDER BY work_date DESC, start_time
    ");
    $stmt->execute([$master_id]);
    return $stmt->fetchAll();
}

// Добавить запись в график
function addSchedule($data) {
    $pdo = getPDO();
    $stmt = $pdo->prepare("
        INSERT INTO schedule (master_id, work_date, start_time, end_time)
        VALUES (?, ?, ?, ?)
    ");
    
    return $stmt->execute([
        $data['master_id'],
        $data['work_date'],
        $data['start_time'],
        $data['end_time']
    ]);
}

// Удалить запись из графика
function deleteSchedule($id) {
    $pdo = getPDO();
    $stmt = $pdo->prepare("DELETE FROM schedule WHERE id = ?");
    return $stmt->execute([$id]);
}

// Получить выполненные работы мастера
function getCompletedWorks($master_id) {
    $pdo = getPDO();
    $stmt = $pdo->prepare("
        SELECT * FROM completed_works 
        WHERE master_id = ? 
        ORDER BY work_date DESC
    ");
    $stmt->execute([$master_id]);
    return $stmt->fetchAll();
}

// Добавить выполненную работу
function addCompletedWork($data) {
    $pdo = getPDO();
    $stmt = $pdo->prepare("
        INSERT INTO completed_works (master_id, service_name, car_model, work_date, price)
        VALUES (?, ?, ?, ?, ?)
    ");
    
    return $stmt->execute([
        $data['master_id'],
        $data['service_name'],
        $data['car_model'] ?? '',
        $data['work_date'],
        $data['price']
    ]);
}

// Удалить выполненную работу
function deleteCompletedWork($id) {
    $pdo = getPDO();
    $stmt = $pdo->prepare("DELETE FROM completed_works WHERE id = ?");
    return $stmt->execute([$id]);
}

// Инициализируем базу данных
initDatabase();
?>
