class CreateTokensTable < ActiveRecord::Migration[6.1]
  def change
    create_table :tokens do |t|
      t.string :token_id
      t.datetime :expiry
      t.datetime :last_assigned_at
      t.timestamps
    end
  end
end
