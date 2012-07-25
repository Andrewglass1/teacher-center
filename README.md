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
  - Set environment variables for `bitly_username` and `bitly_api_key` with any bitly account, you do not need to register the application, any account will work. You can find the api key in the advanced settings on bit.ly under 'legacy api key'.
    - in `~/.bash_profile`, put `export bitly_username=YOURUSERNAME`, and `export bitly_api_key=YOURAPIKEY`, then source your bash profile in all relevant terminal windows `source ~/.bash_profile`
  - rake db:setup
  - rake db:test:prepare
  - rake db:seed

## To Run Locally
  - `rails server`

## To Run the Test Suite
  - `bundle exec rspec`
