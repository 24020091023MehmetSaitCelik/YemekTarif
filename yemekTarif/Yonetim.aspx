<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Yonetim.aspx.cs" Inherits="TarifWeb.Yonetim" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Tarif Yönetim & CRUD Paneli</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">
    <form id="form1" runat="server">
        <div class="container mt-4 mb-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Tarif Yönetim & CRUD Paneli</h2>
                <a href="Default.aspx" class="btn btn-secondary">Ana Ekran (Vitrin)</a>
            </div>

            <div class="row">
                <!-- SOL SÜTUN: Yeni Tarif Giriş Formu (Ekleme / Güncelleme) -->
                <div class="col-md-5">
                    <div class="card shadow-sm p-4 mb-4">
                        <h4 class="mb-3 text-primary">Tarif Bilgileri</h4>
                        
                        <!-- Güncelleme işlemi için gizli ID tutucu -->
                        <asp:HiddenField ID="hfYemekId" runat="server" />

                        <div class="mb-3">
                            <label class="form-label">Yemek Adı</label>
                            <asp:TextBox ID="txtYemekAdi" runat="server" CssClass="form-control" placeholder="Örn: Karnıyarık"></asp:TextBox>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Tarif Detay (Nasıl Yapılır?)</label>
                            <asp:TextBox ID="txtTarifDetay" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" placeholder="Yemeğin yapılış adımları..."></asp:TextBox>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Fotoğraf Yolu / Linki</label>
                            <asp:TextBox ID="txtFotograf" runat="server" CssClass="form-control" placeholder="images/karniyarik.jpg veya URL"></asp:TextBox>
                        </div>

                        <!-- Ödev İsteyi: Malzeme Seçme Alanı -->
                        <div class="mb-3">
                            <label class="form-label"><strong>Malzeme Seçimi & Miktar</strong></label>
                            <div class="input-group mb-2">
                                <asp:DropDownList ID="ddlMalzemeler" runat="server" CssClass="form-select"></asp:DropDownList>
                                <asp:TextBox ID="txtMiktar" runat="server" CssClass="form-control" placeholder="Örn: 2 adet, 100gr"></asp:TextBox>
                            </div>
                            <small class="text-muted text-block">Çoka çok ilişki için veri tabanındaki malzemeler listelenir.</small>
                        </div>

                        <!-- Ödev İsteyi: Alışveriş Listesi Alanı -->
                        <div class="mb-3">
                            <label class="form-label">Alışveriş Listesi Notları</label>
                            <asp:TextBox ID="txtAlisveris" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control" placeholder="Bu tarif için alınması gereken ekstra şeyler..."></asp:TextBox>
                        </div>

                        <div class="d-grid gap-2">
                            <asp:Button ID="btnKaydet" runat="server" Text="Tarifi Kaydet" CssClass="btn btn-success" OnClick="btnKaydet_Click" />
                            <asp:Button ID="btnTemizle" runat="server" Text="Formu Temizle" CssClass="btn btn-warning" OnClick="btnTemizle_Click" Visible="false" />
                        </div>
                    </div>
                </div>

                <!-- SAĞ SÜTUN: Tarif Listesi (CRUD - Okuma, Silme, Seçme) -->
                <div class="col-md-7">
                    <div class="card shadow-sm p-4">
                        <h4 class="mb-3 text-success">Tarif Listesi (Kayıtlı Veriler)</h4>
                        
                        <asp:GridView ID="gvYemekler" runat="server" AutoGenerateColumns="False" 
                                      CssClass="table table-striped table-hover border align-middle"
                                      DataKeyNames="YemekId" OnRowCommand="gvYemekler_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="YemekId" HeaderText="ID" ItemStyle-Width="50px" />
                                <asp:BoundField DataField="YemekAdi" HeaderText="Yemek Adı" />
                                
                                <asp:TemplateField HeaderText="İşlemler" ItemStyle-Width="180px">
                                    <ItemTemplate>
                                        <!-- Güncellemek için Seç Butonu -->
                                        <asp:LinkButton ID="btnSec" runat="server" CommandName="Sec" 
                                                        CommandArgument='<%# Eval("YemekId") %>' 
                                                        CssClass="btn btn-sm btn-info text-white me-1">Düzenle</asp:LinkButton>
                                        
                                        <!-- Silme Butonu -->
                                        <asp:LinkButton ID="btnSil" runat="server" CommandName="Sil" 
                                                        CommandArgument='<%# Eval("YemekId") %>' 
                                                        CssClass="btn btn-sm btn-danger"
                                                        OnClientClick="return confirm('Bu tarifi silmek istediğinize emin misiniz?');">Sil</asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>