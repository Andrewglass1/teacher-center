class CreateDonationLogs < ActiveRecord::Migration
  def change
    create_table :donation_logs do |t|
      t.integer :project_id
      t.integer :amount_funded_cents
      t.date    :date
      t.timestamps
    end
  end
end
