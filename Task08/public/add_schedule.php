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

$errors = [];

// Обработка формы
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = [
        'master_id' => $master_id,
        'work_date' => $_POST['work_date'] ?? '',
        'start_time' => $_POST['start_time'] ?? '',
        'end_time' => $_POST['end_time'] ?? ''
    ];
    
    // Валидация
    if (empty($data['work_date'])) {
        $errors[] = 'Дата обязательна';
    }
    if (empty($data['start_time'])) {
        $errors[] = 'Время начала обязательно';
    }
    if (empty($data['end_time'])) {
        $errors[] = 'Время окончания обязательно';
    }
    
    if (strtotime($data['start_time']) >= strtotime($data['end_time'])) {
        $errors[] = 'Время начала должно быть раньше времени окончания';
    }
    
    if (empty($errors)) {
        if (addSchedule($data)) {
            $_SESSION['message'] = 'Запись добавлена в график';
            header("Location: schedule.php?master_id=$master_id");
            exit;
        } else {
            $errors[] = 'Ошибка при добавлении записи';
        }
    }
}
?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Добавить в график</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>Добавить в график</h2>
        <h4><?= htmlspecialchars($master['last_name']) ?> <?= htmlspecialchars($master['first_name']) ?></h4>
        
        <?php if (!empty($errors)): ?>
            <div class="alert alert-danger">
                <ul>
                    <?php foreach ($errors as $error): ?>
                        <li><?= htmlspecialchars($error) ?></li>
                    <?php endforeach; ?>
                </ul>
            </div>
        <?php endif; ?>
        
        <form method="POST" action="">
            <div class="mb-3">
                <label class="form-label">Дата работы *</label>
                <input type="date" class="form-control" name="work_date" 
                       value="<?= htmlspecialchars($_POST['work_date'] ?? date('Y-m-d')) ?>" required>
            </div>
            
            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">Начало работы *</label>
                    <input type="time" class="form-control" name="start_time" 
                           value="<?= htmlspecialchars($_POST['start_time'] ?? '09:00') ?>" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Окончание работы *</label>
                    <input type="time" class="form-control" name="end_time" 
                           value="<?= htmlspecialchars($_POST['end_time'] ?? '17:00') ?>" required>
                </div>
            </div>
            
            <div class="mb-3">
                <button type="submit" class="btn btn-primary">Сохранить</button>
                <a href="schedule.php?master_id=<?= $master_id ?>" class="btn btn-secondary">Отмена</a>
            </div>
        </form>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<?php require_once '../includes/footer.php'; ?>
