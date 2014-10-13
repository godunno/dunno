[ ![Codeship Status for godunno/dunno](https://www.codeship.io/projects/c3ff0dd0-2a61-0132-13f5-3a647b7b807e/status)](https://www.codeship.io/projects/38254)
dunno
=======

This is the backend app that implements dashboard to teachers, managers and admins and supports iOS App. 

## How to run this project?

1. ```git clone REPO_URL```
2. ```cd dunno```
3. ```bundle```
4. ```./bin/bootstrap```
5. ```rake db:setup```
6. ```rake db:seed```
7. ```foreman start```
8. Go to http://localhost:3000

**Don't forget to run our bootstrap! It contains our team's workflow!**

### Additional config

You still need to configure Pusher ENV vars, used by Pusher. It is
recommended to put them on your .bash file. (this example uses a dunno account at Pusher)

   ```$ export PUSHER_APP_ID=65975 ```
   
   ```$ export PUSHER_KEY=eb2e8026ff09c08e1081 ```

   ```$ export PUSHER_SECRET=45f4a6e227c92884dc2a ```

## Sanity check!

Is your first time here? Ok, so you should check some stuff. If some of the checks fails, ask any of the contributors.

Checks you have to do:

1. Do ```bundle``` works and install all gems accordingly?
2. Do ```rake db:setup``` works?
3. Do ```rake db:seed``` works?
4. After run ```foreman start``` if you go to ```http://localhost:3000``` you see something that shows the project is working?
5. Is code coverage 100%?
6. Do the project have Rollbar or Airbrake configured in production environment?

## Create remote git repository

1. Create git repo.
2. Add remote ```$ git remote add origin REPO_URL```.
3. Push to repo ```$ git push --set-upstream origin```.


## Run specs

```$ rspec .```

## Configuring domain on Heroku

Check out this [wiki](https://github.com/Helabs/pah/wiki/Configuring-domain-on-Heroku) with detailed instruction of how to use the canonical_host to redirect your naked domain to your real app.

