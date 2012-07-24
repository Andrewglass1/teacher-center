teacher-center
==============

Hungry Academy Project for Donorschoose.org:

The Teacher center is a hub for teachers to get their Donorschoose.org funded.

## Necessary Setup
  - Postgres running locally
  - Set environment variables for `bitly_username` and `bitly_api_key` with any bitly account.
  - rake db:create
  - rake db:migrate & rake db:test:preapre
  - rake db:seed