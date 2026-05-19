<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="com.YemekTarifiJSP.VeriTabani"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Yemek Tarifleri - JSP Ana Ekran</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Kayıtlı Yemek Tarifleri (JSP + PostgreSQL)</h2>
            <a href="yonetim.jsp" class="btn btn-primary">Yeni Tarif & CRUD Ekranı</a>
        </div>

        <div class="row">
            <%
                Connection baglanti = null;
                Statement stmt = null;
                ResultSet rs = null;
                try {
                    baglanti = VeriTabani.getBaglanti();
                    String sorgu = "SELECT * FROM Yemekler ORDER BY OlusturmaTarihi DESC";
                    stmt = baglanti.createStatement();
                    rs = stmt.executeQuery(sorgu);

                    while(rs.next()) {
                        String yemekAdi = rs.getString("YemekAdi");
                        String tarifDetay = rs.getString("TarifDetay");
                        String fotoYolu = rs.getString("FotografYolu");
                        
                        if(fotoYolu == null || fotoYolu.trim().isEmpty()) {
                            fotoYolu = "https://via.placeholder.com/300x200?text=Fotoğraf+Yok";
                        }
                        
                        String ozetDetay = tarifDetay.length() > 100 ? tarifDetay.substring(0, 100) + "..." : tarifDetay;
            %>
                        <div class="col-md-4 mb-4">
                            <div class="card h-100 shadow-sm">
                                <img src="<%= fotoYolu %>" class="card-img-top" alt="<%= yemekAdi %>" style="height: 200px; object-fit: cover;" />
                                <div class="card-body">
                                    <h5 class="card-title"><%= yemekAdi %></h5>
                                    <p class="card-text text-muted"><%= ozetDetay %></p>
                                </div>
                                <div class="card-footer bg-transparent border-top-0">
                                    <small class="text-muted">Eklenme: <%= rs.getTimestamp("OlusturmaTarihi") %></small>
                                </div>
                            </div>
                        </div>
            <%
                    }
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger'>Hata oluştu: " + e.getMessage() + "</div>");
                } finally {
                    if(rs != null) rs.close();
                    if(stmt != null) stmt.close();
                    if(baglanti != null) baglanti.close();
                }
            %>
        </div>
    </div>
</body>
</html>