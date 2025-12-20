<?php
session_start();
require_once '../includes/header.php';
require_once '../includes/functions.php';

if (!isset($_GET['master_id'])) {
    header('Location: index.php');
    exit;
}

$master_id = intval($_GET['master_id']);
$master = getMasterById($master_id);

if (!$master) {
    header('Location: index.php');
    exit;
}

// Обработка удаления записи графика
if (isset($_GET['delete_schedule'])) {
    $id = intval($_GET['delete_schedule']);
    if (deleteSchedule($id)) {
        $_SESSION['message'] = 'Запись графика удалена';
        header("Location: schedule.php?master_id=$master_id");
        exit;
    }
}

// Получаем график мастера
$schedule = getMasterSchedule($master_id);
?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>График работы</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>График работы</h2>
        <h3><?= htmlspecialchars($master['last_name']) ?> <?= htmlspecialchars($master['first_name']) ?></h3>
        
        <?php if (isset($_SESSION['message'])): ?>
            <div class="alert alert-info"><?= htmlspecialchars($_SESSION['message']) ?></div>
            <?php unset($_SESSION['message']); ?>
        <?php endif; ?>
        
        <div class="mb-3">
            <a href="add_schedule.php?master_id=<?= $master_id ?>" class="btn btn-primary">+ Добавить в график</a>
            <a href="index.php" class="btn btn-secondary">Назад к списку</a>
        </div>
        
        <?php if (!empty($schedule)): ?>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Дата</th>
                        <th>Начало</th>
                        <th>Окончание</th>
                        <th>Длительность</th>
                        <th>Действия</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($schedule as $item): 
                        $start = strtotime($item['start_time']);
                        $end = strtotime($item['end_time']);
                        $hours = floor(($end - $start) / 3600);
                    ?>
                        <tr>
                            <td><?= $item['work_date'] ?></td>
                            <td><?= substr($item['start_time'], 0, 5) ?></td>
                            <td><?= substr($item['end_time'], 0, 5) ?></td>
                            <td><?= $hours ?> ч</td>
                            <td>
                                <a href="schedule.php?master_id=<?= $master_id ?>&delete_schedule=<?= $item['id'] ?>" 
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Удалить запись графика?')">
                                   Удалить
                                </a>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        <?php else: ?>
            <div class="alert alert-info">Нет записей в графике</div>
        <?php endif; ?>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<?php require_once '../includes/footer.php'; ?>
