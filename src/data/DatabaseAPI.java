package data;

import java.sql.SQLException;

public abstract class DatabaseAPI {
	static final String url = "jdbc:mysql://localhost:3306/database";
	static final String user = "root";
	static final String password = "";
	
	abstract void addToDatabase()throws SQLException,ClassNotFoundException ;
	abstract void deleteFromDatabase()throws SQLException,ClassNotFoundException ;
}
