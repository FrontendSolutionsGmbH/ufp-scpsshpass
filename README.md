# ufp-scpsshpass
alpine with sshpass and scp installed 

# Description 

With this image you can use scp and sshpass to copy stuff to a remote server or copy stuff from a remote server to your local machine. The password is passed via sshpass so that it can be used by ci tools like bamboo, gitlab, bitbucket cloud, jenkins and so on...

# Prerequisite

* Docker needs to be installed
* You need to know the connection settings for your remote host (username, password and so on)

# Docker Hub

* The docker image can be found here 
[frontendsolutions/ufp-scpsshpass](https://hub.docker.com/r/frontendsolutions/ufp-scpsshpass)

# Usage

## Copy a local directory to a remote server by setting some env variables

```
# Change the env variables only and it should work

export SSHPASS=__PASSWORD__  # your ssh password
export SSHUSER=__USERNAME__  # your ssh username
export SSHHOST=__HOSTNAME__  # your hostname
export LOCALDIR=$(pwd)       # the directory you want to copy
export REMOTEDIR=__REMOTE_DIR_NAME__       # the remote directory you want to copy files to

# No need to change the following line

docker run --rm -e "SSHPASS=${SSHPASS}" -v "${LOCALDIR}":/upload 'frontendsolutions/ufp-scpsshpass:1' sshpass -e scp -r -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no /upload/ "${SSHUSER}@${SSHHOST}:${REMOTEDIR}"
```

Explanation:

* docker run --rm: 
	* uses docker to run a docker container and removes it afterwards
* -e "SSHPASS=${SSHPASS}"
	* passes the password to the container so that sshpass will find it
* -v "${LOCALDIR}":/upload
	* mounts the directory you want to upload to the /upload directory in the docker container
* 'frontendsolutions/ufp-scpsshpass:1'
	* uses this docker image
* sshpass -e 
	* calls sshpass in the docker container which reads the password from the env variable $SSHPASS
* scp -r
	* calls scp, in this case with -r for a recursive directory copy
* -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no 
	* prevents asking for a valid known host (if you do not feeld good about it you can also add the host to known hosts before and remove this two params)
* /upload/ 
	* the directory in the docker container where to copy data from
* "${SSHUSER}@${SSHHOST}:${REMOTEDIR}"
	* the connection string to your server based on the env variables

### Example

```
export SSHPASS='mysupersecretpassword'
export SSHUSER='myuser'
export SSHHOST='server.example.com'
export LOCALDIR="$(pwd)"
export REMOTEDIR='/home/myuser/'

docker run --rm -e "SSHPASS=${SSHPASS}" -v "${LOCALDIR}":/upload 'frontendsolutions/ufp-scpsshpass:1' sshpass -e scp -r -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no /upload/ "${SSHUSER}@${SSHHOST}:${REMOTEDIR}"

```
