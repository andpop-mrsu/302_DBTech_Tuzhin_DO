<?php
// Простое подключение к БД
function getPDO() {
    static $pdo = null;
    if ($pdo === null) {
        try {
            $pdo = new PDO('sqlite:../data/carwash.db');
            $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $e) {
            die("Ошибка БД: " . $e->getMessage());
        }
    }
    return $pdo;
}
?>
