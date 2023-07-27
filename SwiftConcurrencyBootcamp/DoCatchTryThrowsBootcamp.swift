//
//  DoCatchTryThrowsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by gs on 27/07/2023.
//

import SwiftUI

// do-catch
// try
// throws

/*
 Instead of returning nil from a function we might be returning error instead
 Let's return 2 pieces od data - a title? and a error?
 
 
 */

class DoCatchTryThrowsBootcampDataManager {
    
    let isActive: Bool = true
    
//    func getTitle() -> String? {
//        if isActive {
//            return "NEW TEXT"
//        } else {
//            return nil
//        }
//    }
    
    func getTitle() -> (title:String?, error: Error?) {
            if isActive {
                return ("NEW TEXT", nil)
            } else {
                return (nil, URLError(.badURL))
            }
        }
    
    
    
    
    // we get result - either success or error, but we need to check wheter we received success or failure
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("NEW TEXT")
        } else {
            return .failure(URLError(.badURL))
        }
    }
    
    /*
     if we add throws to the function, this means it can throw an error
     how to read this function: Function that tries to return us a string, but if it
     fails, it will throw us an error
     */
    func getTitle3() throws -> String {
        if isActive {
            return "NEW TEXT"
        } else {
            throw URLError(.badURL)
        }
    }
    
    
    func getTitle4() throws -> String {
        if isActive {
            return "FINAL TEXT"
        } else {
            throw URLError(.badURL)
        }
    }
    
    
}


class DoCatchTryThrowsBootcampViewModel: ObservableObject {
    
    @Published var text: String = "Starting text."
    let manager = DoCatchTryThrowsBootcampDataManager()
    
    func fetchTitle () {
       /* v1
       let newTitle = manager.getTitle()
            if let newTitle = newTitle {
            self.text = newTitle
        }
        */
        
        /* v2
        let returnedValue = manager.getTitle()
        if let newTitle = returnedValue.title {
            self.text = newTitle
        } else if let error = returnedValue.error {
            self.text = error.localizedDescription
        }
         */
        
        
        // with getTitle2
        /*
        let result = manager.getTitle2()
        
        switch result {
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }
         */
          
        // with getTitle3
        /*we need to try to call the function, but if not succeed we need a place to catch the errors
        
        do {
            let newTitle = try manager.getTitle3()
            self.text = newTitle
        //} catch let error {
        } catch {
            self.text = error.localizedDescription
        }
        
        
         in do block we have all the functions that can throw an error
         if any of the try blocks fail, no next statements get executed -> we get to the catch statement, where we even don't have to give the error a local name
         */
        
        // with getTitle4
        /*
         if try? is optional, we don't care about the error, it will not send us to catch block
         */
        do {
            let newTitle = try? manager.getTitle3()
            if let newTitle = newTitle {
                self.text = newTitle
            }
            

            
            let finalTitle = try manager.getTitle4()
            self.text = finalTitle
        } catch {
            self.text = error.localizedDescription
        }
        
        /*
         When using throws, we are almost always using do catch statements
         */
        
        
    }
    
}


struct DoCatchTryThrowsBootcamp: View {
    
    @StateObject private var viewModel = DoCatchTryThrowsBootcampViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

struct DoCatchTryThrowsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        DoCatchTryThrowsBootcamp()
    }
}
