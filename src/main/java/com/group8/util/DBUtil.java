package com.group8.util;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
public class DBUtil {
	// 1) URL points to your database name 
	  private static final String URL  =
	    "jdbc:mysql://localhost:3306/group8project"
	    + "?useSSL=false&allowPublicKeyRetrieval=true";
	  // 2) Change these to your MySQL login
	  private static final String USER = "root";
	  private static final String PASS = "yourMYSQLPASSWORD";

	  static {
	    try {
	      // Load the MySQL JDBC driver
	      Class.forName("com.mysql.cj.jdbc.Driver");
	    } catch (ClassNotFoundException e) {
	      // If the driver isn’t found, print the error
	      e.printStackTrace();
	    }
	  }

	  /**  
	   * Call this from any JSP to get a live Connection:
	   *   Connection conn = DBUtil.getConnection();
	   */
	  public static Connection getConnection() throws SQLException {
	    return DriverManager.getConnection(URL, USER, PASS);
	  }
}
