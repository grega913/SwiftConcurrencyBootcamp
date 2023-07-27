//
//  ContentView.swift
//  SwiftConcurrencyBootcamp
//
//  Created by gs on 27/07/2023.
//




import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .background(.red)
            Text("Hello, world! What's up?")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
