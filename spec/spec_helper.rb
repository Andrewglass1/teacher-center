# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'simplecov'
SimpleCov.start
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.include UserSupport::Login
  config.include UserSupport::Signup

  config.before(:each) do
    fake_client = double
    UrlShortener.stub(:client).and_return(fake_client)
    fake_client.stub(:shorten).and_return(Hashie::Mash.new(short_url: 'http://bit.ly/li2je4'))
    fake_client.stub(:clicks).and_return(Hashie::Mash.new(user_clicks: 5))

    dc_page = Nokogiri::HTML(open(Rails.root + 'spec/support/donors_choose.html')) 
    ProjectApiWrapper.stub(:open_page).and_return(dc_page)

    pdf_response = "FIND OUT HOW YOU CAN HELP: http://bit.ly/M BkJ4a it easy for anyone to help student"
    PdfGenerator.stub(:pdf_reader).and_return(pdf_response)

    @project_response = Hashie::Mash.new(
      city: "blah",
      expiration_date: Date.parse("August 2 2012").to_s,
      cost_to_complete: 20,
      donors_choose_id: rand(1000),
      proposal_url: Faker::Internet.domain_name,
      short_description: Faker::Lorem.words(5).join(' '),
      fund_url: Faker::Internet.domain_name,
      total_price: 100,
      image_url: Faker::Internet.domain_name,
      on_track: true,
      percent_funded: 80,
      school_name: Faker::Lorem.words(2).join(' '),
      stage: 'initial',
      state: Faker::Lorem.words(1).join(' '),
      teacher_name: Faker::Lorem.words(1).join(' '),
      title: Faker::Lorem.words(1).join(' ')
    )
    DonorsChooseApi::Project.stub(:find_by_id).and_return(@project_response)

    ProjectApiWrapper.stub(:log_donations).and_return(true)
  end
end
