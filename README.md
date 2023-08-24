# SwiftConcurrencyBootcamp
Swift Concurrency as in SwiftFul>Thinking https://www.youtube.com/playlist?list=PLwvDm4Vfkdphr2Dl4sY4rS9PLzPdyi8PM
Just a bit of traning in Git and Github. Haven't been here for a long time.

## 1. Learn Swift Concurrency (Async, Await, Actors) online for FREE | Swift Concurrency #0
- 00:00 - Intro
- 00:34 - What is Swift Concurrency  - before we used @escaping and combine
- 1:45 - Safety Nets
- 2:59 - Swift Language

## 2. How to use Do, Try, Catch, and Throws in Swift | Swift Concurrency #1

## 3. Download images with Async/Await, @escaping, and Combine | Swift Concurrency #2

## 4. How to use async / await keywords in Swift | Swift Concurrency #3
 Just because we are in a task, using await, in an asynchronous environment, does not mean we are in a different thread than the main. It might mean that, and often it does, but not always.
 So it is a good idea to switch to the MainActor before updating UI.

## 5. How to use Task and .task in Swift | Swift Concurrency #4
## 6. How to use Async Let to perform concurrent methods in Swift | Swift Concurrency #5
 Async let . . a sort of asynchronous constant
 Great for executing multiple asynchronous functions at once and then awaiting the result of all
 those functions at the same time.
  - a lot of code
  - not scallable
  - up to 3 requests, if more, other ways to do it -> Task Groups maybe . . next video

## 7. How to use TaskGroup to perform concurrent Tasks in Swift | Swift Concurrency #6
 If a function can throw, then we need to use try keyword when called.
 WithTrowingTaskGroup - using when function throws errors
 Running 5 async fetch request concurrently at the same time.

## 8. How to use Continuations in Swift (withCheckedThrowingContinuation) | Swift Concurrency #7
Convert code that is not compatible with async await into code that is compatible with async await(Swift concurency).
Using CheckedContinuation -> CheckedContinuation Bootcamp
WithCheckedThrowingContinuation -> You must resume the continuation exactly once.

## 9. Swift: Struct vs Class vs Actor, Value vs Reference Types, Stack vs Heap | Swift Concurrency #8
 Value types vs. reference types
 
 The most important difference between structures and classes is that structures are value types, while classes are reference types. This means that when you copy a structure, you are copying the actual data of the structure. When you copy a class, you are only copying a reference to the class instance.
 
 Struct have default initializers, at classes we need to give them actual initializers!
 
 Actors are more or less the same as classes, but hey are thread safe!
 Both classes and actors are stored in the heap!
 
 
 
 VALUE TYPES:
  - Struct, Enum, String, Int, ...
  - Stored in the Stack
  - Faster
  - Thread safe
  - When you assign or pass value type a new copy of data is created.
 
 REFERENCE TYPES
  - Class, Function, Actor
  - Stored in the Heap
  - Slower, but synchronized
  - Not thread-safe
  - When you assign or pass a reference type a new reference to original instance3 will be created. This reference is called pointer.
  
 - - - - - - -
 
 STACK:
  - Stored value types
  - Variables allocated on the stack are sored directly to the memory, and access to this memory is very fast.
  - Each thread has its own stack.
 
  HEAP:
  - Stores reference types
  - Shared accross threads!
 
  - - - - - - - -
 
 STRUCT:
  - Based on values
  - Can be mutated
  - Stored in the Stack
 
  CLASS:
  - Based on References (Instances)
  - Stored in the Heap
  - Classes can inherit from other classes
 
  ACTOR:
  - Same as class but thread safe! Because of that we need to be in asynchronous environment.
 
  - - - - - - - - -
 
  Structs: used in our Data Models, Views
  Classes: viewModels -> ObservableObject - we need instance so that we can change objects inside
  Actors:  dataManagers . . Shared "Managers" and "DataStore"  - shared classes that are gonna be accessed from accross the app

  ## 10. How to use Actors and non-isolated in Swift | Swift Concurrency #9

  ## 11. How to use Global Actors in Swift (@globalActor) | Swift Concurrency #10

  ## 12. What is the Sendable protocol in Swift? | Swift Concurrency #11

  ## 13. How to use AsyncPublisher to convert @Published to Async / Await | Swift Concurrency #12

  ## 14. How to manage strong & weak references with Async Await | Swift Concurrency #13

  ## 15. How to use MVVM with Async Await | Swift Concurrency #14
  UI should remain synchronous. Put async code (Tasks) into ViewModel.
  For most functions we are keeping/managing Tasks in viewModel

  ## 16. How to use Refreshable modifier in SwiftUI | Swift Concurrency #15

  ## 17. How to use Searchable, Search Suggestions, Search Scopes in SwiftUI | Swift Concurrency #16

  ## 18. How to use PhotosPicker in SwiftUI & PhotosUI | Swift Concurrency #17

  

  

  

  
  

  

  

  
