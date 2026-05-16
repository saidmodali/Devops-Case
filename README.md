# DevOps Case Study

Bu repository, iki farklı proje türünün deploy edilmesini gösteren bir DevOps case study çalışmasıdır:

1. MERN Stack application
2. Python ETL project

MERN application; React frontend, Express.js backend ve MongoDB database yapısından oluşmaktadır.  
Python project tarafında ise `ETL.py` dosyası bulunmaktadır ve bu script Kubernetes CronJob kullanılarak her saat çalışacak şekilde zamanlanmıştır.

---

## 1. Project Overview

Bu projenin amacı; containerization, orchestration, CI/CD, infrastructure as code ve deployment süreçlerini uygulamalı olarak göstermektir.

Bu proje kapsamında aşağıdaki yapılar hazırlanmıştır:

- Frontend, backend ve Python ETL için Dockerfile dosyaları
- Local containerized deployment için Docker Compose configuration
- Orchestration için Kubernetes manifests
- Python ETL scriptinin zamanlanması için Kubernetes CronJob
- Karşılaşılan zorluklar ve çözümleri
- CI/CD validation için GitHub Actions workflow
- AWS infrastructure provisioning için Terraform dosyaları
- Çalışan sistemi gösteren screenshots

---

## 2. Architecture

MERN application architecture aşağıdaki gibidir:

```text
User Browser
    |
    v
React Frontend
    |
    v
Express.js Backend API
    |
    v
MongoDB Database
```

Python ETL architecture ise aşağıdaki gibidir:

```text
Kubernetes CronJob
    |
    v
ETL.py
    |
    v
GitHub API
```

---

## 3. Technologies Used

Bu projede kullanılan temel teknolojiler:

- React
- Node.js
- Express.js
- MongoDB
- Python
- Docker
- Docker Compose
- Kubernetes
- Kubernetes CronJob
- GitHub Actions
- Terraform
- AWS EC2



## 4. Project Structure

```text
DevOps Case/
├── .github/
│   └── workflows/
│       └── ci-cd.yml
│
├── k8s/
│   ├── namespace.yaml
│   ├── mongo.yaml
│   ├── backend.yaml
│   ├── frontend.yaml
│   └── python-cronjob.yaml
│
├── mern-project/
│   ├── client/
│   │   ├── Dockerfile
│   │   └── ...
│   └── server/
│       ├── Dockerfile
│       └── ...
│
├── python-project/
│   ├── Dockerfile
│   ├── ETL.py
│   └── requirements.txt
│
├── screenshots/
├── terraform/
│   ├── provider.tf
│   ├── variables.tf
│   ├── main.tf
│   └── outputs.tf
│
├── docker-compose.yml
└── README.md
```

---

## 5. Local Development

### Backend

Backend’i local ortamda çalıştırmak için:

```bash
cd mern-project/server
npm install
npm start
```

Backend aşağıdaki port üzerinde çalışır:

```text
http://localhost:5050
```

Healthcheck endpoint:

```text
http://localhost:5050/healthcheck
```

### Frontend

Frontend’i local ortamda çalıştırmak için:

```bash
cd mern-project/client
npm install
npm start
```

Frontend aşağıdaki port üzerinde çalışır:

```text
http://localhost:3000
```

### MongoDB

MongoDB local ortamda Docker ile çalıştırılabilir:

```bash
docker run -d --name devops-mongo -p 27017:27017 mongo:7
```

MongoDB bağlantı adresi:

```text
mongodb://localhost:27017
```

---

## 6. Docker Deployment

Her component için ayrı bir Dockerfile hazırlanmıştır.

### Backend Docker Build

```bash
docker build -t devops-backend:local ./mern-project/server
```

### Frontend Docker Build

```bash
docker build -t devops-frontend:local --build-arg REACT_APP_API_URL=http://localhost:5050 ./mern-project/client
```

### Python ETL Docker Build

```bash
docker build -t devops-etl:local ./python-project
```

### Python ETL Docker Test

```bash
docker run --rm devops-etl:local
```

Beklenen çıktı:

```text
<Response [200]>
```

Bu çıktı, Python ETL container’ının GitHub API’ye başarılı şekilde erişebildiğini gösterir.

---

## 7. Docker Compose Deployment

Docker Compose, MERN stack yapısını tek komutla local containerized ortamda çalıştırmak için kullanılmıştır.

```bash
docker compose up --build
```

Docker Compose setup içinde aşağıdaki servisler bulunmaktadır:

- React frontend
- Express.js backend
- MongoDB database

Frontend URL:

```text
http://localhost:3000
```

Backend URL:

```text
http://localhost:5050
```

Docker Compose içinde MongoDB bağlantısı:

```text
mongodb://mongodb:27017
```

Docker Compose environment’ı durdurmak için:

```bash
docker compose down
```

---

## 8. Kubernetes Deployment

Kubernetes manifest dosyaları `k8s/` klasörü altında bulunmaktadır.

### Kubernetes Resources Apply

