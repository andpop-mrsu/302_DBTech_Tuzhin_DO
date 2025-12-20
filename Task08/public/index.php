<?php
session_start();
require_once '../includes/header.php';
require_once '../includes/functions.php';

// Обработка удаления мастера
if (isset($_GET['delete'])) {
    $id = intval($_GET['delete']);
    if (deleteMaster($id)) {
        $_SESSION['message'] = 'Мастер успешно удален';
        header('Location: index.php');
        exit;
    } else {
        $_SESSION['message'] = 'Ошибка при удалении мастера';
    }
}

// Обработка сообщений
$message = '';
if (isset($_SESSION['message'])) {
    $message = $_SESSION['message'];
    unset($_SESSION['message']);
}

// Получаем всех мастеров
$masters = getAllMasters();
?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🚗 Автомойка - Главная</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .master-card { margin-bottom: 20px; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .btn-group { margin-top: 10px; }
    </style>
</head>
<body>
    <div class="container mt-4">
        <h1 class="mb-4">🚗 Автомойка</h1>
        <h2>Список мастеров</h2>
        
        <?php if ($message): ?>
            <div class="alert alert-info"><?= htmlspecialchars($message) ?></div>
        <?php endif; ?>
        
        <p>Найдено мастеров: <?= count($masters) ?></p>
        
        <?php foreach ($masters as $master): ?>
            <div class="master-card">
                <h3><?= htmlspecialchars($master['last_name']) ?> <?= htmlspecialchars($master['first_name']) ?></h3>
                <p>
                    <strong>Должность:</strong> <?= htmlspecialchars($master['position']) ?><br>
                    <strong>Дата приема:</strong> <?= $master['hire_date'] ?><br>
                    <strong>Процент:</strong> <?= $master['salary_percent'] ?>%<br>
                    <strong>Статус:</strong> 
                    <?php if ($master['is_active']): ?>
                        <span class="badge bg-success">Активен</span>
                    <?php else: ?>
                        <span class="badge bg-secondary">Неактивен</span>
                    <?php endif; ?>
                </p>
                
                <div class="btn-group" role="group">
                    <a href="edit_master.php?id=<?= $master['id'] ?>" class="btn btn-warning btn-sm">Редактировать</a>
                    <a href="schedule.php?master_id=<?= $master['id'] ?>" class="btn btn-info btn-sm">График</a>
                    <a href="completed_works.php?master_id=<?= $master['id'] ?>" class="btn btn-secondary btn-sm">Работы</a>
                    <a href="index.php?delete=<?= $master['id'] ?>" 
                       class="btn btn-danger btn-sm"
                       onclick="return confirm('Удалить мастера <?= htmlspecialchars($master['first_name'] . ' ' . $master['last_name']) ?>?')">
                       Удалить
                    </a>
                </div>
            </div>
        <?php endforeach; ?>
        
        <div class="mt-4">
            <a href="add_master.php" class="btn btn-success">+ Добавить мастера</a>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<?php require_once '../includes/footer.php'; ?>
