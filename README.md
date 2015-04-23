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


##Description:
  * Rails behaves as a REST API for any frontend
  * Devise-based internal authentication
  * Active Model Serializer to provide json  
  * PostgreSQL database
  * Stable deployment with Mina

####Database
  In the effort of making the database as flexible and efficient as possible we used several complex designs:
  * Has-and-belongs-to-many for records that can be changed through their corresponding instances as well as from instances of the related record
  * Polymorphic has-and-belongs-to-many for cases where 2 records are each related to a third one with which they each have the relation explained above ^
  * Polymorphic has-many-though for cases related to the one above but where the join table contains extra data and has to be directly accessed.

##What's planned
  * Automatic match making functionality
  * Ranking/comment system
  * User notifications
  * Consume ownCloud's API in order to populate the interface with some of its features (Ember -> Rails -> ownCloud -> Rails -> Ember), such as: files, calendars, contacts ( *DAV)
  * OAuth integration for more providers
  * Search and filtering functionality  
