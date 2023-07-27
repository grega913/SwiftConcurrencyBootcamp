//
//  DownloadImageAsync.swift
//  SwiftConcurrencyBootcamp
//
//  Created by gs on 27/07/2023.
//

import SwiftUI
import Combine



//downloading done with 3 different ways
class DownloadImageAsyncImageLoader {
    
    let url = URL(string: "https://picsum.photos/200")!
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
                return nil
        }
        
        return image
    }
    
    
    func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            let image = self?.handleResponse(data: data, response: response)
            completionHandler(image, error)
            }
            .resume()
    }
    
    
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError({ $0 })
            .eraseToAnyPublisher()
    }
    
    
    // mark the function with async keyword -> support concurrency
    func downloadWithAsync() async throws  -> UIImage?{
        print("loader.downloadWithAsync")

        do {
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            let image = handleResponse(data: data, response: response)
            return image
        } catch {
            throw error
        }
        
    }
    
}


class DownloadImageAsyncViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    let loader = DownloadImageAsyncImageLoader()
    var cancellables = Set<AnyCancellable>()
    
    
    //often you're not gonna do fetching from a viewmodel, but from an outside class
    // manager, data loader image loader, ...
    
    func fetchImageWithEscaping() {
        print("fetchImageWithEscaping")
        //self.image = UIImage(systemName: "heart.fill")
        loader.downloadWithEscaping { [weak self] image, error in
            /*if let image = image {
                self?.image = image
            }
             */
            DispatchQueue.main.async {
                self?.image = image
            }
            
        }
        
    }
    
    func fetchImageWithCombine() {
        print("fetchImageWithCombine")
        
        loader.downloadWithCombine()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] image in
                
                /*DispatchQueue.main.async {
                    self?.image = image
                }
                 */
                self?.image = image
            }
            .store(in: &cancellables)
        
    }
    
    
    func fetchImageAsync() async {
        print("fetchImageAsync")
        
        
        let image = try? await loader.downloadWithAsync()
        
        //Publishing changes from background threads is not allowed . . . make sure
        // since we are in async function, we should start using actors
        
        
        await MainActor.run {
            self.image = image
        }
        
    }
    

    
    
}

struct DownloadImageAsync: View {
    
    @StateObject private var viewModel = DownloadImageAsyncViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width:250, height:250)
                    
            }
        }
        .onAppear {
            //viewModel.fetchImageWithEscaping() -
            //viewModel.fetchImageWithCombine()
            
            // how to support async context here . . by starting a task and awaiting
            Task {
                await viewModel.fetchImageAsync()
            }
            
        }
        
        
    }
}

struct DownloadImageAsync_Previews: PreviewProvider {
    static var previews: some View {
        DownloadImageAsync()
    }
}
