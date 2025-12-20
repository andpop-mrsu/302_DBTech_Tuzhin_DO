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

// Обработка удаления работы
if (isset($_GET['delete_work'])) {
    $id = intval($_GET['delete_work']);
    if (deleteCompletedWork($id)) {
        $_SESSION['message'] = 'Работа удалена';
        header("Location: completed_works.php?master_id=$master_id");
        exit;
    }
}

// Получаем работы мастера
$works = getCompletedWorks($master_id);
$total = 0;

foreach ($works as $work) {
    $total += $work['price'];
}
?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Выполненные работы</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>Выполненные работы</h2>
        <h3><?= htmlspecialchars($master['last_name']) ?> <?= htmlspecialchars($master['first_name']) ?></h3>
        
        <?php if (isset($_SESSION['message'])): ?>
            <div class="alert alert-info"><?= htmlspecialchars($_SESSION['message']) ?></div>
            <?php unset($_SESSION['message']); ?>
        <?php endif; ?>
        
        <div class="mb-3">
            <a href="add_work.php?master_id=<?= $master_id ?>" class="btn btn-primary">+ Добавить работу</a>
            <a href="index.php" class="btn btn-secondary">Назад к списку</a>
        </div>
        
        <?php if (!empty($works)): ?>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Дата</th>
                        <th>Услуга</th>
                        <th>Автомобиль</th>
                        <th>Стоимость</th>
                        <th>Действия</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($works as $work): ?>
                        <tr>
                            <td><?= $work['work_date'] ?></td>
                            <td><?= htmlspecialchars($work['service_name']) ?></td>
                            <td><?= htmlspecialchars($work['car_model'] ?? 'Не указан') ?></td>
                            <td><?= number_format($work['price'], 2) ?> ₽</td>
                            <td>
                                <a href="completed_works.php?master_id=<?= $master_id ?>&delete_work=<?= $work['id'] ?>" 
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Удалить работу?')">
                                   Удалить
                                </a>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
                <tfoot>
                    <tr class="table-secondary">
                        <td colspan="3" class="text-end"><strong>Итого:</strong></td>
                        <td><strong><?= number_format($total, 2) ?> ₽</strong></td>
                        <td></td>
                    </tr>
                </tfoot>
            </table>
        <?php else: ?>
            <div class="alert alert-info">Нет выполненных работ</div>
        <?php endif; ?>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<?php require_once '../includes/footer.php'; ?>
