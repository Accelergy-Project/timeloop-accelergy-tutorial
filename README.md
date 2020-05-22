Timeloop/Accelergy tutorial
============================

Tools and exercises for the Timeloop/Accelergy tutorial in a Docker container

Start the container
-----------------

- Put the *docker-compose.yaml* file in an otherwise empty directory
- Cd to the directory containing the file
- Edit USER_UID and USER_GID in the file to the desired owner of your files
- Run the following command:
```
      % docker-compose run --rm tutorial 
```
- Follow the directions in the exercise directories


Refresh the container/exercises
----------------------

To update the Docker container run:

```
     % docker-compose pull
````


Build the container
--------------------

```
      % git clone --recurse-submodules https://github.com/jsemer/timeloop-accelergy-tutorial.git
      % cd timeloop-accelergy-tutorial
      % make build [BUILD_FLAGS="<Docker build flags, e.g., --no-cache>"]
```