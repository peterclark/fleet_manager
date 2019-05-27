class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string :name, index: { unique: true } 
      t.string :enrollment_secret, index: { unique: true }
    end
  end
end
