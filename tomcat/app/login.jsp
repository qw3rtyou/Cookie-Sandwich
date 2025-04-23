<%@ page import="javax.servlet.http.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String user = request.getParameter("username");
    String pass = request.getParameter("password");
    String adminPassword = System.getenv("ADMIN_PASSWORD");

    if (user != null) {
        if ("admin".equals(user) && adminPassword.equals(pass)) {
            HttpSession sess = request.getSession(true);
            sess.setAttribute("isAdmin", true);
            out.println("<p>Login successful. <a href=\"flag.jsp\">Go to flag</a></p>");
        } else {
            out.println("<p>Login failed. <a href=\"login.jsp\">Try again</a></p>");
        }
        return;
    }
%>
<html><body>
  <h1>Login</h1>
  <form method="GET">
    User: <input name="username"><br/>
    Pass: <input name="password" type="password"><br/>
    <input type="submit" value="Login">
  </form>
</body></html>
