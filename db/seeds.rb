User.destroy_all
Task.destroy_all
Project.destroy_all
ProjectTask.destroy_all

t1 = Task.create(medium: "Twitter"      , stage: "Phase 1")
t2 = Task.create(medium: "Facebook"     , stage: "Phase 2")
t3 = Task.create(medium: "Mail"         , stage: "Phase 3")
t4 = Task.create(medium: "Email"        , stage: "Phase 3")
t5 = Task.create(medium: "PrintAndShare", stage: "Phase 3")


#sample data
user = User.create(email: "donor@livingsocial.com",password: "hungry")
project = Project.create(
        :user_id => user.id,
        :city => "Washington",
        :cost_to_complete_cents => 150000,
        :dc_id => 795593,
        :dc_url => "http://www.donorschoose.org/project/help-my-students-get-comfortable-with-re/795593/",
        :description => " I don't tend to get lost in a book when I'm sitting upright at a desk. Neither do my students. They like to feel cozy and alone. I have noticed that they are most involved in ...",
        :expiration_date => Date.today+120,
        :goal_cents => 200000,
        :image_url => "http://www.donorschoose.org/images/user/uploads/small/u1025292_sm.jpg?timestamp=1336438786252",
        :percent_funded => 75,
        :school => "Jefferson Davis Middle School",
        :stage => "initial",
        :state => "D.C.",
        :teacher_name => "Mr. Casimir",
        :title => "Help My Students Get Comfortable With Reading",
        :start_date => Date.today-60
)

date = Date.today-60
funded = 0
increments = [0,100,2000,250,1500,3000]
until date == Date.today
  increment = increments.sample
  puts increment.inspect
  funded += increment
  project.donation_logs.create(date: date, amount_funded_cents:funded)
  date = date+1
end

task_ids =  [t1.id,t2.id,t3.id,t4.id,t5.id]
15.times do
  project.project_tasks.create(task_id: task_ids.sample, clicks: rand(2..20), completed: true, completed_on: rand(Date.today-60..Date.today) )
end


