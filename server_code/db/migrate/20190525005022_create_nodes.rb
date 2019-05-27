class CreateNodes < ActiveRecord::Migration[5.2]
  def change
    create_table :nodes do |t|
      t.belongs_to :customer
      t.string :node_key, index: { unique: true }
      t.string :host_identifier
      t.json :host_details
    end
  end
end
