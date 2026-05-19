<?php 
include 'db.php'; 
$sorgu = $db->query("SELECT * FROM tarifler ORDER BY id DESC");
$tarifler = $sorgu->fetchAll(PDO::FETCH_ASSOC);
?>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Yemek Tarifleri - Ana Sayfa</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="index.php">🍽️ Yemek Tarifleri</a>
        <div class="navbar-nav ms-auto">
            <a class="nav-link active" href="index.php">Ana Sayfa</a>
            <a class="nav-link" href="tarif_ekle.php">Tarif Yönetimi (CRUD)</a>
        </div>
    </div>
</nav>
<div class="container mt-4">
    <h1 class="mb-4 text-center">Günün Nefis Tarifleri</h1>
    <div class="row">
        <?php foreach($tarifler as $tarif): ?>
            <div class="col-md-4 mb-4">
                <div class="card h-100 shadow-sm border-0">
                <img src="img/<?php echo !empty($tarif['fotograf']) ? $tarif['fotograf'] : 'placeholder.jpg'; ?>" class="card-img-top" style="height: 200px; object-fit: cover;">
                    <div class="card-body text-center">
                        <h5 class="card-title fw-bold"><?php echo htmlspecialchars($tarif['ad']); ?></h5>
                        <p class="text-muted small"><?php echo mb_substr(htmlspecialchars($tarif['aciklama']), 0, 80, 'UTF-8'); ?>...</p>
                        <a href="tarif_detay.php?id=<?php echo $tarif['id']; ?>" class="btn btn-outline-primary btn-sm">Tarifi Gör</a>
                    </div>
                </div>
            </div>
        <?php endforeach; ?>
    </div>
</div>
</body>
</html>