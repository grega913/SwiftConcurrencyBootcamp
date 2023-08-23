//
//  StrongSelfBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by gs on 06/08/2023.
//

import SwiftUI



final class StrongSelfDataService {
    
    func getData() async -> String {
        "Updated data!"
    }
    
}



class StrongSelfBootcampViewModel: ObservableObject {
    
    @Published var data: String = "Some title!"
    let dataService = StrongSelfDataService()
    
    private var someTask: Task<Void, Never>? = nil
    private var myTasks: [Task<Void, Never>] = []
    
    func cancelTasks() {
        someTask?.cancel()
        // or someTask = nil
        
        myTasks.forEach({$0.cancel()})
        myTasks = []
    }
    
    
    // This implies a strong reference . . .
    func updateData() {
        Task {
            data = await dataService.getData()
        }
    }
    
    // This implies a strong reference . . .
    // It is same as above . . we are using self.data just to make sure we are referencing a class and not maybe a function param with potentially the same name
    func updateData2() {
        Task {
            self.data = await dataService.getData()
        }
    }
    
    // A strong reference to self in this closure
    func updateData3() {
        Task { [self] in
            self.data = await dataService.getData()
        }
    }
    
    // This is a weak reference
    func updateData4() {
        Task { [weak self] in
            if let data = await self?.dataService.getData() {
                self?.data = data
            }
            
        }
    }
    
    // All references are now in Task
    
    // We don't need to manage weak/strong because we can manage the task.
    func updateData5() {
        someTask = Task {
            self.data = await self.dataService.getData()
        }
    }
    

    
    func updateData6() {
        let task1 = Task {
            self.data = await self.dataService.getData()
        }
        myTasks.append(task1)
        
        let task2 = Task {
            self.data = await self.dataService.getData()
        }
        myTasks.append(task2)
        
    }
    
    // We purposely do not cancel tasks to keep strong references
    func updateData7() {
        Task {
            self.data = await self.dataService.getData()
        }
        
        Task.detached {
            self.data = await self.dataService.getData()
        }
    }
    
    func updateData8() async {
        self.data = await self.dataService.getData()
    }
    
    
}


struct StrongSelfBootcamp: View {
    
    @StateObject private var viewModel = StrongSelfBootcampViewModel()
    
    var body: some View {
        Text(viewModel.data)
            .onAppear {
                viewModel.updateData()
            }
            .onDisappear {
                viewModel.cancelTasks()
            }
            .task {
                await viewModel.updateData8()
            }
    }
}

struct StrongSelfBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        StrongSelfBootcamp()
    }
}
