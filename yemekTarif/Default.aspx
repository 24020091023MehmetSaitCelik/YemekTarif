<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="TarifWeb.Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Yemek Tarifleri - Ana Ekran</title>
    <!-- Tasarımın düzgün durması için hızlıca bir Bootstrap CDN ekleyelim -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">
    <form id="form1" runat="server">
        <div class="container mt-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Kayıtlı Yemek Tarifleri</h2>
                <!-- İkinci ekrana (CRUD/Yeni Tarif) geçiş butonu -->
                <a href="Yonetim.aspx" class="btn btn-primary">Yeni Tarif & CRUD Ekranı</a>
            </div>

            <!-- Yemeklerin Listeleneceği Alan -->
            <div class="row">
                <asp:Repeater ID="rptYemekler" runat="server">
                    <ItemTemplate>
                        <div class="col-md-4 mb-4">
                            <div class="card h-100 shadow-sm">
                                <!-- Fotoğraf varsa göster, yoksa placeholder koy -->
                               <img src='<%# string.IsNullOrEmpty(Eval("FotografYolu") as string) ? "https://via.placeholder.com/300x200?text=Fotoğraf+Yok" : Eval("FotografYolu") %>' class="card-img-top" alt='<%# Eval("YemekAdi") %>' style="height: 200px; object-fit: cover;" />
                                <div class="card-body">
                                    <h5 class="card-title"><%# Eval("YemekAdi") %></h5>
                                    <p class="card-text text-muted">
                                        <%# Eval("TarifDetay").ToString().Length > 100 ? Eval("TarifDetay").ToString().Substring(0, 100) + "..." : Eval("TarifDetay") %>
                                    </p>
                                </div>
                                <div class="card-footer bg-transparent border-top-0">
                                    <small class="text-muted">Eklenme: <%# Convert.ToDateTime(Eval("OlusturmaTarihi")).ToString("dd.MM.yyyy") %></small>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </form>
</body>
</html>