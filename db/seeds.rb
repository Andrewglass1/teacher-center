# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


t1 = Task.create(medium: "Twitter"      , stage: "Phase 1", description: "Check out my donors choose project")
t2 = Task.create(medium: "Facebook"     , stage: "Phase 2", description: "Check out my donors choose project")
t3 = Task.create(medium: "Mail"         , stage: "Phase 3", description: "Check out my donors choose project")
t4 = Task.create(medium: "PrintAndShare", stage: "Phase 3", description: "Check out my donors choose project")
t4 = Task.create(medium: "Email"        , stage: "Phase 3", description: "Check out my donors choose project")

p = Project.create_by_project_url("812882")
