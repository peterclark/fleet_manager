require 'securerandom'

ActiveRecord::Base.transaction do
  
  Customer.destroy_all

  customers = [
    {
      name: 'Rackspace',
      nodes: 2
    },
    {
      name: 'USAA',
      nodes: 3
    },
    {
      name: 'Sophos',
      nodes: 4
    }
  ]

  customers.each do |customer|
    c = Customer.create name: customer[:name], enrollment_secret: SecureRandom.hex
    customer[:nodes].times do
      Node.create customer_id: c.id, node_key: SecureRandom.base64, host_identifier: SecureRandom.hex
    end
  end

  # change the last node to be the one hard coded in the osquery binary
  node = Node.last
  node.update_column(:host_identifier, 'E59B9102-BC07-57F0-9C2D-109CD318EE18')
  # change the secret used by the osquery code to be this node's customer enrollment_secret
  File.write('../osquery_client/db.secret', node.customer.enrollment_secret)
  
end