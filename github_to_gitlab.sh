#!/bin/bash
export script_dir=$(pwd)
export work_dir=$(pwd)/work_dir
export GITHUB_ACCESS_TOKEN=`cat $script_dir/.github_access_token`
export GITLAB_ACCESS_TOKEN=`cat $script_dir/.gitlab_access_token`

export gitlab_url=
export github_url=


if [ ! -d $work_dir ]; then
  $DEBUG mkdir $work_dir
fi

$DEBUG cd $work_dir

while read line; do

	org=$line
	[ -z "$org" ] && continue

	if [ ! -d $org ]; then
		$DEBUG mkdir $org
	fi

	org_dir=$work_dir/$org
	list_file=$script_dir/.$org'.list'
	bash -x $script_dir/get_repos_list.sh $org > $list_file
	bash -x $script_dir/mirror_repos_list.sh $org_dir < $list_file 
	$DEBUG cd $work_dir

done
