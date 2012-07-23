class ClickLog < ActiveRecord::Base
  attr_accessible :project_id, :daily_clicks, :date, :total_clicks_to_date
  belongs_to :project

end
