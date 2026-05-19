package com.YemekTarifiJSP;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class VeriTabani {
    private static final String URL = "jdbc:postgresql://localhost:5432/TarifDB";
    private static final String USER = "postgres"; // Kendi PostgreSQL kullanıcı adın
    private static final String PASSWORD = "sait"; // Kendi PostgreSQL şifren

    public static Connection getBaglanti() throws SQLException, ClassNotFoundException {
        // PostgreSQL sürücüsünü yüklüyoruz
        Class.forName("org.postgresql.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}