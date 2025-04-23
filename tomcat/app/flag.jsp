<%@ page import="javax.servlet.http.*" %>
<%
    String flag = System.getenv("FLAG");
    HttpSession sess = request.getSession(false);
    boolean isAdmin = (sess != null) 
                    && Boolean.TRUE.equals(sess.getAttribute("isAdmin"));

    if (!isAdmin) {
        response.sendError(403, "Forbidden");
        return;
    }
%>
<html><body>
  <h1>GG</h1>
  <pre><%= flag %></pre>
</body></html>
