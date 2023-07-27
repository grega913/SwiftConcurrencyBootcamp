//
//  AsyncAwaitBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by gs on 27/07/2023.
//

import SwiftUI


// MARK: NOTES
/*
 Just because we are in a task, using await, in an asynchronous environment, does not mean we are in a different thread than the main.
 It might mean that, and often it does, but not always.
 So it is a good idea to switch to the MainActor before updating UI.
 
 
 */

class AsyncAwaitBootcampViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    
    func addTitle1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { self.dataArray.append("Title1 : \(Thread.current)")

        }
    }
    
    func addTitle2() {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let title = "Title2 : \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title)
                
                let title3 = "Title3: \(Thread.current)"
                self.dataArray.append(title3)
            }
        }
    }
    
    func addAuthor1() async {
        print("func addAuthor1")
        let author1 = "Author1: \(Thread.current)"
        self.dataArray.append(author1)
        
        print("before waiting 2 secs in addAuthor1")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        print("after waiting 2 secs in addAuthor1")
        
        let author2 = "Author2: \(Thread.current)"
        self.dataArray.append(author2)
        
        //using main actor in async function do that we go back to main threa
        await MainActor.run(body: {
            let author3 = "Author3: \(Thread.current)"
            self.dataArray.append(author3)
        })
       
        await addSomething()
        
    }
    
    
    func addSomething() async {
        
        print("func addSomething")
        print("before waiting 2 secs in addSomething")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        print("after waiting 2 secs in addSomething")
        let something1 = "Something1 :\(Thread.current)"
        await MainActor.run(body: {
            self.dataArray.append(something1)
            
            let something2 = "Something2 : \(Thread.current)"
            self.dataArray.append(something2)
            
        })
        
        
    }
    
    
}




struct AsyncAwaitBootcamp: View {
    
    @StateObject private var viewModel = AsyncAwaitBootcampViewModel()
    
    
    var body: some View {
        List {
            ForEach(viewModel.dataArray, id: \.self) { data in
                Text(data)
            }
        }
        .onAppear {
            //viewModel.addTitle1()
            //viewModel.addTitle2()
            Task {
                await viewModel.addAuthor1()
                
                let finalText = "FINAL TEXT: \(Thread.current)"
                viewModel.dataArray.append(finalText)
            }
        }
    }
}

struct AsyncAwaitBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwaitBootcamp()
    }
}
