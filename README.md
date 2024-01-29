## The images are built on Ubuntu version 22.04, which has been enhanced with useful applications.

### Project structure
* **builders** -  contains the code for building services (along with local resources needed during the build, e.g. configuration files, entrypoint.sh, etc.).
* **cookbooks** - 
  * **installers** - contains software installer scripts (without settings).
  * **setters** - contains scripts with software/system settings.
  * **source** - contains scripts that are helpers for set or install scripts/

### How to build an image
`sudo docker compose build --no-cache <service_name>`

### How to enable the image container should be done
`sudo docker compose up <service_name>`

### How to check container status.
`sudo docker compose ps`

### How to connect to a container.
`sudo docker compose exec <service_name> bash`

### How to stop the container.
`sudo docker compose stop <service_name>`

### How to delete a container
`sudo docker compose rm <service_name>`
