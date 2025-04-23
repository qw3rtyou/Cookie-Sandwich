<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.http.*" %>
<%    
    String searchQuery = request.getParameter("search");
    String showAllCookies = request.getParameter("showAll");

    StringBuilder allCookiesInfo = new StringBuilder();
    
    if ("true".equals(showAllCookies)) {
        allCookiesInfo.append("<div style='background: #f8f8f8; padding: 10px; border: 1px solid #ddd;'>");
        allCookiesInfo.append("<h4>All Cookies (including HttpOnly):</h4>");
        
        Cookie[] allCookies = request.getCookies();

        if (allCookies != null) {
            for (Cookie c : allCookies) {
                System.out.println("name: " + c.getName() + ", value: " + c.getValue() + ", HttpOnly: " + c.isHttpOnly());
            }
        } else {
            System.out.println("no cookie");
        }

        if (allCookies != null) {
            allCookiesInfo.append("Cookies:<br/>");
            for (Cookie c : allCookies) {
                allCookiesInfo.append(String.format(
                    "Name: <b>%s</b><br/>" +
                    "- Value: <b>%s</b><br/>" +
                    "- HttpOnly: <b>%b</b><br/>",
                    c.getName(),
                    c.getValue(),
                    c.isHttpOnly()                    
                ));
            }
        }
        allCookiesInfo.append("</div>");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Vulnerable Search Demo</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .search-box { margin: 20px 0; }
        .result-box { margin: 20px 0; padding: 10px; border: 1px solid #ccc; }
        .cookie-box { margin: 20px 0; padding: 10px; background: #f0f0f0; }
        .debug-box { margin: 20px 0; padding: 10px; background: #e6ffe6; border: 1px solid #99cc99; }
    </style>
</head>
<body>
    <h1>Vulnerable Search Demo</h1>

    <div class="search-box">
        <form method="GET">
            <input type="text" name="search" placeholder="Enter XSS payload..." size="50">
            <input type="submit" value="Execute">
        </form>
    </div>

    <div class="result-box">
        <h3>XSS Output Result:</h3>
        <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
            <div>
                Input value: <%= searchQuery %>
            </div>
        <% } %>
    </div>

    <div class="cookie-box">
        <h3>Cookie Sandwich Test (HttpOnly Cookie Theft)</h3>
        <div id="cookieContent"></div>
        
        <script>
            function createCookieSandwich() {
                document.cookie = "$Version=1; path=/test.jsp;";
                document.cookie = 'param1="start; path=/test.jsp;';
                document.cookie = 'param2=end"; path=/;';
            }   

            function showCookies() {
                document.getElementById('cookieContent').innerHTML = 
                    'Current cookies with JS(HttpOnly X): ' + document.cookie;
            }
        </script>

        <button onclick="createCookieSandwich()">Create Cookie Sandwich</button>
        <button onclick="showCookies()">Show Current Cookies</button>
    </div>

    <div class="debug-box">
        <h3>Debug Tools</h3>
        <form method="GET">
            <input type="hidden" name="showAll" value="true">
            <input type="submit" value="Show All Server-Side Cookies (HttpOnly O)">
        </form>
        <%= allCookiesInfo.toString() %>
    </div>
</body>
</html> 