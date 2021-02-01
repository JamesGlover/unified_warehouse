# Unified Warehouse Builder

[![Build Status](https://travis-ci.org/sanger/unified_warehouse.svg?branch=develop)](https://travis-ci.org/sanger/unified_warehouse)

This application is a denormalised warehouse for multiple LIMS.

## Usage (Development)

### Installation

1. Clone the git repository
1. Install the relevant ruby is installed - have a look in the `.ruby-version` file
1. Install bundler the version of bundler used to create the `Gemfile.lock`:

       `gem install bundler -v $(tail -1 Gemfile.lock)`

1. Run the setup process:

       `bin/setup`

### Database preparation

Before you can use the system in any capacity, you must first prepare the database.
This should be handled by `bin/setup` above, but if not:

1. `bundle exec rake db:setup`

#### (Optional) Create the views

This project provides with the view ```cherrypicked_samples``` that links data with
the event warehouse. To create the view you need to run the command:

1. `bundle exec rake db:views:schema:load`

### Running tests

Ensure the test suite is running and passing:

    bundle exec rspec

### Running integration tests

#### Event warehouse integration

By default the integration tests are disabled as they require to have the events warehouse
database to be configured with a specific set of testing data. To set up the events warehouse
and run the tests:

1. Go to the event warehouse project folder

1. Setup the testing database:
   
   bundle exec rake db:setup

1. Load the specific set of seeds for it:

   RAILS_ENV=test bundle exec rails runner spec/data/integration/seed_for_unified_wh.rb

1. Go back to the unified warehouse folder

1. Create the dependent views

   bundle exec rake db:views:schema:load

1. Run the integration tests:

   bundle exec rspec --tag integration

### Preparing to run locally with Traction Service

RabbitMQ is essential for this process, so if you haven't already, install it using:

    brew install rabbitmq
    brew services start rabbitmq

You can now view the instance running at [http://localhost:15672/](http://localhost:15672/).

Ensure that you update the `config/environments/development.rb` file in this repository with the exchange name and queue name that are in the `bunny.yml` file for Traction Service.
The keys to modify here are `config.amqp.main.queue` and `config.amqp.main.exchange`.
When the unified warehouse is first run, it will look for an exchange and queue of these names and create them if they don't exist.
However, it is also note worthy that the queue is not set up correctly to work with Traction Service since the queue is not set to `durable = true` and has additional header keys for `x-dead-letter-exchange` and `x-message-ttl` which Traction Service isn't expecting.
To fix this replace the line in `lib/postman/channel.rb` that reads:

    channel.queue(@queue_name, arguments: queue_arguments)

so that it instead reads:

    channel.queue(@queue_name, durable: true)

This will ensure the queue that is generated is compatible with the expectations of Traction Service.

### Execution

Execute the worker to pick up messages in the queue and process them into the
database:

    ```bundle exec ./bin/amqp_client start```

where `start` instructs it to start. You can also stop a worker by calling `stop`
or restart it with `restart`.

To run in non-daemonized mode, which can be useful for debugging:

    ````bundle exec ./bin/amqp_client run```

#### Troubleshooting

If you receive an error about a missing output file under `tmp/pid/` it may be that you need to create this directory manually.
Once the directory above has been inserted at the root of the repository, the error should go away.

#### How To Section

Cog Uk Ids - These ids are given to positive samples imported through the Lighthouse-UI. This process should automatically record those Ids in the sample table, and also into the lighthouse_sample table.
To migrate Cog Uk Ids into the lighthouse_sample table manually via SQL, see this Confluence page:
https://ssg-confluence.internal.sanger.ac.uk/display/PSD/How+to+migrate+Cog+UK+IDs+into+the+lighthouse_sample+table
