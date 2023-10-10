## This is the docker container for utilizing espionox's long term memory
Commands you need: 
* `docker build -t docker_image .` - Builds docker image
* `docker run -p 6987:6987 docker_image` - gets the server running. If you want to reset the server, add `-e RESET_DB=true`
