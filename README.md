🔐 Nginx SSL with Docker (Self-Signed Trusted Certificate)
📌 Project Description

This project demonstrates how to configure Nginx with HTTPS inside a Docker container using a locally trusted SSL certificate.

Instead of using a normal self-signed certificate (which shows browser warnings), we create our own local Certificate Authority (CA) and use it to sign the server certificate. The CA certificate is then added to the browser trust store, making HTTPS appear as secure in the browser.

This simulates how SSL works in real production environments.

🧱 Technologies Used

Nginx

Docker

OpenSSL

Firefox Browser (for trust store demo)

Linux (Ubuntu)

📂 Project Structure
ssl-nginx-demo/
│
├── Dockerfile
├── nginx.conf
├── server.crt
├── server.key
├── myCA.crt
└── README.md

🎯 What This Project Does

Creates a local Certificate Authority (CA)

Generates a server SSL certificate signed by the CA

Configures Nginx to use HTTPS

Runs Nginx inside Docker

Makes browser trust the certificate

Serves the default Nginx page over HTTPS

🔐 Step 1: Create Local Certificate Authority (CA)
openssl req -x509 -new -nodes -days 365 \
-keyout myCA.key -out myCA.crt \
-subj "/CN=MyLocalCA"


This creates:

myCA.key (private key)

myCA.crt (CA certificate)

🔐 Step 2: Create Server Private Key
openssl genrsa -out server.key 2048

🔐 Step 3: Create Server CSR (with SAN)
openssl req -new -key server.key -out server.csr \
-subj "/CN=localhost" \
-addext "subjectAltName=DNS:localhost"

🔐 Step 4: Sign Server Certificate Using CA
openssl x509 -req -in server.csr \
-CA myCA.crt -CAkey myCA.key -CAcreateserial \
-out server.crt -days 365 -sha256 \
-extfile <(printf "subjectAltName=DNS:localhost")


Now you have:

server.crt (server certificate)

server.key (server private key)

myCA.crt (CA certificate)

🌍 Step 5: Trust CA Certificate in Firefox

Open Firefox

Go to Settings → Privacy & Security → Certificates → View Certificates

Open Authorities tab

Click Import

Select myCA.crt

Check Trust this CA to identify websites

Restart Firefox

⚙️ Step 6: Nginx Configuration (nginx.conf)
server {
    listen 443 ssl;
    server_name localhost;

    ssl_certificate /etc/nginx/ssl/server.crt;
    ssl_certificate_key /etc/nginx/ssl/server.key;

    location / {
        root /usr/share/nginx/html;
    }
}

🐳 Step 7: Dockerfile
FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY server.crt /etc/nginx/ssl/server.crt
COPY server.key /etc/nginx/ssl/server.key

▶️ Step 8: Build and Run the Container
docker build -t ssl-nginx .
docker rm -f ssl-nginx
docker run -d -p 8443:443 --name ssl-nginx ssl-nginx

🌐 Step 9: Access the Application

Open browser:

https://localhost:8443


You should see:

Nginx welcome page

Secure 🔒 connection

No certificate warning
