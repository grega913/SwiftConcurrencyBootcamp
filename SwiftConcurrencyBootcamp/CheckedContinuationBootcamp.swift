//
//  CheckedContinuationBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by gs on 01/08/2023.
//

/* Convert sync function into async await
 
 
 */


import SwiftUI


class CheckedContinuationBootcampNetworkManager {
    
    func getData(url:URL) async throws -> Data {
        do {
          let (data, _) =  try await URLSession.shared.data(from: url, delegate: nil)
            return data
        } catch  {
            throw error
        }
    }
    
    // the way dataTask work is that you set it up and then need to resume it to execute it
    func getData2(url:URL) async throws -> Data {
       return try await withCheckedThrowingContinuation { continuation in //we are suspending the task
           URLSession.shared.dataTask(with: url) { data, response, error in
               if let data = data { // if we get data, we will resume the continuation
                   continuation.resume(returning: data)
               } else if let error = error {
                   continuation.resume(throwing: error)
               } else {
                   continuation.resume(throwing: URLError(.badURL))
               }
           }
           .resume()
            
        }
    }
    
    // before using continuation
    
    func getHeartImageFromDatabase(completionHandler: @escaping (_ image: UIImage) -> ()) {
        print("getHeartImageFromDatabase")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            print("after 5 secs")
            completionHandler(UIImage(systemName: "heart.fill")!)
        }
    }
    
    
    func getHeartImageFromDatabase() async -> UIImage {
        
       await withCheckedContinuation { continuation in
           print("manager.getHeartImageFromDatabase")
            getHeartImageFromDatabase { image in
                continuation.resume(returning: image)
            }
            
        }
    }

    
    
    
}


class CheckedContinuationBootcampViewModel: ObservableObject {
    
    @Published var image : UIImage? = nil
    let networkManager = CheckedContinuationBootcampNetworkManager()
    
    func getImage() async {
        guard let url = URL(string: "https://picsum.photos/300") else { return }
        
        do {
          let data = try await networkManager.getData2(url: url)
            if let image = UIImage(data:data) {
                await MainActor.run(body: {
                    self.image = image
                })
            }
        } catch  {
            print(error)
        }
        
    }
    
    
    func getHeartImage() async {
        
        self.image = await networkManager.getHeartImageFromDatabase()
        
    }
    
}

struct CheckedContinuationBootcamp: View {
    
    @StateObject private var viewModel = CheckedContinuationBootcampViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage:image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
        }
        .task {
            //await viewModel.getImage()
            await viewModel.getHeartImage()
        }
    }
}

struct CheckedContinuationBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CheckedContinuationBootcamp()
    }
}
