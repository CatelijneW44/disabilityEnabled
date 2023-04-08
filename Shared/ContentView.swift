//
//  ContentView.swift
//  Shared
//
//  Created by Cate Wessels on 4/8/23.
//

import SwiftUI
//import SwiftyJSON




struct ContentView: View {
    @State var apiURL = "https://newsapi.org/v2/top-headlines?country=us&apiKey=aa38365c9dbf479ebdb342c83d3c5141"
    
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
        .onAppear { self.loadData { (News)  in
            //print(News)
        } }
    }
    
    func loadData(completion: @escaping (News) ->  ()) {
        
        guard let url = URL(string: apiURL) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            let result = try! JSONDecoder().decode(News.self, from: data!)
            
            DispatchQueue.main.async {
//                print(result)
                print(result.articles[0].content)

                completion(result)
            }
        }
        .resume()
    }
        
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct News : Codable {
    var status : String?
    var totalResults : Int?
    var articles : [articlesData]
}

struct articlesData : Codable {
    var source : sourceStruct
    var author: String?
    var title: String?
    var description : String?
    var url : String?
    var urlToImage : String?
    var publishedAt : String?
    var content : String?
    
}

struct sourceStruct : Codable {
    var id: String?
    var name : String?
}


