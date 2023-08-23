//
//  RefreshableBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by gs on 06/08/2023.
//

import SwiftUI



final class refreshableDataService {
    
    func getData() async throws -> [String] {
        print("getData before sleep")
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        print("after sleep")
        return ["Apple", "Orange", "Banana"].shuffled()
    }
}


@MainActor
final class RefreshableBootcampViewModel: ObservableObject {
    
    @Published private(set) var items: [String] = []
    let manager = refreshableDataService()
    
    
    func loadData() {
        Task {
            do {
                items = try await manager.getData()
            } catch {
                print(error)
            }
        }
        
    }
    
    func loadDataAs() async {
      
            do {
                items = try await manager.getData()
            } catch {
                print(error)
            }
   
        
    }
    
    
}

struct RefreshableBootcamp: View {
    
    @StateObject private var viewModel = RefreshableBootcampViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(viewModel.items, id: \.self) { item in
                        Text(item)
                            .font(.headline)
                    }
                }
            }
            .refreshable{
                await viewModel.loadDataAs()
            }
            .navigationTitle("Refreshable")
            .onAppear{
                viewModel.loadData()
            }
        }
   }
}

struct RefreshableBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        RefreshableBootcamp()
    }
}
