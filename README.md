# ufp-scpsshpass
alpine with sshpass and scp installed 

# Description 

With this image you can use scp and sshpass to copy stuff to a remote server or copy stuff from a remote server to your local machine. The password is passed via sshpass so that it can be used by ci tools like bamboo, gitlab, bitbucket cloud, jenkins and so on...


# Docker Hub

* The docker image can be found here 
[frontendsolutions/ufp-scpsshpass](https://hub.docker.com/r/frontendsolutions/ufp-scpsshpass)


# Usage

## Copy a local directory to a remote server by setting some env variables

```
export SSHPASS=__PASSWORD__  # your ssh password
export SSHUSER=__USERNAME__  # your ssh username
export SSHHOST=__HOSTNAME__  # your hostname
export LOCALDIR=$(pwd)       # the directory you want to copy
export REMOTEDIR=__REMOTE_DIR_NAME__       # the remote directory you want to copy files to

docker run --rm -e "SSHPASS=${SSHPASS}" -v "${LOCALDIR}":/upload 'frontendsolutions/ufp-scpsshpass:1' sshpass -e scp -r -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no /upload/ "${SSHUSER}@${SSHHOST}:${REMOTEDIR}"
```

Explanation:

* docker run --rm: 
	* we use docker run to create, run a new docker container and remove it after execution
* -e "SSHPASS=${SSHPASS}"
	* will pass the password to the container so that sshpass will find it
* -v "${LOCALDIR}":/upload
	* mounts the directory you want to upload in the /upload directory in the docker container
* 'frontendsolutions/ufp-scpsshpass:1'
	* uses the correct image
* sshpass -e 
	* calls sshpass which reads the password from the env variable $SSHPASS
* scp -r
	* calls scp in this case with -r for a recursive directory copy
* -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no 
	* does not ask for valid known host to prevent asking for it (if you do not feeld good about it you can also add the host to known hosts before and remove this two params)
* /upload/ 
	* the directory in the docker container where to copy data from
* "${SSHUSER}@${SSHHOST}:${REMOTEDIR}"
	* the connection string

# Example

```
export SSHPASS='mysupersecretpassword'
export SSHUSER='myuser'
export SSHHOST='server.example.com'
export LOCALDIR="$(pwd)"
export REMOTEDIR='/home/myuser/'

docker run --rm -e "SSHPASS=${SSHPASS}" -v "${LOCALDIR}":/upload 'frontendsolutions/ufp-scpsshpass:1' sshpass -e scp -r -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no /upload/ "${SSHUSER}@${SSHHOST}:${REMOTEDIR}"

```
