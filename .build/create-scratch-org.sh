# Get the private key from the environment variable
echo "Setting up DevHub Connection..."
mkdir keys
#echo $SFDC_SERVER_KEY | base64 -d > keys/server.key

#Decrypt server key
#openssl enc -aes-256-cbc -md sha256 -nosalt -d -in assets/server.key.enc -out keys/server.key -k $SFDC_SERVER_KEY
openssl enc -aes-256-cbc -d -in assets/server.key.enc -out keys/server.key -k $KEY_PASSWORD  #endPass

# Authenticate to salesforce
echo "Authenticating..."
sfdx force:auth:jwt:grant --clientid $SFDC_CONSUMER_KEY --jwtkeyfile keys/server.key --username $SFDC_USERNAME --setdefaultdevhubusername -a DevHub

echo "Authenticated..."

echo $CIRCLE_BUILD_NUM $CIRCLE_BRANCH $CIRCLE_USERNAME

sfdx force:auth:list
#Create scratch org
sfdx force:org:create -s -f config/project-scratch-def.json --setdefaultusername --setalias circle_build_$CIRCLE_BUILD_NUM --wait 10 --durationdays 1

#Push source to scratch org
sfdx force:source:push --targetusername circle_build_$CIRCLE_BUILD_NUM

