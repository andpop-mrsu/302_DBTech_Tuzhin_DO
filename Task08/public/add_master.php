<?php
session_start();
require_once '../includes/header.php';
require_once '../includes/functions.php';

$errors = [];
$success = false;

// Обработка формы
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = [
        'first_name' => trim($_POST['first_name'] ?? ''),
        'last_name' => trim($_POST['last_name'] ?? ''),
        'position' => $_POST['position'] ?? 'Мастер',
        'hire_date' => $_POST['hire_date'] ?? date('Y-m-d'),
        'salary_percent' => floatval($_POST['salary_percent'] ?? 30.00),
        'is_active' => isset($_POST['is_active']) ? 1 : 0
    ];
    
    // Валидация
    if (empty($data['first_name'])) {
        $errors[] = 'Имя обязательно';
    }
    if (empty($data['last_name'])) {
        $errors[] = 'Фамилия обязательна';
    }
    if ($data['salary_percent'] <= 0 || $data['salary_percent'] > 100) {
        $errors[] = 'Процент должен быть от 1 до 100';
    }
    
    // Если нет ошибок - добавляем
    if (empty($errors)) {
        if (addMaster($data)) {
            $_SESSION['message'] = 'Мастер успешно добавлен';
            header('Location: index.php');
            exit;
        } else {
            $errors[] = 'Ошибка при добавлении мастера';
        }
    }
}
?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Добавить мастера</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>Добавить мастера</h2>
        
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
                <label class="form-label">Имя *</label>
                <input type="text" class="form-control" name="first_name" 
                       value="<?= htmlspecialchars($_POST['first_name'] ?? '') ?>" required>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Фамилия *</label>
                <input type="text" class="form-control" name="last_name" 
                       value="<?= htmlspecialchars($_POST['last_name'] ?? '') ?>" required>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Должность</label>
                <select class="form-select" name="position">
                    <option value="Мастер" <?= ($_POST['position'] ?? '') == 'Мастер' ? 'selected' : '' ?>>Мастер</option>
                    <option value="Старший мастер" <?= ($_POST['position'] ?? '') == 'Старший мастер' ? 'selected' : '' ?>>Старший мастер</option>
                    <option value="Менеджер" <?= ($_POST['position'] ?? '') == 'Менеджер' ? 'selected' : '' ?>>Менеджер</option>
                </select>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Дата приема *</label>
                <input type="date" class="form-control" name="hire_date" 
                       value="<?= htmlspecialchars($_POST['hire_date'] ?? date('Y-m-d')) ?>" required>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Процент от выручки *</label>
                <input type="number" class="form-control" name="salary_percent" 
                       step="0.01" min="1" max="100"
                       value="<?= htmlspecialchars($_POST['salary_percent'] ?? 30.00) ?>" required>
            </div>
            
            <div class="mb-3">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" name="is_active" id="is_active" 
                           value="1" <?= isset($_POST['is_active']) ? 'checked' : 'checked' ?>>
                    <label class="form-check-label" for="is_active">
                        Активный сотрудник
                    </label>
                </div>
            </div>
            
            <div class="mb-3">
                <button type="submit" class="btn btn-primary">Сохранить</button>
                <a href="index.php" class="btn btn-secondary">Отмена</a>
            </div>
        </form>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<?php require_once '../includes/footer.php'; ?>
