import os
from flask import Flask, request, jsonify
from selenium import webdriver
from selenium.webdriver.common.by import By
from urllib.parse import quote

app = Flask(__name__)

ADMIN_PASSWORD = os.environ.get("ADMIN_PASSWORD")
if not ADMIN_PASSWORD:
    raise RuntimeError("ADMIN_PASSWORD environment variable is not set")



@app.route("/bot", methods=["GET"])
def bot():
    chrome_options = webdriver.ChromeOptions()
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--headless')
    chrome_options.add_argument('--disable-gpu')
    chrome_options.add_argument('--disable-dev-shm-usage')
    chrome_options.add_argument("--window-size=1920,1080")
    driver = webdriver.Chrome(options=chrome_options)
    
    payload = request.args.get("payload", "")

    login_url = f"http://tomcat:8080/login.jsp?username=admin&password={ADMIN_PASSWORD}"
    driver.get(login_url)

    # print(driver.get_cookies())

    encoded = quote(payload, safe='')
    xss_url = f"http://tomcat:8080/xss.jsp?payload={encoded}"
    driver.get(xss_url)
    
    # print(driver.get_cookies())

    ok = driver.current_url.startswith("http://tomcat:8080/xss.jsp")
    status = 200 if ok else 500

    driver.quit()
    return jsonify({"status_code": status}), status

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
