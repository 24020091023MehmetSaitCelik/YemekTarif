<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="com.YemekTarifiJSP.VeriTabani"%>
<%
    request.setCharacterEncoding("UTF-8");
    String islem = request.getParameter("islem");
    
    String secilenId = "", secilenAd = "", secilenDetay = "", secilenFoto = "";
    Connection baglanti = null;
    
    try {
        baglanti = VeriTabani.getBaglanti();

        if (islem != null) {
            if (islem.equals("kaydet")) {
                String id = request.getParameter("id");
                String ad = request.getParameter("textYemekAdi");
                String detay = request.getParameter("textTarifDetay");
                String foto = request.getParameter("textFotografYolu");
                String malzemeId = request.getParameter("malzemeId");
                String miktar = request.getParameter("miktar");
                String alisveris = request.getParameter("alisveris");

                if (id == null || id.isEmpty()) {
                    String sql = "INSERT INTO Yemekler (YemekAdi, TarifDetay, FotografYolu) VALUES (?, ?, ?)";
                    PreparedStatement ps = baglanti.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                    ps.setString(1, ad);
                    ps.setString(2, detay);
                    ps.setString(3, foto);
                    ps.executeUpdate();
                    
                    ResultSet rsKeys = ps.getGeneratedKeys();
                    int yeniYemekId = 0;
                    if(rsKeys.next()) yeniYemekId = rsKeys.getInt(1);

                    if (malzemeId != null && !malzemeId.equals("0")) {
                        String sqlMalzeme = "INSERT INTO YemekMalzeme (YemekId, MalzemeId, Miktar) VALUES (?, ?, ?)";
                        PreparedStatement psM = baglanti.prepareStatement(sqlMalzeme);
                        psM.setInt(1, yeniYemekId);
                        psM.setInt(2, Integer.parseInt(malzemeId));
                        psM.setString(3, miktar);
                        psM.executeUpdate();
                    }

                    if (alisveris != null && !alisveris.trim().isEmpty()) {
                        String sqlAlis = "INSERT INTO AlisverisListesi (YemekId, Alinacaklar) VALUES (?, ?)";
                        PreparedStatement psA = baglanti.prepareStatement(sqlAlis);
                        psA.setInt(1, yeniYemekId);
                        psA.setString(2, alisveris);
                        psA.executeUpdate();
                    }
                } else {
                    String sql = "UPDATE Yemekler SET YemekAdi=?, TarifDetay=?, FotografYolu=? WHERE YemekId=?";
                    PreparedStatement ps = baglanti.prepareStatement(sql);
                    ps.setString(1, ad);
                    ps.setString(2, detay);
                    ps.setString(3, foto);
                    ps.setInt(4, Integer.parseInt(id));
                    ps.executeUpdate();
                }
                response.sendRedirect("yonetim.jsp");
                return;
            } 
            else if (islem.equals("sil")) {
                int silinecekId = Integer.parseInt(request.getParameter("id"));
                String sql = "DELETE FROM Yemekler WHERE YemekId=?";
                PreparedStatement ps = baglanti.prepareStatement(sql);
                ps.setInt(1, silinecekId);
                ps.executeUpdate();
                response.sendRedirect("yonetim.jsp");
                return;
            } 
            else if (islem.equals("sec")) {
                int aranacakId = Integer.parseInt(request.getParameter("id"));
                String sql = "SELECT * FROM Yemekler WHERE YemekId=?";
                PreparedStatement ps = baglanti.prepareStatement(sql);
                ps.setInt(1, aranacakId);
                ResultSet rsSec = ps.executeQuery();
                if (rsSec.next()) {
                    secilenId = String.valueOf(rsSec.getInt("YemekId"));
                    secilenAd = rsSec.getString("YemekAdi");
                    secilenDetay = rsSec.getString("TarifDetay");
                    secilenFoto = rsSec.getString("FotografYolu");
                }
            }
        }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>JSP Tarif Yönetim & CRUD Paneli</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">
    <div class="container mt-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>JSP Tarif Yönetim Paneli</h2>
            <a href="index.jsp" class="btn btn-secondary">Ana Ekran (Vitrin)</a>
        </div>

        <div class="row">
            <div class="col-md-5">
                <div class="card shadow-sm p-4 mb-4">
                    <h4 class="mb-3 text-primary"><%= secilenId.isEmpty() ? "Yeni Tarif Ekle" : "Tarifi Düzenle" %></h4>
                    <form action="yonetim.jsp?islem=kaydet" method="POST">
                        <input type="hidden" name="id" value="<%= secilenId %>" />

                        <div class="mb-3">
                            <label class="form-label">Yemek Adı</label>
                            <input type="text" name="textYemekAdi" class="form-control" value="<%= secilenAd %>" required />
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Tarif Detay</label>
                            <textarea name="textTarifDetay" class="form-control" rows="4" required><%= secilenDetay %></textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Fotoğraf Yolu / Linki</label>
                            <input type="text" name="textFotografYolu" class="form-control" value="<%= secilenFoto %>" />
                        </div>

                        <% if(secilenId.isEmpty()) { %>
                        <div class="mb-3">
                            <label class="form-label"><strong>Malzeme Seçimi & Miktar</strong></label>
                            <div class="input-group mb-2">
                                <select name="malzemeId" class="form-select">
                                    <option value="0">--- Malzeme Seçin ---</option>
                                    <%
                                        Statement stmtM = baglanti.createStatement();
                                        ResultSet rsM = stmtM.executeQuery("SELECT * FROM Malzemeler");
                                        while(rsM.next()) {
                                            out.println("<option value='"+rsM.getInt("MalzemeId")+"'>"+rsM.getString("MalzemeAdi")+"</option>");
                                        }
                                        rsM.close();
                                        stmtM.close();
                                    %>
                                </select>
                                <input type="text" name="miktar" class="form-control" placeholder="Örn: 2 adet" />
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Alışveriş Listesi Notları</label>
                            <textarea name="alisveris" class="form-control" rows="2" placeholder="Alınacaklar..."></textarea>
                        </div>
                        <% } %>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-success"><%= secilenId.isEmpty() ? "Tarifi Kaydet" : "Değişiklikleri Kaydet" %></button>
                            <% if(!secilenId.isEmpty()) { %><a href="yonetim.jsp" class="btn btn-warning">İptal Et</a><% } %>
                        </div>
                    </form>
                </div>
            </div>

            <div class="col-md-7">
                <div class="card shadow-sm p-4">
                    <h4 class="mb-3 text-success">Tarif Listesi</h4>
                    <table class="table table-striped table-hover border">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Yemek Adı</th>
                                <th>İşlemler</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Statement stmtY = baglanti.createStatement();
                                ResultSet rsY = stmtY.executeQuery("SELECT YemekId, YemekAdi FROM Yemekler ORDER BY YemekId DESC");
                                while(rsY.next()) {
                                    int yId = rsY.getInt("YemekId");
                            %>
                                    <tr class="align-middle">
                                        <td><%= yId %></td>
                                        <td><%= rsY.getString("YemekAdi") %></td>
                                        <td>
                                            <a href="yonetim.jsp?islem=sec&id=<%= yId %>" class="btn btn-sm btn-info text-white">Düzenle</a>
                                            <a href="yonetim.jsp?islem=sil&id=<%= yId %>" class="btn btn-sm btn-danger" onclick="return confirm('Silmek istediğinize emin misiniz?');">Sil</a>
                                        </td>
                                    </tr>
                            <%
                                }
                                rsY.close();
                                stmtY.close();
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
<%
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Hata oluştu: " + e.getMessage() + "</div>");
    } finally {
        if(baglanti != null) baglanti.close();
    }
%>