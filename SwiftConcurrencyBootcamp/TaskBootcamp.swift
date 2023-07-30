//
//  TaskBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by gs on 29/07/2023.
//

import SwiftUI



// MARK: VIEWMODEL


class TaskBootcampViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    
    func fetchImage() async {
        
        try? await Task.sleep(for:.seconds(5))

        do {
        
            guard let url = URL(string: "https://picsum.photos/500") else { return }
            let (data, _) =  try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run(body: {
                self.image = UIImage(data:data)
                print("IMAGE RETURNED SUCCESSFULLY")
                
            })
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func fetchImage2() async {
        
        do {
            
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, response) =  try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run(body: {
                self.image2 = UIImage(data:data)
                print("IMAGE RETURNED")
                
            })
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
}


/*
 We can use .onAppear {
    Task {
        viewModel.fetchImage()
    }
 }
 
 or
 .task {
  viewModel.fetchImage()
 }
 */


// MARK: VIEW

struct TaskBootcamp: View {
    
    @StateObject private var viewModel = TaskBootcampViewModel()
    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack (spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }

        .task {
            await viewModel.fetchImage()
        }
        /*
        .onDisappear {
            fetchImageTask?.cancel()
        }
        */
        //in order to call an async function we need to be in the Task
        /*
        .onAppear {
            /*
             these 2 tasks are not running simoultaneously
            Task {
                await viewModel.fetchImage()
                await viewModel.fetchImage2()//waiting for upper to be completed
            }
            */
            
            // these 2 task are running at the same time
            // when you create a task, you can set a priority
            /*
            Task {
                print(Thread.current)
                print(Task.currentPriority)
                await viewModel.fetchImage()
            }

            Task {
                print(Thread.current)
                print(Task.currentPriority)
                await viewModel.fetchImage2()//not waiting for task1 to be completed
            }
            */
            /* Bunch of Tasks running on the same thread
             sleep - - pu a task to a hold
             yield - wait for other task to complete
             */
            
            Task(priority: .high) {
                //try? await Task.sleep(nanoseconds: 2_000_000_000)
                await Task.yield()
                print("HIGHT: \(Thread.current) : \(Task.currentPriority)")
            }
            Task(priority: .userInitiated) {
               
                print("USERINITIATED: \(Thread.current) : \(Task.currentPriority)")
            }
 
            Task(priority: .medium) {
                print("MEDIUM: \(Thread.current) : \(Task.currentPriority)")
            }
            Task(priority: .low) {
                print("LOW: \(Thread.current) : \(Task.currentPriority)")
            }
            Task(priority: .utility) {
                print("UTILITY: \(Thread.current) : \(Task.currentPriority)")
            }

            Task(priority: .background) {
                print("BACKGROUND: \(Thread.current) : \(Task.currentPriority)")
            }
            
            
            // How to cancel a task??
            
            fetchImageTask = Task {
                print(Thread.current)
                print(Task.currentPriority)
                await viewModel.fetchImage()
            }
            


            

        }
         */
    }
}


struct TaskBootcampHomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                NavigationLink("CLICK ME! 🌈") {
                    TaskBootcamp()
                }
            }
        }
    }
}





// MARK: PREVIEW

struct TaskBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TaskBootcamp()
    }
}
