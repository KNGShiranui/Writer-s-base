class AddLastLoginBonusDateToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :last_login_bonus_date, :date
  end
end
