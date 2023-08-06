//
//  AsyncPublisherBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by gs on 06/08/2023.
//
/*
 Async publisher is just like subscribing to publisher
 */

import SwiftUI
import Combine


class AsyncPublisherDataManager {
    
    @Published var myData: [String] = []
    
    func addData() async  {
        myData.append("Apple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Banana")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Melon")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Orange")
    }
    
}


class AsyncPublisherBootcampViewModel: ObservableObject {
    
    @MainActor @Published var dataArray: [String] = []
    let manager = AsyncPublisherDataManager()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers()  {
        
        Task {
            
            //async publishers . . never end
            for await value in manager.$myData.values {
                await MainActor.run(body: {
                    self.dataArray = value
                })
            }
        }
    }
    
    func start() async {
        //since it is inside the actor
        await manager.addData()
        
    }
    
}


struct AsyncPublisherBootcamp: View {
    
    @StateObject private var viewModel = AsyncPublisherBootcampViewModel()
    
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
            await viewModel.start()
        }
    }
}

struct AsyncPublisherBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncPublisherBootcamp()
    }
}
