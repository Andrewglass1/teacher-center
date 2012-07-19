require 'spec_helper'

describe ProjectTask do
  before do
    Project.stub(:get_start_date).and_return(Date.today)
  end

  let!(:project) { Project.create_by_project_url('816888') }
  let(:task) {Task.create(medium: "Twitter")}
  let!(:project_task) { ProjectTask.create({project_id: project.id, task_id: task.id})}

  context '#get_short_link' do
    it "creates a bitly url linking to the project's donors choose url after create" do
      project_task.short_url.should include 'bit.ly'
    end
  end

  context '#update_clicks' do
    it "updates the clicks on a project task's short url" do
      project_task.update_clicks
      project_task.clicks.should == 5
    end
  end

  context '#completed' do
    it "completes the task, saves the time it was completed, and stores the description" do
      task = Task.create()
      project_task.complete
      project_task.completed.should == true
      project_task.completed_on.should == Date.today
      project_task.read_attribute(:description).should be
    end
  end

  context '#description' do
    context "the project has not yet been completed" do
      it "returns a different description based off of the project's state" do
        project_task.read_attribute(:description).should be_nil

        Project.any_instance.stub(:near_end?).and_return(true)
        project_task.description.should include("ending")

        Project.any_instance.unstub(:near_end?)
        Project.any_instance.stub(:near_end?).and_return(false)
        Project.any_instance.stub(:off_track?).and_return(true)
        project_task.description.should include("help")

        project_task.project.stub(:near_end?).and_return(false)
        Project.any_instance.unstub(:off_track?)
        Project.any_instance.stub(:off_track?).and_return(false)
        project_task.description.should include("Check out")
      end

      context "the project has been completed" do
        it "returns the saved description from the database, not based off of the current state" do
          project_task.update_attributes({:completed => true, :description => "fake description"})
          project_task.description.should == "fake description"
        end
      end
    end
  end

end
