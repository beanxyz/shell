#!/bin/bash
#$latest=0


# Get the latest release tag number
newnumber=$(curl --silent "https://api.github.com/repos/aws-cloudformation/cfn-python-lint/releases/latest" | jq -r .tag_name | cut -d'v' -f 2)
echo "The latest release tag is "$newnumber

# num.txt will keep the previous tag number
FILE=num.txt
if [ -f "$FILE" ];
then
  oldnumber=$(<num.txt)
  echo "The current tag is " $oldnumber

#if the record didn't match then update the contents and pull new data , build and push to docker hub

  if [ $newnumber != $oldnumber ];
  then
      echo $newnumber > num.txt
      echo "********Updated the num.txt record*****"
      cd cfn-python-lint
      git pull
      echo "*******Built image*********"
      docker build -t beanxyz/lint:latest .
      echo "*******Push to Docker hub********"
      docker tag beanxyz/lint:latest beanxyz/lint:$newnumber
      docker push beanxyz/lint:latest
      docker push beanxyz/lint:$newnumber

  else
      echo "****** No update ********"

  fi

else
      echo "*****num.txt didn't exist, let's create a new one*******"
      echo $newnumber > num.txt
      git clone https://github.com/aws-cloudformation/cfn-python-lint.git
      cd cfn-python-lint
      echo "*****Built image*******"
      docker build -t beanxyz/lint:latest .
      echo "*******Push to Docker hub*****"
      docker tag beanxyz/lint:latest beanxyz/lint:$newnumber
      docker push beanxyz/lint:latest
      docker push beanxyz/lint:$newnumber

fi
