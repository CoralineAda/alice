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

### Setting Up an IRC Server

Install hector,  (a lightweight IRC server)

    gem install hector

Set up hector:

    hector setup myserver
    cd myserver.hect

Set up permissions for your hector IRC account:

    hector identity remember my_account_name

Set up permissions for Alice:

    hector identity remember AliceBot

Start the IRC server

    hector daemon

Add the AliceBot password you created in hector to your `.env` file. All the other settings should be fine.

### Starting the Bot

Start 2 IRB sessions: one for running Alice and one for interacting with the Alice program:

    irb -r ./alice.rb

In the first IRB session, start the bot:

    Alice.bot.start

Alice will have joined the ##alicebottest channel on your local server now. Follow her there.

You will need to send `/pass my_hector_password` to the local hector IRC server to join.

Alice should be waiting for you! Experiment away.

