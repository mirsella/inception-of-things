#!/bin/bash

if [ $(whoami) != root ]; then
	exit $(sudo bash "$0")
fi

apt-get update -y
apt-get install uuid-runtime -y

TOKEN=$(uuidgen)

TOKEN_SAVE_COMMAND="token = User.find_by_username('root').personal_access_tokens.create(scopes: [:api, :sudo, :read_user, :read_repository, :write_repository], name: 'Root token', expiration_date: '); token.set_token('$TOKEN'); token.save!"

get_pod() {
	kubectl get pods -n gitlab | grep webservice | awk '{print $1}'
}

kubectl -n gitlab exec -it $(get_pod) -- /srv/gitlab/bin/rails console <<EOF
token = User.find_by_username('root').personal_access_tokens.create(scopes: [:api, :sudo, :read_user, :read_repository, :write_repository], name: 'Root token', expires_at: 365.days.from_now)
token.set_token('$TOKEN')
token.save!
EOF

curl -H "Content-Type:application/json" \
	http://localhost:8181/api/v4/projects?private_token=$TOKEN \
	-d "{ \"name\": \"service\" }"
