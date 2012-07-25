require 'spec_helper'

describe Project do

  context ".create_by_project_url" do
    before { Project.stub(:get_start_date).and_return(Date.today) }

    context "when given a valid project url" do
      let(:valid_url){ 'http://www.donorschoose.org/project/biotechnology-applications/816888/'}
      let(:completed_valid_url){ 'http://www.donorschoose.org/donors/proposal.html?id=88850'}
      it "creates a project" do
        expect { Project.create_by_project_url(valid_url) }.to change{Project.count}.by(1)
        @project_response.donors_choose_id += 1
        expect { Project.create_by_project_url(completed_valid_url) }.to change{Project.count}.by(1)
      end

      context "that project is already in the database" do
        it "does not create a new project" do
          Project.create_by_project_url(valid_url)
          expect { Project.create_by_project_url(valid_url) }.to change{Project.count}.by(0)
        end
      end
    end

    context "when given an invalid url" do
      let(:invalid_url) { "http://google.com"}
      it "does not create a project" do
        expect { Project.create_by_project_url(invalid_url) }.to change{Project.count}.by(0)
      end
    end
  end

  context ".get_start_date" do
    let(:dc_url){ 'http://www.donorschoose.org/project/biotechnology-applications/816888/'}
    it "retrieves the start date of the project when given the id" do
      ProjectApiWrapper.get_start_date(dc_url).should == Date.parse("26 Jun 2012")
    end
  end

  context "#projected_fund_date" do
    let(:project) { Project.create_by_project_url('816888') }
    before do
      Project.stub(:get_start_date).and_return(Date.parse('July 1 2012'))
      Date.stub(:today).and_return(Date.parse('July 12 2012'))
    end

    context "the project is live and not yet funded" do
      it "returns the projected fund date" do
        project.projected_fund_date.should == Date.parse('Mon 16 2012')
      end
    end

    context "the project has been funded but has not yet ended" do
      it "returns today's date" do
        project.update_attribute(:percent_funded, 100)
        project.projected_fund_date.should == nil
      end
    end

    context "the project has ended" do
      it "returns nil" do
        project.update_attribute(:expiration_date, Date.parse('July 4 2012'))
        project.projected_fund_date.should == nil
      end
    end

  end

  context "#update_information" do
    before do
      Project.stub(:get_start_date).and_return(Date.today)
    end
    let!(:project) { Project.create_by_project_url('816888') }
    it "updates the cost to complete and percent funded for a project, but not any other attributes" do
      original_project_response         = @project_response.clone
      @project_response.percent_funded   = 90
      @project_response.cost_to_complete = 10
      @project_response.title            = 'new title'

      project.update_information
      project = Project.last

      project.percent_funded.should         == @project_response.percent_funded
      project.cost_to_complete_cents.should == @project_response.cost_to_complete * 100
      project.title.should                  == original_project_response.title
    end
  end

  context "#off_track" do
    let(:project) { Project.create_by_project_url('816888') }
    before do
      Project.stub(:get_start_date).and_return(Date.parse('July 1 2012'))
    end

    context "when the expiration date is later than the projected fund date" do
      it "returns false" do
        Date.stub(:today).and_return(Date.parse('July 12 2012'))
        project.off_track?.should == false
      end
    end
    context "when the expiration date is sooner than the projected fund date" do
      it "returns true" do
        Date.stub(:today).and_return(Date.parse('August 1 2012'))
        project.off_track?.should == true
      end
    end
  end

  context "tasks" do
    let!(:project) { Project.create_by_project_url('816888') }

    before do
      Project.stub(:get_start_date).and_return(Date.parse('July 1 2012'))
      Date.stub(:today).and_return(Date.parse('July 12 2012'))
      ProjectTask.any_instance.stub(:get_short_link).and_return(true)
    end

    let!(:task) { Task.create({:medium => "Twitter"}) }
    let!(:project_task) {
      ProjectTask.create({ :task_id => task.id, :project_id => project.id })
    }

    let!(:completed_project_task) {
      ProjectTask.create({ :task_id => task.id, :project_id => project.id, :completed => true })
    }

    context "#tasks_to_do" do

      it "returns the project's project tasks that have not been completed" do
        project.tasks_to_do.should == [project_task]
      end
    end

    context "#completed_tasks" do
      context "when given no parameters" do
        it "returns the project's project tasks that have been completed" do
          project.completed_tasks.should == [completed_project_task]
        end
      end
      context "when given a medium" do
        it "returns only the project's project tasks that have been completed that have that medium" do
          project.completed_tasks("Twitter").should == [completed_project_task]
          project.completed_tasks("Facebook").should == []
        end
      end
    end
  end

  context ".seed_initial_project_log" do
    let!(:project) { Project.create_by_project_url('816888') }
    it "initializes with a project log for the start date with 0 funded" do
      project.donation_logs.first.date.should == project.start_date
      project.donation_logs.first.amount_funded_cents.should == 0
    end
  end

end
