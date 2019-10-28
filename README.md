# Docker container for the Citrix Workspace app

This is a simple container to run the Citrix Workspace app using the firefox browser.

## How to build this docker image
```
docker build -t citrix_workspace_app .
```

## Start the container
```
docker run -d -v /etc/timezone:/etc/timezone:ro -v /etc/localtime:/etc/localtime --name citrix_workspace_app citrix_workspace_app
```

## Connect to the container via ssh and X-Forward
Please set the WEB_URL_TO_LOGIN to your specific login url
```
ssh -f -X receiver@$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' citrix_workspace_app) -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no /usr/bin/firefox <WEB_URL_TO_LOGIN> > /dev/null 2>&1
```


# Sources
[Ubuntu wiki](https://wiki.ubuntuusers.de/Citrix_Receiver_13/)
