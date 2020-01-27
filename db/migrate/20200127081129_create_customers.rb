class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.string :names
      t.string :email
      t.integer :contact
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
