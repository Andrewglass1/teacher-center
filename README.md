teacher-center
==============

Hungry Academy Project for Donorschoose.org:

The TeacherCenter is a hub for teachers to get their Donorschoose.org funded.  Input a url from a DonorsChoose project and send emails, Tweets and Facebook posts to promote your project.  Print customized letters and flyers.TeacherCenter tracks your click-through rates on each medium and provides analytics for your project donations.

Use the following account for a test project:
email: donor@livingsocial.com
password: hungry


## Necessary Setup
  - Postgres running locally
    - install: `brew install postgresql`
    - start server: `pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start`
  - Set environment variables
    - open `~/.bash_profile`
      - `export bitly_username=YOURUSERNAME`, any bitly account will work
      - `export bitly_api_key=YOURAPIKEY`, find it here: http://bitly.com/a/your_api_key
      - `export new_relic_key=YOURKEY` (this step is not necessary to get things working, you will simply see an error in the console without it)
        - create a new relic account, then go to https://rpm.newrelic.com/accounts, click on your account, download the yaml file. Your key is the license key in the yaml file.
    - source your bash profile in all relevant terminal windows `source ~/.bash_profile`
  - rake db:setup
  - rake db:test:prepare
  - rake db:seed

## To Run Locally
  - `rails server`

## To Run the Test Suite
  - `bundle exec rspec`
