//
//  ContentView.swift
//  Shared
//
//  Created by Cate Wessels on 4/8/23.
//

import SwiftUI
//import SwiftyJSON




struct ContentView: View {
    
    
    @State var urlString = "https://newsapi.org/v2/everything?q=Apple&from=2023-03-08&sortBy=publishedAt&apiKey=aa38365c9dbf479ebdb342c83d3c5141"
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(1...10, id: \.self) { count in
                    
                    Text("Hello, world")
                    Spacer()

                    // API KEY aa38365c9dbf479ebdb342c83d3c5141
                }
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


