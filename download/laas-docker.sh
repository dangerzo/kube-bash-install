#!/bin/bash

URLFILE=./url_list
UPLOAD_HAROBR_URL="cube-regi-ent.acloud.run"

URL=( $( cat $URLFILE ) )
URL_LENGTH=${#URL[@]}

DOWN_VERSION=`echo "${URL[0]}" | awk -F '[/:]' '{print $3}'`

### Docker Login
docker login ${UPLOAD_HAROBR_URL} --username acloud --password @c0rnWks@2 > ./temp_docker_login_message
DOCKER_LOGIN_STATUS=`cat ./temp_docker_login_message`
rm -rf ./temp_docker_login_message

### Docker Login status check
if [ -z "${DOCKER_LOGIN_STATUS}" ];then
  echo "Docker login Check"  
  echo "Bye Bye"
  sleep 5
  exit 0
fi

### Docker save Directory
#rm -rf ./kube_container_download/$DOWN_VERSION
#mkdir -p ./kube_container_download/$DOWN_VERSION

### Docker Service Status Check
DOCKER_SERVICE=`systemctl status docker 2> /dev/null | grep Active: | awk {'print $2'}`

if [ -z "${DOCKER_SERVICE}" ];then
	echo "Docker process check plz"
        exit
elif [ "${DOCKER_SERVICE}" == "active" ];then
	echo "Docker Service checking Good!"
else
	echo "Docker process check plz"
        exit
fi


### Container Harbor Push & Local Path Save
for ((i=0; i<${URL_LENGTH}; i++));
do
    #Docker Save Variable
    #DOCKER_REPO=`echo "${URL[i]}" | awk -F '[/:]' '{print $1}'`
    #PACKAGE=`echo "${URL[i]}" | awk -F '[/:]' '{print $2}'`
    #VERSION=`echo "${URL[i]}" | awk -F '[/:]' '{print $3}'`
    
    echo "## ${URL[i]} ## container down start"
    docker pull "${URL[i]}"
    docker tag ${URL[i]} ${UPLOAD_HAROBR_URL}/${URL[i]}
    docker push ${UPLOAD_HAROBR_URL}/${URL[i]}

    #docker save "${URL[i]}" > ./kube_container_download/$DOWN_VERSION/$DOCKER_REPO-$PACKAGE-$VERSION.tar
    docker rmi "${UPLOAD_HAROBR_URL}/${URL[i]}"
    docker rmi "${URL[i]}"
    echo "## ${URL[i]} ## container down ok"
    echo ""
    sleep 3
done
