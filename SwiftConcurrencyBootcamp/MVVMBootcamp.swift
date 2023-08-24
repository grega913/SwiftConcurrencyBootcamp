//
//  MVVMBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by gs on 06/08/2023.
//

import SwiftUI



final class MyManagerClass {
    func getData() async throws -> String {
        "Some data from manager class!"
    }
    
}

actor MyManagerActor {
    func getData() async throws -> String {
        "Some data from manager actor!"
    }
    
}

// for most functions we are keeping/managing Tasks in viewModel
@MainActor
final class MVVMBootcampViewModel: ObservableObject {
    
    let managerClass = MyManagerClass()
    let managerActor = MyManagerActor()
    
    
    @Published private(set) var myData: String = "Starting Text"
    private var tasks: [Task<Void, Never>] = []
    
    func cancelTasks() {
        print("func viewModel.cancelTask")
        tasks.forEach({ $0.cancel() })
        tasks = []
    }
    
    
    func onCallToActionButtonPressed() {
    print("viewmodel.onCallToActionButtonPressed")
      let task = Task {
          
          do {
              //myData = try await managerActor.getData()
              myData = try await managerActor.getData()// when we come back from this await it will return to the actor it was called on
          } catch {
              print(error)
          }
          
            
        }
        tasks.append(task)
    }
    
}


// anything that updates the UI, needs to be on the main actor

// keep functions in a view synchronous
struct MVVMBootcamp: View {
    
    @StateObject private var viewModel = MVVMBootcampViewModel()
    
    var body: some View {
        
        Button(viewModel.myData) {
            viewModel.onCallToActionButtonPressed()
        }
        .onAppear {
            print("func view.onAppear")
        }
        .onDisappear {
            print("func view.onDisappear")
            viewModel.cancelTasks()
        }
         

    }
}

struct MVVMBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        MVVMBootcamp()
    }
}
