require 'spec_helper'

describe ChartCreator do

  let(:project) { double }

  context "#initialize" do
    it "sets a project" do
      chart_creator = ChartCreator.new(project)
      chart_creator.project.should == project
    end
  end

  context "#donations_chart" do
    it "creates a donations chart" do
      chart_creator = ChartCreator.new(project)
      LazyHighCharts::HighChart.should_receive(:new).with('graph')
      chart_creator.donations_chart
    end
  end

  context "#clicks_chart" do
    it "creates a donations chart" do
      chart_creator = ChartCreator.new(project)
      LazyHighCharts::HighChart.should_receive(:new).with('graph')
      chart_creator.clicks_chart
    end
  end
end
