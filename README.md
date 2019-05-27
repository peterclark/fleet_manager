# OSQUERY FLEET MANAGER

### Setup

1. Clone the project

```ruby
git clone <repo url>
```

2. Bundle and create the database

```
cd fleet_manager/server_code
bundle
bundle exec rake db:create
```

3.  Migrate the database

```
bundle exec rake db:migrate
```

4. Seed the database

```
bundle exec rake db:seed
```

5. Start the web server

```
./start.sh
```

6. Start the Osquery binary

```
cd ../osquery_client
./db-darwin --flagfile db.flags --config_dump
```
