#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: ./mirror_repos_list.sh org_dir "
	exit 1
else
	org_dir=$1
fi

$DEBUG cd $org_dir
ret=$?
if [ $ret -ne 0 ]; then
	exit 1
fi

while read line; do

	name=$line
	[ -z "$name" ] && continue

	org=`echo $name | cut -s -d '/' -f 1`
	repo=`echo $name | cut -s -d '/' -f 2`
	[ -z "$repo" ] && continue

	gitrepo=$repo'.git'
	github_url='git@$github_url:'$org'/'$gitrepo
	gitlab_url='git@$gitlab_url:'$org'/'$gitrepo

	if [ ! -d $gitrepo ]; then
		$DEBUG git clone --mirror $github_url
		$DEBUG cd $gitrepo
    #
    # Create repo on gitlab via API.
		# visibility_level - 0: private, 10: internal, 20: public
    # 
    $DEBUG curl -X POST -H "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" 'https://$gitlab_url/api/v3/projects?name=$repo&visibility_level=10&namespace_id=$GROUP_ID'
		$DEBUG git remote add gitlab $gitlab_url
	else
		$DEBUG cd $gitrepo
	fi
	$DEBUG git fetch -t origin
	$DEBUG git push gitlab --all
	$DEBUG git push gitlab --tags
	$DEBUG cd $org_dir

done
