#!/bin/bash
if [ -z "$1" ]; then
	echo "Usage: ./get_repos_list.sh org "
	exit 1
else
	org=$1
fi

[ -z "$GITHUB_ACCESS_TOKEN" ] && echo "GITHUB_ACCESS_TOKEN is not set." && exit 1    

#
# Create group on gitlab via API.
# visibility_level - 0: private, 10: internal, 20: public
#
curl -X POST -H "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" 'https://$gitlab_url/api/v3/groups?name=$org&path=$org&visibility_level=10' |  sed -e 's/[{}]/''/g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' > .groupinfo

while read line; do
  key=`echo $line | cut -s -d ':' -f 1`
  value=`echo $line | cut -s -d ':' -f 2`
  if [ "$key" = "\"id\"" ]; then
    export GROUP_ID=$value
  fi  
done < .groupinfo

[ -z $GROUP_ID ] && exit 1

count=1
while [ $count -gt 0 ]; do

	lines=`curl -H "Authorization: token $GITHUB_ACCESS_TOKEN" "https://$github_url/api/v3/orgs/$org/repos?page=$count" | grep full_name | sed -e 's/    "full_name": "//g'  | sed -e 's/",//g'`
  
	# stop if we don't get any more content. A bit hacky but I don't want to
	# parse HTTP header data to figure out the last page
	if [ "$lines" == "" ]; then
		count=0
	else
		for line in $lines
		do
		echo $line
		done
		count=`expr $count + 1`
	fi
done
