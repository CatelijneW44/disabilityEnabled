//
//  ContentView.swift
//  Shared
//
//  Created by Cate Wessels on 4/8/23.
//

import SwiftUI
//import SwiftyJSON




struct ContentView: View {
    
    @State var story = News(status: "", totalResults: 0, articles: [articlesData(source: sourceStruct(id:"", name:""), author: "", title: "", description: "", url: "", urlToImage: "", publishedAt: "", content: "")])
    @State var desc = ""
    @State var t = ""
    @State var c = ""
    @State var image = ""
    @State var apiURL = "https://newsapi.org/v2/top-headlines?country=us&apiKey=aa38365c9dbf479ebdb342c83d3c5141"
    // API KEY aa38365c9dbf479ebdb342c83d3c5141
    
    var body: some View {
        
        NavigationView {
            
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(t).bold()
                    Text(desc)
                }
                AsyncImage (
                    url: URL(string: image),
                    content: { image in
                    image.resizable()
                        .frame(maxWidth: 100, maxHeight: 100)
                        .aspectRatio(contentMode: .fit)
                    }, placeholder: {
                     ProgressView()
                    }
                )
//                AsyncImage(url: URL(string: image))
//                    .resizable()
//                    .frame(maxWidth: 100, maxHeight: 100)
//            }
        
            }.padding()
            
        }.navigationTitle("Headlines")
        .onAppear { self.loadData { (News)  in
            //print(News)
        } }
        
         
    }
        
    
    func getStory() {
        loadData { (News) in
            self.story = News

            //t = story.articles[0].title
            
        }
    }
    
    func loadData(completion: @escaping (News) ->  ()) {
        
        guard let url = URL(string: apiURL) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            let result = try! JSONDecoder().decode(News.self, from: data!)
            
            DispatchQueue.main.async {
//                print(result.count)
                print(result.articles[3].content)
                
                if let story_desc = result.articles[3].description {
                    print(story_desc)
                    desc = story_desc
                }
                if let story_content = result.articles[3].content {
                    print(story_content)
                    c = story_content
                }
                if let story_title = result.articles[3].title {
                    print(story_title)
                    t = story_title
                }
                if let story_image = result.articles[3].urlToImage {
                    image = story_image
                }
                

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


