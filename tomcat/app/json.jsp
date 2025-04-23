<%@ page contentType="application/json;charset=UTF-8" %>
<%
    String leaked = "";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if (!"JSESSIONID".equals(c.getName())) {
                leaked = c.getValue();
                break;
            }
        }
    }
    leaked = leaked.replace("\"","\\\"");
    out.print("{\"session\":\"" + leaked + "\"}");
%>
