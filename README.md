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
      % docker-compose run --rm exercises 
```
- Follow the directions in the exercise directories


Refresh the exercises
----------------------

If you are using a new Docker container and want to update your exercises, 
then when running the container type:

```
      % refresh-exercises
```


Build the container
--------------------

```
      % git clone --recursesubmodules https://github.com/jsemer/timeloop-accelergy-tutorial.git
      % cd timeloop-accelergy-tutorial
      % make build [BUILD_FLAGS="<Docker build flags, e.g., --no-cache>"]
```
