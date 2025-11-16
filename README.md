# Github Actions demo for a simple Node.js app

#### Docker
```
docker build -t gd-cicd .
```

```
docker run -d -p 3000:8080 --name gd-cicd gd-cicd:latest
```