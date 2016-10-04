## Overall Architecture

![Alice Architecture](https://github.com/CoralineAda/alice/blob/master/doc/architecture.png)

## Key Models & Namespaces

![Key Models and Namespaces](https://github.com/CoralineAda/alice/blob/master/doc/models_and_namespaces.png)

## Setting Up a Local Alice for Development

### Prepping Alice

Before you start, make sure to run `bundle`

Next, rename `config/mongoid.yml.sample` to `mongoid.yml`

Also rename `.env.sample` to `.env`

Run the following from Terminal to initialize basic commands:

    ruby db/commands/import.rb

### Starting the Bot

    ruby ./alice.rb

Alice should be waiting for you! Experiment away by hitting localhost on port 4567 with POST requests.

