<?php
require_once '../includes/header.php';
require_once '../includes/functions.php';

if (!isset($_GET['id'])):
    header('Location: index.php');
    exit;
endif;

$id = intval($_GET['id']);
$master = getMasterById($id);

if (!$master):
    header('Location: index.php');
    exit;
endif;

// Обработка формы
$errors = [];

if ($_SERVER['REQUEST_METHOD'] === 'POST'):
    $data = [
        'first_name' => trim($_POST['first_name'] ?? ''),
        'last_name' => trim($_POST['last_name'] ?? ''),
        'position' => trim($_POST['position'] ?? ''),
        'hire_date' => $_POST['hire_date'] ?? '',
        'salary_percent' => floatval($_POST['salary_percent'] ?? 0),
        'is_active' => isset($_POST['is_active']) ? 1 : 0
    ];
    
    // Валидация
    if (empty($data['first_name'])) $errors[] = 'Имя обязательно';
    if (empty($data['last_name'])) $errors[] = 'Фамилия обязательна';
    
    if (empty($errors)):
        if (updateMaster($id, $data)):
            $_SESSION['messages'][] = [
                'text' => 'Данные мастера обновлены',
                'type' => 'success'
            ];
            header('Location: index.php');
            exit;
        else:
            $errors[] = 'Ошибка при обновлении данных';
        endif;
    endif;
endif;
?>

<div class="row justify-content-center">
    <div class="col-md-8 col-lg-6">
        <div class="card">
            <div class="card-header bg-warning">
                <h4 class="mb-0">
                    <i class="bi bi-pencil me-2"></i>
                    Редактировать мастера
                </h4>
            </div>
            <div class="card-body">
                <?php if (!empty($errors)): ?>
                    <div class="alert alert-danger">
                        <ul class="mb-0">
                            <?php foreach ($errors as $error): ?>
                                <li><?= htmlspecialchars($error) ?></li>
                            <?php endforeach; ?>
                        </ul>
                    </div>
                <?php endif; ?>
                
                <form method="POST" action="">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Фамилия *</label>
                            <input type="text" class="form-control" name="last_name" 
                                   value="<?= htmlspecialchars($master['last_name']) ?>" 
                                   required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Имя *</label>
                            <input type="text" class="form-control" name="first_name" 
                                   value="<?= htmlspecialchars($master['first_name']) ?>"
                                   required>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Должность</label>
                        <select class="form-select" name="position">
                            <option value="Мастер" <?= $master['position'] === 'Мастер' ? 'selected' : '' ?>>Мастер</option>
                            <option value="Старший мастер" <?= $master['position'] === 'Старший мастер' ? 'selected' : '' ?>>Старший мастер</option>
                            <option value="Менеджер" <?= $master['position'] === 'Менеджер' ? 'selected' : '' ?>>Менеджер</option>
                            <option value="Специалист" <?= $master['position'] === 'Специалист' ? 'selected' : '' ?>>Специалист</option>
                        </select>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Дата найма *</label>
                            <input type="date" class="form-control" name="hire_date" 
                                   value="<?= $master['hire_date'] ?>" 
                                   required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Процент от выручки *</label>
                            <input type="number" class="form-control" name="salary_percent" 
                                   step="0.01" min="0" max="100"
                                   value="<?= $master['salary_percent'] ?>"
                                   required>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <div class="form-check">
                            <input type="checkbox" class="form-check-input" name="is_active" 
                                   id="is_active" <?= $master['is_active'] ? 'checked' : '' ?>>
                            <label class="form-check-label" for="is_active">
                                Активный сотрудник
                            </label>
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-between">
                        <a href="index.php" class="btn btn-secondary">
                            <i class="bi bi-arrow-left me-1"></i>Назад
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-save me-1"></i>Сохранить изменения
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<?php require_once '../includes/footer.php'; ?>
