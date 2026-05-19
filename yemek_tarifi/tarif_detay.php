<?php
include 'db.php';
$id = intval($_GET['id']);
$tarif = $db->prepare("SELECT t.*, k.ad as kategori_adi FROM tarifler t JOIN kategoriler k ON t.kategori_id = k.id WHERE t.id = ?");
$tarif->execute([$id]);
$detay = $tarif->fetch(PDO::FETCH_ASSOC);

$malzeme_sorgu = $db->prepare("SELECT tm.miktar, m.ad, m.birim FROM tarif_malzeme tm JOIN malzemeler m ON tm.malzeme_id = m.id WHERE tm.tarif_id = ?");
$malzeme_sorgu->execute([$id]);
$malzemeler = $malzeme_sorgu->fetchAll(PDO::FETCH_ASSOC);
?>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title><?php echo $detay['ad']; ?></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="row">
        <div class="col-md-8">
            <div class="card shadow border-0 mb-4">
                <img src="<?php echo $detay['fotograf']; ?>" class="card-img-top" style="max-height: 400px; object-fit: cover;">
                <div class="card-body">
                    <h2 class="fw-bold"><?php echo $detay['ad']; ?></h2>
                    <span class="badge bg-primary mb-3"><?php echo $detay['kategori_adi']; ?></span>
                    <p class="lead"><?php echo nl2br(htmlspecialchars($detay['aciklama'])); ?></p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow border-0 bg-warning text-dark">
                <div class="card-header fw-bold text-center">🛒 Alışveriş Listesi</div>
                <div class="card-body">
                    <ul class="list-group list-group-flush">
                        <?php foreach($malzemeler as $m): ?>
                            <li class="list-group-item bg-transparent border-dark">
                                <strong><?php echo $m['miktar']; ?></strong> <?php echo $m['ad']; ?>
                            </li>
                        <?php endforeach; ?>
                    </ul>
                </div>
            </div>
            <a href="index.php" class="btn btn-secondary w-100 mt-3">Ana Sayfaya Dön</a>
        </div>
    </div>
</div>
</body>
</html>