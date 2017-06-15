package jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionFactory {
	public Connection getConnection() {
		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException e1) {
			e1.printStackTrace();
		} 
		try {
			return DriverManager.getConnection("jdbc:mysql://localhost/messenger?useSSL=false", "root", "root");
		}catch (SQLException e) {
			/* Relançar SQLException como RuntimeException. 
			 * Fazemos isso para que o código que chamará a fábrica de conexões 
			 * não fique acoplado com a API de JDBC. */
			throw new RuntimeException(e);
		}
	}
}
