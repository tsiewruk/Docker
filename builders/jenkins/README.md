#Installation

1. Create volume
`docker volume create jenkins-volume`
2. Start container
`docker compose up -d jenkins`
1. Check Jenkins temp admin password.
`docker container logs jenkins`
1. Go to website localhost:8080 configure the service