```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/mongo.yaml
kubectl apply -f k8s/backend.yaml
kubectl apply -f k8s/frontend.yaml
kubectl apply -f k8s/python-cronjob.yaml
```

### Kubernetes Pods Kontrolü

```bash
kubectl get pods -n devops-case
```

Beklenen sonuç:

```text
backend    Running
frontend   Running
mongodb    Running
```

### Kubernetes Services Kontrolü

```bash
kubectl get svc -n devops-case
```

Beklenen services:

```text
backend    NodePort
frontend   NodePort
mongodb    ClusterIP
```

### Local Kubernetes Port Forwarding

Frontend için:

```bash
kubectl port-forward svc/frontend 8080:80 -n devops-case
```

Backend için:

```bash
kubectl port-forward svc/backend 30050:5050 -n devops-case
```

Port forwarding sonrası frontend aşağıdaki adresten erişilebilir:

```text
http://localhost:8080
```

Backend healthcheck:

```text
http://localhost:30050/healthcheck
```

---

## 9. Python ETL CronJob

Python ETL scripti Kubernetes CronJob kullanılarak zamanlanmıştır.

CronJob dosyası:

```text
k8s/python-cronjob.yaml
```

Cron schedule:

```text
0 * * * *
```

Bu ifade, ETL job’unun her saatin başında çalışacağını gösterir.

### CronJob Kontrolü

```bash
kubectl get cronjob etl-cronjob -n devops-case
```

### CronJob Detaylarını Görüntüleme

```bash
kubectl describe cronjob etl-cronjob -n devops-case
```

### ETL Job Logs Kontrolü

Önce job adı görüntülenir:

```bash
kubectl get jobs -n devops-case
```

Sonra ilgili job logları alınır:

```bash
kubectl logs job/<job-name> -n devops-case
```

Başarılı çıktı örneği:

```text
<Response [200]>
```

Bu çıktı, `ETL.py` dosyasının başarılı şekilde çalıştığını ve GitHub API’ye eriştiğini gösterir.

---

## 10. CI/CD Pipeline

CI/CD validation için GitHub Actions kullanılmıştır.

Workflow dosyası:

```text
.github/workflows/ci-cd.yml
```

Pipeline, push ve pull request event’leri ile çalışır.

Workflow aşağıdaki adımları gerçekleştirir:

1. Repository checkout işlemi
2. Backend Docker image build
3. Frontend Docker image build
4. Python ETL Docker image build
5. Docker images listesini görüntüleme

Bu işlem, tüm project components için Docker image build işlemlerinin başarılı şekilde yapılabildiğini doğrular.

---

## 11. AWS Infrastructure with Terraform

Terraform dosyaları `terraform/` klasörü altında bulunmaktadır.

Terraform configuration ile aşağıdaki AWS kaynakları hazırlanmıştır:

- AWS EC2 instance
- Security group
- SSH access
- HTTP access
- Kubernetes NodePort access
- 25 GB root disk

### Terraform Commands

```bash
cd terraform
terraform init
terraform validate
terraform plan
terraform apply
```

Terraform outputs:

- EC2 public IP
- Frontend URL
- Backend healthcheck URL
- SSH command

---

## 12. AWS Deployment

MERN application ve Python ETL CronJob AWS EC2 üzerinde deploy edilmiştir.

AWS tarafında kullanılan yapı:

```text
AWS EC2 Ubuntu Server
    |
    v
Docker
    |
    v
k3s Kubernetes
    |
    v
Frontend + Backend + MongoDB + ETL CronJob
```

AWS üzerinde Docker image’ları build edilmiştir:

```bash
docker build -t devops-backend:aws ./mern-project/server
docker build -t devops-frontend:aws --build-arg REACT_APP_API_URL=http://<EC2_PUBLIC_IP>:30050 ./mern-project/client
docker build -t devops-etl:aws ./python-project
```

k3s, containerd kullandığı için Docker image’ları k3s image store içine import edilmiştir:

```bash
docker save devops-backend:aws | sudo k3s ctr images import -
docker save devops-frontend:aws | sudo k3s ctr images import -
docker save devops-etl:aws | sudo k3s ctr images import -
```

AWS üzerinde Kubernetes resources apply edilmiştir:

```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/mongo.yaml
kubectl apply -f k8s/backend.yaml
kubectl apply -f k8s/frontend.yaml
kubectl apply -f k8s/python-cronjob.yaml
```

AWS deployment sonrası servisler aşağıdaki şekilde test edilmiştir:

```text
Frontend:
http://<EC2_PUBLIC_IP>:30080

Backend healthcheck:
http://<EC2_PUBLIC_IP>:30050/healthcheck
```

---


## 13. Screenshots

Screenshots dosyaları projeye eklenmiştir.

Aşağıdaki screenshots, projenin başarılı şekilde çalıştığını ve deploy edildiğini göstermektedir:

