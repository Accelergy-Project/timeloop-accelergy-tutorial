Timeloop/Accelergy tutorial
============================

Tools and exercises for the Timeloop/Accelergy tutorial in a Docker container

Run the container
-----------------

- Put the *docker-compose.yaml* file in an otherwise empty directory
- Cd to the directory containing the file
- Edit USER_UID and USER_GID in tht file to the desired owner of your files
- Run the following command:
 - % docker-compose run --rm exercises 
- Follow the directions in the exercise directories

Refresh exercises
------------------

If you are using a new Docker container and want to update the exercises. 
Then when running the container, type:

```
       % refresh-exercises
```


Build the container
--------------------

```
        % make build
```
