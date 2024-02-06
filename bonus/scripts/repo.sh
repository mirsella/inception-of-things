#!/bin/bash

if [ $(whoami) != root ]; then
	exit $(sudo bash "$0")
fi

apt-get update -y
apt-get install uuid-runtime -y

TOKEN=$(uuidgen)
PWD=$(pwd)

get_pod() {
	kubectl get pods -n gitlab | grep webservice | awk '{print $1}'
}

kubectl -n gitlab exec -it $(get_pod) -- /srv/gitlab/bin/rails console <<EOF
token = User.find_by_username('root').personal_access_tokens.create(scopes: [:api, :sudo, :read_user, :read_repository, :write_repository], name: 'Root token', expires_at: 365.days.from_now)
token.set_token('$TOKEN')
token.save!
EOF

sleep 5

curl -H "Content-Type:application/json" \
	http://localhost:8181/api/v4/projects?private_token=$TOKEN \
	-d '{ "name": "service", "visibility": "public" }'

echo '\n'

sleep 5

DIR=/tmp/git-service-$TOKEN

mkdir $DIR
git clone http://localhost:8181/root/service.git $DIR

cp confs/wil-app.yml $DIR/wil-app.yml
cd $DIR

git config user.email "admin@gitlab.local"
git config user.name "Admin"

git add wil-app.yml
git commit -m "Automatic init commit - made by repo.sh script"
echo PUSH PUSH PUSH
git push http://root:$TOKEN@localhost:8181/root/service.git

cd $PWD