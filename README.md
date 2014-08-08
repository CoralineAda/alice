alice
=====

Architecture
------------

## Listener
This is effectively a dynamic router. It matches an incoming message to a corresponding `Command` object, which in turn indicates the handler and handler method that should be used to create a response.

## Handlers
Handlers are like controllers: they connect incoming messages to the correct methods on the correct models.

ToDo
----

* Coffee clears dazed, etc. effects
* Bio/factoid game
* Juke box function (provide a url to queue)
* Potions with specific effects
* Other machines
  * Alchemist lab (produces potions)
  * Beer tap
  * Wet bar
  * Boom box