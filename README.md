## The images are built on Ubuntu version 22.04, which has been enhanced with useful applications.

### Project structure
* **build** -  contains the code for building services (along with local resources needed during the build, e.g. configuration files, entrypoint.sh, etc.).
* **cookbook** - 
  * **instal** - contains software installer scripts (without settings).
  * **set** - contains scripts with software/system settings.
  * **source** - contains scripts that are helpers for set or install scripts/

### How to build an image
`sudo docker compose -f wallabag.yml build --no-cache <service_name>`

### How to enable the image container should be done
`sudo docker compose -f wallabag.yml up <service_name>`

### How to Check Container Status.
`sudo docker compose -f wallabag.yml ps`

### How to connect to a container.
`sudo docker compose -f wallabag.yml exec <service_name> bash`

### How to stop the container.
`sudo docker compose -f wallabag.yml stop <service_name>`

### How to delete a container
`sudo docker compose -f wallabag.yml rm <service_name>`
