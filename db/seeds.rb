<<<<<<< HEAD
User.destroy_all
Task.destroy_all
Project.destroy_all
ProjectTask.destroy_all

u = User.create(email: "MikeSilvis@gmail.com", password: "hungry")

t1 = Task.create(medium: "Twitter"      , stage: "Phase 1", description: "Check out my donors choose project")
t2 = Task.create(medium: "Facebook"     , stage: "Phase 2", description: "Check out my donors choose project")
t3 = Task.create(medium: "Mail"         , stage: "Phase 3", description: "Check out my donors choose project")
t4 = Task.create(medium: "PrintAndShare", stage: "Phase 3", description: "Check out my donors choose project")
t4 = Task.create(medium: "Email"        , stage: "Phase 3", description: "Check out my donors choose project")

p = Project.create_by_project_url("812882")
u.projects << [p]
=======
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
User.destroy_all
Task.destroy_all
ProjectTask.destroy_all
Project.destroy_all

user = User.create(email: "MikeSilvis@gmail.com", password: "hungry")
Task.create(medium: "Twitter"      , stage: "Phase 1")
Task.create(medium: "Facebook"     , stage: "Phase 2")
Task.create(medium: "Mail"         , stage: "Phase 3")
Task.create(medium: "PrintAndShare", stage: "Phase 3")
Task.create(medium: "Email"        , stage: "Phase 3")
project = Project.create_by_project_url('http://www.donorschoose.org/project/social-studies-alive/812882/?utm_source=api&amp;utm_medium=feed&amp;utm_content=bodylink&amp;utm_campaign=DONORSCHOOSE')

user.projects << [project]
>>>>>>> 8bb7dba005010f0058dfc143748924bf136064a9
