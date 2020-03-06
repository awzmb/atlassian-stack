PROJECTKEY=MA
BASEURL="https://schulung-1.butt3rweck.com/jira"
USERNAME=dsbundschuh
PASSWORD=Geheim!

BASICAUTHBASEURL="https://${USERNAME}:${PASSWORD}@schulung-1.butt3rweck.com/jira"
for i in `seq 1 10`;
do
    curl -X POST \
        --verbose \
        --header "Content-Type: application/json" \
        --header "X-Atlassian-Token: no-check" \
	--data '{"name": "user'${i}'","password": "user'${1}'","emailAddress": "user'${i}'@butt3rweck.com","displayName": "Benutzer'${i}'","applicationKeys": ["jira-core"]}' \
        "${BASICAUTHBASEURL}/rest/api/2/user"
done
