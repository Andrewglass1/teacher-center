User.destroy_all
Task.destroy_all
Project.destroy_all
ProjectTask.destroy_all

u = User.create(email: "MikeSilvis@gmail.com", password: "hungry")

t1 = Task.create(medium: "Twitter"      , stage: "Phase 1")
t2 = Task.create(medium: "Facebook"     , stage: "Phase 2")
t3 = Task.create(medium: "Mail"         , stage: "Phase 3")
t4 = Task.create(medium: "Email"        , stage: "Phase 3")
t4 = Task.create(medium: "PrintAndShare", stage: "Phase 3")

p = Project.create_by_project_url("812882")
u.projects << [p]
