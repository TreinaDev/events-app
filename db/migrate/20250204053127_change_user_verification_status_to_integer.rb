class ChangeUserVerificationStatusToInteger < ActiveRecord::Migration[8.0]
  def change
    change_column :users, :verification_status, :integer
  end
end
