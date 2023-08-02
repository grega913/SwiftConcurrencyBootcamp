//
//  StructClassActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by gs on 02/08/2023.
//

/*
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
  - Not htread-safe
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
 
 
 */





import SwiftUI




actor StructClassActorBootcampDataManager {
    
    func getDataFromDatabase() {
        
    }
}


class StructClassBootcampViewModel: ObservableObject {
    
    @Published var title: String = ""
    
    init() {
        print("ViewModel INIT")
    }
    
}



struct StructClassActorBootcampHomeView: View {
    
    @State private var isActive: Bool = false
    
    
    
    var body: some View {
        StructClassActorBootcamp(isActive: isActive)
            .onTapGesture {
                isActive.toggle()
            }
    }
    
    
}



struct StructClassActorBootcamp: View {
    
    @StateObject private var viewModel = StructClassBootcampViewModel()
    let isActive: Bool
    
    
    // every time this boolean changes, we are re runing this init
    init(isActive: Bool) {
        self.isActive = isActive
        print("View INIT")
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(isActive ? .red : .blue)
        
            .onAppear {
              runTest()
            }
    }
}

struct StructClassActorBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        StructClassActorBootcamp(isActive: true)
    }
}






extension StructClassActorBootcamp {
    
    private func runTest()  {
        print("Test started")
        structTest1()
        printDivider()
        classTest1()
        printDivider()
        actorTest1()

        
//        structTest2()
//        printDivider()
//        classTest2()
    }
    
    private func printDivider() {
        print ("""

 - - - - - - - - - - - - - - - - - - - -

""")
    }
    
    private func structTest1() {
        
        print("structTest1")
        let objectA = MyStruct(title: "Starting title!")
        print("ObjectA: ", objectA.title)
        
        print("Pass the VALUES of objectA to objectB.")
        var objectB = objectA
        print("ObjectB: ", objectB.title)
        
        objectB.title = "Secong Title"
        print("ObjectB title changed")
        
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
        
    }
    
    private func classTest1() {
        print("classTest1")
        let objectA = MyClass(title: "Starting title!")
        print("ObjectA: ", objectA.title)
        
        print("Pass the REFERENCE of objectA to objectB.")
        
        
        let objectB = objectA
        print("ObjectB: ", objectB.title)
        
        objectB.title = "Secong Title"
        print("ObjectB title changed")
        
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
        
    }
    
    
    
    private func actorTest1()  {
        Task {
            print("actorTest1")
            let objectA = MyActor(title: "Starting title!")
            await print("ObjectA: ", objectA.title)
            
            print("Pass the REFERENCE of objectA to objectB.")
            
            
            let objectB = objectA
            await print("ObjectB: ", objectB.title)
            
            //objectB.title = "Secong Title" //we cannot do this since we cann not mutate property title fron non-isolated env
            
            await objectB.updateTitle(newTitle: "Second title")
            print("ObjectB title changed")
            
            await print("ObjectA: ", objectA.title)
            await print("ObjectB: ", objectB.title)
        }
    }
        
        


        
    
    
    
    
    
}


struct MyStruct {
    var title: String
}


// Immutable struct. . data inside will not change
struct CustomStruct {
    let title: String
    
    func updateTitle(newTitle: String) -> CustomStruct {
        CustomStruct(title: newTitle)
    }
}

// Mutable Struct
struct MutatingStruct {
    private (set) var title: String //set if from inside, but can get it anywhere
    
    init(title: String) {
        self.title = title
    }
    
    mutating func updateTitle(newTitle: String) {
        title = newTitle
    }
}


extension StructClassActorBootcamp {
    
    private func structTest2() {
        print("structTest2")
        
        var struct1  = MyStruct(title: "Title1")
        print("Struct1: ", struct1.title)
        
        struct1.title = "Title2"
        print("Struct1: ", struct1.title)
        
        var struct2 = CustomStruct(title: "Title1")
        print("Struct2: ", struct2.title)
        struct2 = CustomStruct(title: "Title2")
        print("Struct2: ", struct2.title)
        
        
        
        var struct3 = CustomStruct(title: "Title1")
        print("Struct3: ", struct3.title)
        struct3 = struct3.updateTitle(newTitle: "Title2")
        print("Struct3: ", struct3.title)
        
        var struct4 = MutatingStruct(title: "Title1")
        print("Struct4: ", struct4.title)
        struct4.updateTitle(newTitle: "Title2")
        print("Struct4: ", struct4.title)
        
        
        
        
        
        
        
    }
}


class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }

    //in Class we don't call mutate . . just changing the class directly
    func updateTitle(newTitle: String) {
        title = newTitle
    }
    
}


// the difference is the keyword and the await keyword
actor MyActor {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    //in Class we don't call mutate . . just changing the class directly
    func updateTitle(newTitle: String) {
        title = newTitle
    }
    
}


extension StructClassActorBootcamp {
    
    private func classTest2() {
        print("classTest2")
        
        let class1 = MyClass(title: "Title1")
        print("Class1: ", class1.title)
        class1.title = "Title2"
        print("Class1: ", class1.title)
        
        let class2 = MyClass(title: "Title1")
        print("Class2: ", class2.title)
        class2.updateTitle(newTitle: "Title2")
        print("Class2: ", class2.title)
        
        
        
    }
    
}
