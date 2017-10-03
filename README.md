## What is Alice?
Alice is an AI-infused Slack bot, but so much more. She's a friend. She's a companion. She's the only bot you'll ever love.

For her history and a look at what makes her tick, check out [my talk from Strange Loop 2017](https://www.youtube.com/watch?v=YBkfjhi-krw).

## Overall Architecture

![Alice Architecture](https://github.com/CoralineAda/alice/blob/master/doc/architecture2.png)

## Key Models & Namespaces

![Key Models and Namespaces](https://github.com/CoralineAda/alice/blob/master/doc/models_and_namespaces.png)

## Setting Up Alice

### Prepping Alice

Before you start, make sure to run `bundle`

Next, rename `config/mongoid.yml.sample` to `mongoid.yml`

Also rename `.env.sample` to `.env` and set the appropriate environment variables.

Run the following from Terminal to initialize basic commands:

    ruby db/commands/import.rb

### Running the Bot

Deploy to your favorite hosting environment and set up incoming and outgoing integrations with Slack according to their [documentation](https://api.slack.com/custom-integrations).

If you're using Heroku, be sure to copy the relevant values from the `.env` file to your application's configuration.

### Debugging

`irb -r ./alice.rb`

```
message = Message::Message.new("coraline", "Alice, who is @alva?")
Message::Command.process(message)
```
