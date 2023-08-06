//
//  GlobalActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by gs on 05/08/2023.
//

import SwiftUI


@globalActor struct MyFirstGlobalActor {
    
    static var shared = MyNewDataManager()
    
}



actor MyNewDataManager {
    
    func getDataFromDatabase() -> [String] {
        
        return ["One", "Two", "Three", "Four","Five"]
        
    }
    
}

// having a shared instance is the same as having the singleton


@MainActor
class GlobalActorBootcampViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    //let manager = MyNewDataManager()
    let manager = MyFirstGlobalActor.shared
    
    //@MyFirstGlobalActor func getData() {
     // or
    func getData() {
        
        //we can mark the class as MainActor if all variables are on the mainActor
        
        
        // HEAVY COMPLEX METHOD -> Do not want them to run on main thread

//        let data = await manager.getDataFromDatabase()
//        self.dataArray = data
        
        Task {
            let data = await manager.getDataFromDatabase()
            self.dataArray = data
        }
    }
    
}

struct GlobalActorBootcamp: View {
    
    
    @StateObject private var viewModel = GlobalActorBootcampViewModel()
    
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.getData()
        }
    }
}

struct GlobalActorBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        GlobalActorBootcamp()
    }
}
