#!/bin/sh
n=`date "+%Y%m%d%H%M%S"`
user1=testuser${n}-1
group1=g-testgroup${n}-1
echo "==================================================== create a users"
curl -F:name=${user1} -Fpwd=testuser -FpwdConfirm=testuser http://localhost:8080/system/userManager/user.create.html
echo "====================================================  create groups "
curl -F:name=${group1} http://admin:admin@localhost:8080/system/userManager/group.create.html
echo "====================================================  make users members of groups"
curl -F:member=/system/userManager/group/${user1} http://admin:admin@localhost:8080/system/userManager/group/${group1}.update.html
echo "====================================================  check the groups are members"
curl http://admin:admin@localhost:8080/system/userManager/group/${group1}.json
echo " "
curl http://admin:admin@localhost:8080/system/userManager/user/${user1}.json
echo " "
echo "====================================================  Update the user"

x=1
while [[ $x -lt 100 ]]
do
  curl -Ftestpropert=value${x} http://${user1}:testuser@localhost:8080/system/userManager/user/${user1}.update.html 1> errorfile 2> /dev/null
  error=`grep -c 500 errorfile`
  if [[ $error -ne 0 ]] 
  then
      echo Error Updating $user1
      cat errorfile
      exit
  fi 
  echo Updated $user1 $x
  let x=x+1
done
curl http://admin:admin@localhost:8080/system/userManager/group/${group1}.json
echo " "
curl http://admin:admin@localhost:8080/system/userManager/user/${user1}.json
echo " "


