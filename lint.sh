#!/bin/bash
#$latest=0


# Get the latest release tag number
newnumber=$(curl --silent "https://api.github.com/repos/aws-cloudformation/cfn-python-lint/releases/latest" | jq -r .tag_name | cut -d'v' -f 2)
echo "The latest release tag is "$newnumber


# Get current number
#currentvalue=$(<num.txt)
#echo "The current release tag is "$currentvalue
FILE=num.txt
if [ -f "$FILE" ];
then
  oldnumber=$(<num.txt)
  echo "The current record is " $oldnumber


  if [ $newnumber != $oldnumber ];
  then
      echo $newnumber > num.txt
      echo "Updated the num.txt record "
      git clone https://github.com/aws-cloudformation/cfn-python-lint.git
      echo "git clone completed"
      cd cfn-python-lint
      echo "Built image"
      docker build beanxyz/lint:latest .
      echo "Push to Docker hub"
      docker tag beanxyz/lint:$newnumber
      docker push beanxyz/lint:latest
      docker push beanxyz/lint:$newnumber

  else
      echo "No update"
  fi

else
      echo "num.txt didn't exist, let's create a new one"
      echo $newnumber > "./num.txt"

fi
