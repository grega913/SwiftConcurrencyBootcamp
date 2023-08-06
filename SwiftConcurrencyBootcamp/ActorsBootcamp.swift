//
//  ActorsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by gs on 04/08/2023.
//

import SwiftUI


/*
 1. What is the problem that actors  are solving?
 2. How was this problem solved prior to the actors?
 3. Solving the problem with actors.
 */

// Edit scheme - Diagnostics -

/*
2 places in our code that are accessing the same class from differenct Class
how to make a class safe?
 */



class MyDataManager {
    static let instance = MyDataManager()
    
    private init() {}
    
    var data:[String] = []
    
    //before actors . . create custom DispatchQueue
    private let lock = DispatchQueue(label: "com.MyApp.MyDataManager")
    
    
    
    // old time solution to make a class thread save
    func getRandomData(completionHandler: @escaping(_ title: String?) -> ())  {
        lock.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            //return data.randomElement()
            completionHandler(self.data.randomElement())
        }
    }
    
    //to achieve that same, we can use actors
    // because we are in the async swift environment we don't have to use completionhandlers
}


// everytime we want to access the actor we need to await to get into the actor
// because code inside the actor is isolated
actor MyActorDataManager {
    static let instance = MyActorDataManager()
    
    private init() {}
    
    var data:[String] = []
    
    
    // old time solution to make a class thread save
    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        print(Thread.current)
        return self.data.randomElement()
    }
    
    
    // but if we want to access funtion and does not want to wait on actor with await
    // we can mark a function as nonisolated
    
    nonisolated func getSavedData() -> String {
        return "NewData"
    }
    
    //to achieve that same, we can use actors
    // because we are in the async swift environment we don't have to use completionhandlers
}




struct HomeView: View {
    
    
    //let manager = MyDataManager.instance
    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
    
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
            }
        .onAppear {
            let newString = manager.getSavedData()
        }
        .onReceive(timer) { _ in
           
            //to access the actor ae need to use Task (async) and await
            
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run(body: {
                        self.text = data
                    })
                }
            }
            
                
        }
    }
    
}

struct BrowseView: View {
    
    //let manager = MyDataManager.instance
    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.01, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
            
            
        }
        .onReceive(timer) { _ in
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run(body: {
                        self.text = data
                    })
                }
            }
            
        }
    }
    
}

struct ActorsBootcamp: View {
    var body: some View {
        TabView{
            HomeView()
                .tabItem{
                    Label("Home", systemImage: "house.fill")
                }
            
            BrowseView()
                .tabItem{
                    Label("Browse", systemImage: "magnifyingglass")
                }
        }
        
    }
}

struct ActorsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ActorsBootcamp()
    }
}
