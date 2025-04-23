<%@ page import="javax.servlet.http.*" %>
<%
    HttpSession sess = request.getSession(false);
    Boolean isAdmin = (sess != null) 
                     ? (Boolean)sess.getAttribute("isAdmin") 
                     : false;
    if (!Boolean.TRUE.equals(isAdmin)) {
        response.sendError(403, "Forbidden");
        return;
    }
%>
<html><body>
  <h1>GG</h1>
  <pre>CTF{you_stole_an_HttpOnly_cookie!}</pre>
</body></html>