1. `1.png` - Local React frontend API Status OK ekranı
2. `2.png` - Docker Desktop üzerinde Docker Compose containerlarının çalışması
3. `3.png` - `docker ps` çıktısı: frontend, backend ve MongoDB containerları running
4. `4.png` - Terraform init ve terraform validate başarılı çıktısı
5. `5.png` - AWS Kubernetes servisleri: backend, frontend ve MongoDB servisleri
6. `6.png` - AWS public frontend URL üzerinde API Status OK ekranı
7. `7.png` - AWS public backend healthcheck endpoint çıktısı
8. `8.png` - AWS Kubernetes podları: backend, frontend ve MongoDB Running
9. `9.png` - GitHub Actions CI/CD workflow başarılı yeşil tik ekranı
10. `10.png` - Kubernetes ETL CronJob manuel job log çıktısı: Response 200
11. `11.png` - Kubernetes CronJob schedule çıktısı: `0 * * * *`
12. `12.png` - AWS EC2 instance running ekranı ve public IP bilgisi
13. `13.png` - AWS EC2 volume bilgisi: 25 GiB gp3 volume

---



## 14. Challenges and Solutions

### Challenge 1: Frontend içinde hardcoded localhost kullanımı

İlk durumda frontend kodlarında backend API adresi hardcoded olarak kullanılıyordu:

```text
http://localhost:5050
```

Bu yapı local development için çalışsa da Docker, Kubernetes ve AWS deployment ortamlarında uygun değildir. Çünkü her ortamda backend adresi farklı olabilir.

Solution:

Frontend API çağrıları `REACT_APP_API_URL` environment variable kullanacak şekilde düzenlendi.

```text
REACT_APP_API_URL
```

Bu sayede frontend build edilirken backend API adresi dışarıdan verilebilir hale getirildi.

Örnek:

```bash
docker build -t devops-frontend:aws --build-arg REACT_APP_API_URL=http://<EC2_PUBLIC_IP>:30050 ./mern-project/client
```

---

### Challenge 2: Kubernetes image problemi

Local Docker üzerinde image’lar başarılı şekilde build edilmesine rağmen Kubernetes pod’ları ilk aşamada şu hatayı verdi:

```text
ErrImageNeverPull
```

Bu sorun özellikle k3s ortamında yaşandı. Çünkü k3s, Docker image listesini doğrudan kullanmak yerine containerd image store kullanmaktadır. Bu nedenle `docker images` içinde görünen image’lar Kubernetes tarafından doğrudan görülemedi.

Solution:

Docker image’ları `docker save` komutu ile export edilip `sudo k3s ctr images import -` komutu ile k3s/containerd image store içine import edildi.

```bash
docker save devops-backend:aws | sudo k3s ctr images import -
docker save devops-frontend:aws | sudo k3s ctr images import -
docker save devops-etl:aws | sudo k3s ctr images import -
```

Ayrıca Kubernetes manifest dosyalarında imagePullPolicy şu şekilde ayarlandı:

```text
imagePullPolicy: Never
```

Bu sayede Kubernetes image’ları internetten çekmeye çalışmadı ve local/import edilmiş image’ları kullandı.

---

### Challenge 3: Frontend Service eksikliği

AWS deployment sırasında frontend pod’u Running durumundaydı; ancak frontend dışarıdan erişilebilir değildi. Yapılan kontrolde `frontend.yaml` dosyasında yalnızca Deployment kısmının bulunduğu, Service kısmının eksik olduğu görüldü.

Bu durumda pod çalışmasına rağmen aşağıdaki komutta frontend servisi görünmedi:

```bash
kubectl get svc -n devops-case
```

Solution:

`frontend.yaml` dosyasına NodePort tipinde bir Kubernetes Service eklendi.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: frontend
  namespace: devops-case
spec:
  type: NodePort
  selector:
    app: frontend
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30080
```

Bu düzenleme sonrası frontend servisi oluştu ve uygulamaya aşağıdaki adres üzerinden erişildi:

```text
http://<EC2_PUBLIC_IP>:30080
```

---

## 15. Acceptance Criteria

### MERN Application

- MongoDB connection başarılı şekilde çalışmaktadır.
- Backend endpoints çalışmaktadır.
- Frontend pages çalışmaktadır.
- Create Record işlemi çalışmaktadır.
- Record List üzerinde kayıtlar görüntülenmektedir.

### Python Project

- `ETL.py` başarılı şekilde çalışmaktadır.
- `ETL.py`, Kubernetes CronJob ile her saat çalışacak şekilde zamanlanmıştır.
- CronJob testlerinde GitHub API’den `<Response [200]>` cevabı alınmıştır.

---

## 16. Conclusion

Bu proje, MERN Stack application ve Python ETL project için uçtan uca bir DevOps workflow göstermektedir.

Çözüm kapsamında aşağıdaki süreçler uygulanmıştır:

- Docker ile containerization
- Docker Compose ile local multi-container deployment
- Kubernetes ile orchestration
- Kubernetes CronJob ile scheduled execution
- GitHub Actions ile CI/CD validation
- Terraform ile AWS infrastructure preparation
- AWS EC2 üzerinde Docker + k3s Kubernetes deployment