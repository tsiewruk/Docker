#Installation

1. Create volume
`docker volume create jenkins-volume`
2. Start container
`docker compose up -d jenkins`
3. Check Jenkins temp admin password.
`docker container logs jenkins`
4. Go to website localhost:8080 and configure the service