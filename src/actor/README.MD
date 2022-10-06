# The Actor Model Principles (fundamental)
 - Everything is an Actor
 - In the Actor Model, an Actor is a first-class citizen
 - An Actor has a mailbox to store data
 - Actors should communicate with each other asynchronously
 - Actors should communicate with each other in a non-blocking way
 - Actors communicate with each other by sending messages
 - All computations should be performed within an Actor
 - An Actor can send or receive message to or from another Actor
 - There is no direct communication between Actors
 - Each Actor is identified using a unique name or address
 - An Actor can send messages to other Actors whose addresses it has
 - An Actor can have state or behavior or both
 - An Actor can have state, but it's accessible by itself only, which means that only an Actor can modify its state; no other Actor or non-Actor can access or modify it—that's the beauty of the Actor Model
 - An Actor should process only one message at a time
 - An Actor should receive only one message at a time
 - Messages are delivered arbitrarily, that is, messages are delivered to Actors in any order
 - Messages are immutable objects, which means we cannot modify them once they are created
 - An Actor can process any kind of messages
 - Each message is delivered at most once only, which means a message is delivered from the sender Actor to the receiver Actor either zero times or once; so there is no chance of delivering duplicate messages in the Actor Model 
 - When an Actor receives a message, based on the context, it does one or more of the following things:
   - It can change its state
   - It can change its behavior
   - It can change both its state and behavior
   - It can create some more Actors
   - It can send messages to other Actors
   - It can forward messages to other Actors
   - It can acknowledge a message to a sender Actor
   - It can decide what to do with the next message, that is, how to handle them

### Analogy between OOP vs FP vs Actor Model
 - In the OOP paradigm, an object is a fundamental unit of computation.
 - In the FP paradigm, a Function is a fundamental unit of computation.
 - In the Actor Model paradigm, an Actor is a fundamental unit of computation.
 - Like OOP's Object, `Actor = State + Behavior`

### ActorSystem (Akka) - Roles and Responsibilities
 - It acts as runtime for all Actors
 - It creates Actors
 - It can stop Actors
 - It supervises related Actors
 - It creates threads and assigns them to the Actor's dispatcher to process the messages
 - It manages the lifecycle of Actors
 - It can shut down the whole Akka Actor environment
 - It creates the following three base Actors to help other Actors:
   - Root Actor (/)
   - User Guardian Actor(/user)
   - System Guardian Actor(/system)
 - It supervises or monitors those top-level Actors
 - When we run ActorSystem.terminate(), it is responsible for terminating all the available Actors automatically

### An Akka Actor's main components under-the-hood:
 - `ActorRef` - proxy for the Actor
 - `Dispatcher` (`MessageDispatcher`)
    - `takes` the incoming message (from sender - actor or non-cator)
    - `publishes` that message to its Actor's mailbox message queue 
    - `checks` whether its Actor is available or not to process that message
    - `picks up` the message `from the message queue` and `hands it over to its Actor`
    - follows the dispatcher design pattern
    - `sends` those messages to the `DeadLetter` actor (`If the required Actor is not available`)
 - `MailBox`
   - is `a message queue` for an Actor
   - `stores` incoming messages
   - acts like a queue
   - each Actor has `its own mailbox`
   - messages are `picked up, read and processed` `one-by-one` `in oder of arrival` (default)
   - mailbox `types` (default - `Unbounded and Non-blocking`)
     - Bounded/Unbounded
     - Priority
     - Blocking/Non-blocking
 - `Actor` 
   - an actual `instance` of the actor
   - encapsulates `state` and `behavior`
   - `does NOT receive messages directly` from the outside world
   - it receives messages from `ActorRef` to `dispatcher` to `itself` only.

### The lifecycle of an Akka Actor
#### Lifecycle methods managed by Actor's Supervisor:
 - `ActorSystem.actorOf()`
   - creates `top-level` Actors
 - `ActorContext.actorOf()`
   - creates `child` (subordinate) Actors
 - `Actor.receive()`
 - `Actor.preStart()`
   - is invoked
     - immediately `after creating` a new Actor
     - before moving to the `Started` state
     - If an Actor is going to be `restarted by its parent` Actor
   - this method can be `overriden`
 - `Actor.postStop()`
   - is invoked
     - immediately `after stopping` an Actor
     - before moving to the `Stopped` state
 - `Actor.preRestart()`
   - is invoked before moving to the `Restarted` state
   - Actor picks up all its subordinate Actors and stops them
   - then it invokes its `postStop()` method
 - `Actor.postRestart()`
   - when invoked, Actor enters into the `Restarted` state
   - makes a call to that Actor's `preStart()` method
 - `ActorContext.stop()` or `ActorSystem.stop()`
   - shutting down this Actor and all Children gracefully and recursively
 - `ActorSystem.terminate()`
   - shuts down the whole ActorSystem so that all of its Actors are stopped automatically

### Akka Actor Basic Operations
 - `Create` an Actor
 - `Send` messages
 - `Receive` messages
   - during receive, an actor may `change` its internal `state` and `behavior`
 - `Stop` an Actor
 - `Become`/`Unbecoming` an Actor (actual in FSM DSL context)
 - `Supervise` an Actor

### Sending messages approaches to an Actor
 - `tell` (!) function
   - `Fire and Forget` model
   - sends a message `asynchronously` and `return immediately`
 - `ask` (?) function
   - `Send and Receive` model (Ask pattern)
   - sends a message asynchronously and return `Future`
   - and retrieve results sometime in the future

### Replaying messages approaches from an Actor
 - `Actor-to-Actor` communication
   - sender(): ActorRef
 - `Actor-to-non-Actor` communication
   - when there is no `sender` and when akka actor tries to send a message, then the message goes to the `DeadLetter`