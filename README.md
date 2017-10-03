# kadira-compose

Based on https://forums.meteor.com/t/running-a-own-kadira-instance-update-now-with-a-guide/35938/34

## Configuration

Edit `.env` to change HOST and EMAIL environment variables.

## Execution

* Launch dockers, and initialize Mongo replica set:

  ```
  ./docker-compose up -d mongo
  ./docker-compose exec mongo mongo --eval 'rs.initiate({_id:"kadira", members: [{_id: 0, host: "mongo:27017"}]})'
  ./docker-compose up -d
  ```

* Open `http://localhost:4000` and login with email `admin@gmail.com`
  (initial password `admin` -- change it immediately in the UI)

* Create your apps

* Upgrade apps to business plan:

  ```
  ./docker-compose exec mongo mongo kadira --eval 'db.apps.update({},{$set:{plan:"business"}},{multi:true})'
  ```