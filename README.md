```shell
 find ./ -name "*.rb" | xargs -I {} sudo chmod +x {}
```



#### [Five.rb](./week2/Five.rb) pipline

#### [Five.rb](./week2/Six.rb) Code Golf.
 As few lines of code as possible.
#### [Eight.rb](./week3/Seven.py) Lambda
Lambda
#### [Eight.rb](./week3/Eight.rb)
 Kick Forward
- Each function takes an additional parameter, usually the last, which is another function.
- That function parameter is applied at the end of the current function.
- That function parameter is given, as input, what would be the output of the current function.
- The larger problem is solved as a pipeline of functions, but where the next function to be applied is given as parameter to the current function.

#### [Nine.rb](./week3/Nine.rb) The One
- Existence of an abstraction to which values can be converted.
- This abstraction provides operations to (1) wrap around values, so that they become the abstraction; (2) bind itself to functions, so to establish sequences of functions; and (3) unwrap the value, so to examine the final result.
- Larger problem is solved as a pipeline of functions bound together, with unwrapping happening at the end.
- Particularly for The One style, the bind operation simply calls the given function, giving it the value that it holds, and holds on to the returned value.

#### [Ten.rb](./week4/Ten.rb) Things
- The larger problem is decomposed into things that make sense for the problem domain.
- Each thing is a capsule of data that exposes procedures to the rest of the world.
- Data is never accessed directly, only through these procedures.
- Capsules can reappropriate procedures defined in other capsules.

#### [Eleven.rb](./week4/Eleven.rb) Letterbox
- The larger problem is decomposed into things that make sense for the problem domain.
- Each thing is a capsule of data that exposes one single procedure, namely the ability to receive and dispatch messages that are sent to it.
- Message dispatch can result in sending the message to another capsule.

#### [Twelve.rb](./week4/Twelve-1.rb) Closed Maps
- The larger problem is decomposed into things that make sense for the problem domain.
- Each thing is a map from keys to values. Some values are procedures/functions.
- The procedures/functions close on the map itself by referring to its slots.


#### [15.rb](./week4/Fourteen-1.rb) Hollywood

- Larger problem is decomposed into entities using some form of abstraction (objects, modules or similar).
- The entities are never called on directly for actions.
- The entities provide interfaces for other entities to be able to register callbacks.
- At certain points of the computation, the entities call on the other entities that have registered for callbacks.

#### [Sixteen.rb](./week5/Sixteen.rb) Introspective
- The problem is decomposed using some form of abstraction (procedures, functions, objects, etc.).
- The abstractions have access to information about themselves and others, although they cannot modify that information.

#### [Nineteen.rb](./week5/Nineteen.rb) Plugins

- The problem is decomposed using some form of abstraction (procedures, functions, objects, etc.).
- All or some of those abstractions are physically encapsulated into their own, usually pre-compiled, packages. Main program and each of the packages are compiled independently. These packages are loaded dynamically by the main program, usually in the beginning (but not nec- essarily).
- Main program uses functions/objects from the dynamically-loaded pack- ages, without knowing which exact implementations will be used. New implementations can be used without having to adapt or recompile the main program.
- Existence of an external specification of which packages to load. This can be done by a configuration file, path conventions, user input or other mechanisms for external specification of code to be loaded at runtime.

#### [TwentyEight.rb](./week6/TwentyEight.rb) Actors
- The larger problem is decomposed into things that make sense for the problem domain.
- Each thing has a queue meant for other things to place messages in it.
- Each thing is a capsule of data that exposes only its ability to receive messages via the queue.
- Each thing has its own thread of execution independent of the others.

#### [TwentyNine.rb](./week6/TwentyNine.rb) Dataspaces
- Existence of one or more units that execute concurrently.
- Existence of one or more data spaces where concurrent units store and retrieve data.
- No direct data exchanges between the concurrent units, other than via the data spaces.

#### [Thirty.rb](./week6/Thirty.rb) Map Reduce

- Input data is divided in blocks.
- A map function applies a given worker function to each block of data, potentially in parallel.
- A reduce function takes the results of the many worker functions and recombines them into a coherent output.

#### [ThirtyOne.rb](./week6/ThirtyOne.rb) Double Map Reduce

- Input data is divided in blocks.
- A map function applies a given worker function to each block of data, potentially in parallel.
- The results of the many worker functions are reshuffled.
- The reshuffled blocks of data are given as input to a second map function that takes a reducible function as input.
- Optional step: a reduce function takes the results of the many worker functions and recombines them into a coherent output.

#### [TwentyFive.rb](./week7/TwentyFive.rb) Persistent Tables

- The data exists beyond the execution of programs that use it, and is meant to be used by many different programs.
- The data is stored in a way that makes it easier/faster to explore. For example:
   - The input data of the problem is modeled as one or more series of domains, or types, of data.
   - The concrete data is modeled as having components of several domains, establishing relationships between the application’s data and the domains identified.
- The problem is solved by issuing queries over the data.


#### [TwentySix.rb](./week7/TwentySix.rb) Spreadsheet
- The problem is modeled like a spreadsheet, with columns of data and formulas.
- Some data depends on other data according to formulas. When data changes, the dependent data also changes automatically.

#### [TwentySeven.rb](./week7/TwentySeven.rb) Lazy Rivers

- Data is available in streams, rather than as a complete whole.
- Functions are filters/transformers from one kind of data stream to another.
- Data is processed from upstream on a need basis from downstream.