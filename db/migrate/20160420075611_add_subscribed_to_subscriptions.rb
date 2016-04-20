class AddSubscribedToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :unsubscribed, :boolean, default:false
    add_column :subscriptions, :unsubscribe_token, :string
  end
end
