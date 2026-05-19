<?php
include 'db.php';

// SİLME İŞLEMİ
if (isset($_GET['sil'])) {
    $sil_id = intval($_GET['sil']);
    $db->prepare("DELETE FROM tarif_malzeme WHERE tarif_id = ?")->execute([$sil_id]);
    $db->prepare("DELETE FROM tarifler WHERE id = ?")->execute([$sil_id]);
    header("Location: tarif_ekle.php?mesaj=silindi");
    exit;
}

// EKLEME İŞLEMİ
if (isset($_POST['tarif_ekle'])) {
    $ad = $_POST['ad'];
    $aciklama = $_POST['aciklama'];
    $kategori_id = intval($_POST['kategori_id']);
    $sure = intval($_POST['sure']);
    $porsiyon = intval($_POST['porsiyon']);
    $fotograf = $_POST['fotograf'];

    $ekle = $db->prepare("INSERT INTO tarifler (ad, aciklama, fotograf, kategori_id, sure, porsiyon) VALUES (?, ?, ?, ?, ?, ?)");
    $ekle->execute([$ad, $aciklama, $fotograf, $kategori_id, $sure, $porsiyon]);
    
    $yeni_id = $db->lastInsertId();

    if (!empty($_POST['malzemeler'])) {
        foreach ($_POST['malzemeler'] as $m_id) {
            $miktar = $_POST['miktar_' . $m_id];
            $db->prepare("INSERT INTO tarif_malzeme (tarif_id, malzeme_id, miktar) VALUES (?, ?, ?)")->execute([$yeni_id, $m_id, $miktar]);
        }
    }
    header("Location: tarif_ekle.php?mesaj=eklendi");
    exit;
}

$kategoriler = $db->query("SELECT * FROM kategoriler")->fetchAll(PDO::FETCH_ASSOC);
$malzemeler = $db->query("SELECT * FROM malzemeler")->fetchAll(PDO::FETCH_ASSOC);
$tarifler = $db->query("SELECT t.*, k.ad as kategori_adi FROM tarifler t JOIN kategoriler k ON t.kategori_id = k.id ORDER BY t.id DESC")->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Yönetim Paneli</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4">
    <div class="row">
        <div class="col-md-5">
            <div class="card shadow border-0">
                <div class="card-header bg-success text-white"><h5>Yeni Tarif Ekle</h5></div>
                <div class="card-body">
                    <form action="" method="POST">
                        <input type="text" name="ad" class="form-control mb-2" placeholder="Yemek Adı" required>
                        <select name="kategori_id" class="form-select mb-2" required>
                            <?php foreach($kategoriler as $kat): ?>
                                <option value="<?php echo $kat['id']; ?>"><?php echo $kat['ad']; ?></option>
                            <?php endforeach; ?>
                        </select>
                        <div class="row">
                            <div class="col"><input type="number" name="sure" class="form-control mb-2" placeholder="Dk"></div>
                            <div class="col"><input type="number" name="porsiyon" class="form-control mb-2" placeholder="Porsiyon"></div>
                        </div>
                        <input type="text" name="fotograf" class="form-control mb-2" placeholder="Görsel Dosya Adı (kofte.jpg)">
                        <textarea name="aciklama" class="form-control mb-2" placeholder="Tarif Detayı" rows="3"></textarea>
                        
                        <h6>Malzeme Seçimi</h6>
                        <div style="max-height: 150px; overflow-y: auto;" class="border p-2 mb-2">
                            <?php foreach($malzemeler as $m): ?>
                                <div class="d-flex mb-1 align-items-center">
                                    <input type="checkbox" name="malzemeler[]" value="<?php echo $m['id']; ?>" class="me-2">
                                    <small class="flex-grow-1"><?php echo $m['ad']; ?></small>
                                    <input type="text" name="miktar_<?php echo $m['id']; ?>" class="form-control form-control-sm w-25" placeholder="Miktar">
                                </div>
                            <?php endforeach; ?>
                        </div>
                        <button type="submit" name="tarif_ekle" class="btn btn-success w-100">Kaydet</button>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-md-7">
            <div class="card shadow border-0">
                <div class="card-header bg-dark text-white"><h5>Tarif Listesi</h5></div>
                <div class="card-body p-0">
                    <table class="table table-hover mb-0">
                        <thead><tr><th>Yemek</th><th>Kategori</th><th>İşlem</th></tr></thead>
                        <tbody>
                            <?php foreach($tarifler as $t): ?>
                            <tr>
                                <td><?php echo $t['ad']; ?></td>
                                <td><?php echo $t['kategori_adi']; ?></td>
                                <td>
                                    <a href="tarif_detay.php?id=<?php echo $t['id']; ?>" class="btn btn-sm btn-info text-white">Detay</a>
                                    <a href="tarif_ekle.php?sil=<?php echo $t['id']; ?>" class="btn btn-sm btn-danger">Sil</a>
                                </td>
                            </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>