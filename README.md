teacher-center
==============

Hungry Academy Project for Donorschoose.org:

The TeacherCenter is a hub for teachers to get their Donorschoose.org funded.  Input a url from a DonorsChoose project and send emails, Tweets and Facebook posts to promote your project.  Print customized letters and flyers.TeacherCenter tracks your click-through rates on each medium and provides analytics for your project donations.

Use the following account for a test project:
email: donor@livingsocial.com
password: hungry


## Necessary Setup
  - Postgres running locally
  - Set environment variables for `bitly_username` and `bitly_api_key` with any bitly account.
  - rake db:create
  - rake db:migrate & rake db:test:preapre
  - rake db:seed