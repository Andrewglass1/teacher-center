require 'spec_helper'

describe Project do
  context ".create_by_project_url" do
    let(:project_reponse) {
      {
        'city' => 'blah'
      }
    }
    before do
      stub(:get_project).and_return(project_response)
    end

    context "when given a valid project url" do
      it "creates a project with all valid attributes" do
        expect { Project.get_project('http://www.donorschoose.org/project/biotechnology-applications/816888/') }.to change(Project.count).by(1)
      end
    end
  end
end
