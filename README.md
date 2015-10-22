KEP backend
===========

#Installing:

##Build
```bash
git clone https://github.com/thesponge/kep-backend.git

# OR

git clone https://github.com/thesponge/kep.git
git submodule init
git submodule update
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
  * Backgrounds jobs with Sidekiq and Redis
  * Indexing and searching/filtering with ElasticSearch


####Database
  In the effort of making the database as flexible and efficient as possible we used several complex designs:
  * Has-and-belongs-to-many for records that should be changed through their corresponding instances as well as through instances of the related record
  * Polymorphic has-and-belongs-to-many for cases where 2 records are each related to a third one with which they each have the relation explained above ^
  * Polymorphic has-many-though for cases related to the one above but where the join table contains extra data and has to be directly accessed.


###Special features
  * Notifications
    There are both email notifications and in-platform. The email ones are sent through background services
    and the in-platform ones are created and stored in the db when the corresponding event happens. The email notifications are reserved for urgent events (see priorities below). Personalization of what and how should be notified is part of the planned features.
  * Prioritize resource sharing
      Every time a user creates an assignment or a resource, its default state is private (nobody else can see it). Before it goes public (everyone can see it), the owner can choose an intermediary state: private.During this state, the owner can choose several users that have privileged access to that resource: for a limited amount of time chosen by the owner, those users can see and take that resource.
      This process of prioritizing can have multiple levels, each with their corresponding amount of time.
      ex: I post an assignment. I first want to share it with several users I know and I would like to work with. So I make a list of those users on the first level of priority and I choose a time span of 5 hours. On the second level of priority I choose all the people in my organization and a time span of 10 hours. During the first 5 hours,the users on the first level will be notified and only they can have access to that resource. After that time expires, for the next 10 hours the people from my organization receive notifications and only they + the people from the first level have access to that resource. After that, if I haven't added any other levels of priority in the meantime, the resource goes public.

  * Automatic match-making functionality
      For each assignment that is posted there is a background job that compares the requirements(knowledge, location, etc.) of that assignment with the attributes (knowledge, location, etc.) stated by users in their profile details and calculates a "compatibility score". Based on that score, the assignment's owner will receive suggestions to choose those people for priority levels explained above.

  * Manual match-making functionality
      Supported for combinations:
      - user profile - user profile (Suggest that two users have shared interests and could work together)
      - user profile - resource (Suggest that a resource could be useful for a user)
      - user profile - assignment (Suggest that a user is suitable to carry out that assignment)

     This feature lets a third user make a match between two parties(as stated above) if they happen to notice a compatibility between them. Based on the feedback of the matched parties, the user will have a raised "match-maker" reputation.

###Planed features
  * Settings panel for users
  * Deployment with docker
  * OAuth integration for more providers
