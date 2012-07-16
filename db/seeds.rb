# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

p = Project.create(:dc_id => "812882",
               :dc_url => "http://www.donorschoose.org/project/social-studies-alive/812882/?utm_source=api&amp;utm_medium=feed&amp;utm_content=bodylink&amp;utm_campaign=DONORSCHOOSE",
               :goal_cents => 24362, :percent_funded => 4, :cost_to_complete_cents => 23362,
               :image_url => "http://cdn.donorschoose.net/images/user/uploads/small/u374028_sm.jpg?timestamp=1303043049195",
               :teacher_name => "Ms. Lockett", :title => "Social Studies ALIVE!!!",
               :school => "Hubbard Elementary School", :expiration_date => "Thu, 02 Aug 2012",
               :fund_url => "https://secure.donorschoose.org/donors/givingCart.html?proposalid=812882&amp;donationAmount=&amp;utm_source=api&amp;utm_medium=feed&amp;utm_content=fundlink&amp;utm_campaign=DONORSCHOOSE",
               :city => "Forsyth", :state => nil,
               :description => "What did your social studies instruction look like in school? Do you remember lectures? How about those black and white videos? I want to make social studies interactive and fun all while...",
               :stage => "initial", :on_track => true,
               )

t1 = Task.create(medium: "Twitter",           stage: "Phase 1")
t2 = Task.create(medium: "Facebook",          stage: "Phase 2")
t3 = Task.create(medium: "Snail Mail!",       stage: "Phase 3")
t4 = Task.create(medium: "PDF Generation!",   stage: "Phase 3")

p.project_tasks << [ProjectTask.new(task_id: t1.id, completed: true), ProjectTask.new(task_id: t3.id, completed: false)]