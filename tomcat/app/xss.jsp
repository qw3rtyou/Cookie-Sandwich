<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String payload = request.getParameter("payload");
    if (payload == null) payload = "";
%>
<html><body>
  <h1>XSS Demo</h1>
  <form>
    <input name="payload" size="60" value="<%= payload %>">
    <input type="submit" value="Run">
  </form>

  <div>
    <%= payload %>
  </div>
</body></html>
