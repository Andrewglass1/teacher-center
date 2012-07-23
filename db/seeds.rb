User.destroy_all
Task.destroy_all
Project.destroy_all
ProjectTask.destroy_all

t1 = Task.create(medium: "Twitter"      , stage: "Phase 1")
t2 = Task.create(medium: "Facebook"     , stage: "Phase 2")
t3 = Task.create(medium: "Mail"         , stage: "Phase 3")
t4 = Task.create(medium: "Email"        , stage: "Phase 3")
t4 = Task.create(medium: "PrintAndShare", stage: "Phase 3")
