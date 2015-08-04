KEP backend
===========

#Installing:

##Build
```bash
git clone https://github.com/thesponge/kep.git

# OR

git clone git@git.thesponge.eu:thesponge/kep-ember.git # (this is a mirror)
```

```bash
cd backend
bundle install
rake db:migrate
rake db:seed_fu # this will populate the db with the fixed values (i.e. dropdown menu options)
rails server
```
##To start background jobs processing 
```bash
 redis -server 
 bundle exec sidekiq 
```



##Description:
  * Rails behaves as a REST API for any frontend
  * Devise-based internal authentication
  * Active Model Serializer to provide json  
  * PostgreSQL database
  * Stable deployment with Mina
  * Background jobs processing with Sidekiq and Redis

####Database
  In the effort of making the database as flexible and efficient as possible we used several complex designs:
  * Has-and-belongs-to-many for records that can be changed through their corresponding instances as well as from instances of the related record
  * Polymorphic has-and-belongs-to-many for cases where 2 records are each related to a third one with which they each have the relation explained above ^
  * Polymorphic has-many-though for cases related to the one above but where the join table contains extra data and has to be directly accessed.

##What's there
  * Automatic match making functionality
  * User notifications
  * Workflow for both assignments and resources, with the ability to choose priorities on different levels
 
###What's to come
  * Deployment with docker
  * Search and filtering functionality  
  * OAuth integration for more providers
  
