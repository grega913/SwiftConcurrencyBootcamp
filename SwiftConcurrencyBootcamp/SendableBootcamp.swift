//
//  SendableBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by gs on 06/08/2023.
//

// if something is thread safe, it is also sendable by default
//   - Struct, Enum, String, Int, ...

import SwiftUI



actor CurrentUserManager {
    
    func updatedatabase(userInfo: MyUserInfo) {
        
    }
    
}

// it is immutable and thread safe
struct MyUserInfo: Sendable {
   let name: String
}

/* if we want to make class Sendable, we need to make sure it is final
 if we have variables that are constants(let), we know they will not be changing -> This can be sendable
 
 but if we have vars in class . .-> not thread safe
 */

final class MyClassUserInfo: Sendable {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

// but if we mark it as unchecked -> we say to compiler, you do not need to check it, we'll do it ourselves == superdangerous  . . sort of overwritting the compiler - this just means that compiler is not checking

final class MyClassUserInfo2: @unchecked Sendable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

// the way to make sure to use the class on the same thread( without using actors)

final class MyClassUserInfo3: @unchecked Sendable {
    private var name: String
    let queue = DispatchQueue(label: "com.MyApp.MyClassUserInfo")
    
    
    init(name: String) {
        self.name = name
    }
    
    func updateName(name: String) {
        queue.async {
            self.name = name
        }
    }
    
}


class SendableBootcampViewModel: ObservableObject {
    
    let manager = CurrentUserManager()
    
    func updateCurrentUserInfo() async {
        
        //let info = "USER INFO"
        let info = MyUserInfo(name: "info")
        
        await manager.updatedatabase(userInfo: info)
    }
    
}


struct SendableBootcamp: View {
    
    @StateObject private var viewModel = SendableBootcampViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task {
                
            }
    }
}

struct SendableBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        SendableBootcamp()
    }
}
