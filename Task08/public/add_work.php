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
        'service_name' => trim($_POST['service_name'] ?? ''),
        'car_model' => trim($_POST['car_model'] ?? ''),
        'work_date' => $_POST['work_date'] ?? '',
        'price' => floatval($_POST['price'] ?? 0)
    ];
    
    // Валидация
    if (empty($data['service_name'])) {
        $errors[] = 'Название услуги обязательно';
    }
    if (empty($data['work_date'])) {
        $errors[] = 'Дата работы обязательна';
    }
    if ($data['price'] <= 0) {
        $errors[] = 'Стоимость должна быть больше 0';
    }
    
    if (empty($errors)) {
        if (addCompletedWork($data)) {
            $_SESSION['message'] = 'Работа добавлена';
            header("Location: completed_works.php?master_id=$master_id");
            exit;
        } else {
            $errors[] = 'Ошибка при добавлении работы';
        }
    }
}
?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Добавить работу</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>Добавить работу</h2>
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
                <label class="form-label">Услуга *</label>
                <input type="text" class="form-control" name="service_name" 
                       value="<?= htmlspecialchars($_POST['service_name'] ?? '') ?>" 
                       placeholder="Например: Мойка кузова, Полировка" required>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Модель автомобиля</label>
                <input type="text" class="form-control" name="car_model" 
                       value="<?= htmlspecialchars($_POST['car_model'] ?? '') ?>" 
                       placeholder="Например: Toyota Camry">
            </div>
            
            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">Дата работы *</label>
                    <input type="date" class="form-control" name="work_date" 
                           value="<?= htmlspecialchars($_POST['work_date'] ?? date('Y-m-d')) ?>" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Стоимость (₽) *</label>
                    <input type="number" class="form-control" name="price" 
                           step="0.01" min="0"
                           value="<?= htmlspecialchars($_POST['price'] ?? '') ?>" required>
                </div>
            </div>
            
            <div class="mb-3">
                <button type="submit" class="btn btn-primary">Сохранить</button>
                <a href="completed_works.php?master_id=<?= $master_id ?>" class="btn btn-secondary">Отмена</a>
            </div>
        </form>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<?php require_once '../includes/footer.php'; ?>
