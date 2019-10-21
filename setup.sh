#!/bin/bash
# simplified from https://github.com/brunomarram/kadira-compose/blob/master/kadira.sh
RED='\033[0;31m'
NC='\033[0m' # No Color

# cd ~/kadira-compose

echo -e "${RED}Stopping Kadira...${NC}"
docker-compose down
echo -e "${RED}Kadira stopped${NC}"

echo -e "${RED}Starting and reconfiguring Kadira...${NC}"
docker-compose up -d mongo
sleep 10
docker-compose exec mongo mongo --eval 'rs.initiate({_id:"kadira", members: [{_id: 0, host: "mongo:27017"}]})'
sleep 10
docker-compose up -d
echo -e "${RED}Kadira started${NC}"

echo -e "${RED}Setting up user admin@teebly.co...${NC}"
docker-compose exec mongo mongo kadira --eval 'db.users.remove({})'
docker-compose exec mongo mongo kadira --eval 'db.users.insert({ "_id" : "2XdEHNuftPEykJwk4", "createdAt" : ISODate("2018-11-08T13:22:49.233Z"), "services" : { "password" : { "bcrypt" : "$2a$10$LW1zraeMFGb7kHD70XrJB.TNSx3bsKLBhbbWXjfjIpmIRVV6im2A6" } }, "username" : "admin", "emails" : [ { "address" : "admin@teebly.co", "verified" : true } ], "states" : { "__inited" : 1541683382581 } })'
echo -e "${RED}Users set up${NC}"

echo -e "${RED}Setting up applications${NC}"
docker-compose exec mongo mongo kadira --eval 'db.apps.remove({})'

docker-compose exec mongo mongo kadira --eval 'db.apps.insert({ "_id" : "hpazbbpN57KGrqeXQ", "name" : "TBL Local", "created" : ISODate("2018-11-08T13:29:15.809Z"), "owner" : "2XdEHNuftPEykJwk4", "secret" : "6c9fce00-e380-4291-a70b-a33ff972861e", "plan" : "business", "shard" : "one", "subShard" : 69, "pricingType" : "paid" })'
echo -e "${RED}App created${NC}"


echo -e "${RED}Kadira all set up!${NC}"
