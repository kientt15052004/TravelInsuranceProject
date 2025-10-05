
package dal;


import java.sql.*;
public class test {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/insuranceSystem";
        String user = "root";
        String pass = "KieN@Pass155";

        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            System.out.println("✅ Kết nối MySQL thành công!");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
