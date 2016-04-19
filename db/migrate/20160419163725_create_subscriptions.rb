class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :email
      t.string :confirmation_token
      t.boolean :confirmed, default:false

      t.timestamps null: false
    end
  end
end
