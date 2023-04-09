//
//  ContentView.swift
//  Shared
//
//  Created by Cate Wessels on 4/8/23.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @State var story = [NewsDisplay(author: "start", title: "", description: "", urlToImage: "", content: "", url: "")]
    @State var desc = ""
    @State var t = ""
    @State var c = ""
    @State var image = ""
    @State var author = ""
    @State var u = ""
    @State var apiURL = "https://newsapi.org/v2/top-headlines?country=us&apiKey=aa38365c9dbf479ebdb342c83d3c5141"
    // API KEY aa38365c9dbf479ebdb342c83d3c5141
    
    //
    @State private var useGrayscale = false
    @State private var useDyseie = false
    
    var body: some View {
        
        NavigationView {
            
            
            
            ScrollView {
            VStack {
                HStack {
                    // Convert the image to black and white
                    Toggle(isOn: $useGrayscale) {
                        Text("Color Impared")
                    }
                    
                    // Change all fonts to one easy one
                    Toggle(isOn: $useDyseie) {
                        Text("Dyslexic")
                    }
                
                    
                    
                    // Read the article outloud
                    Button() {
                        
                        // read the text
                        
                        let synthesizer = AVSpeechSynthesizer()
                        let utterance = AVSpeechUtterance(string: "put the article text here")
                        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                        utterance.rate = 0.3
                        utterance.volume = 0.5
                                            
                        synthesizer.speak(utterance)
                        
                        
                    } label: {
                        Image(systemName: "speaker.wave.3.fill")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                    }
                    

                }
                .padding()
                
                VStack {
                    ForEach(story) { result in
                        
                        NavigationLink(destination: NewsView(title: result.title, author: result.author, content: result.content, image: result.urlToImage, url: result.url)) {
                            HStack(spacing: 15) {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(result.title).bold()
                                        .foregroundColor(.black)
                                        .font(.custom(useDyseie ? "OpenDyslexic3-Regular" : "TimesNewRomanPSMT", fixedSize: 20))
                                    Text(result.description)
                                        .foregroundColor(.black)
                                        .font(.custom(useDyseie ? "OpenDyslexic3-Regular" : "TimesNewRomanPSMT", fixedSize: 15))
                                    
                                }
                                AsyncImage (
                                    url: URL(string: result.urlToImage),
                                    content: { image in
                                        image.resizable()
                                            .frame(maxWidth: 100, maxHeight: 100)
                                            .aspectRatio(contentMode: .fit)
                                    }, placeholder: {
                                        ProgressView()
                                    }).grayscale(useGrayscale ? 1: 0) // toggles grayscale
                                
                            }.padding()
                                .navigationTitle("Headlines")
                            
                        }
                    }
                }
            }
            }
        }
        .onAppear { self.loadData { (News)  in
            //print(News)
        } }
        
         
    }
        
    
    func getStory() {
        loadData { (News) in
            //self.story.append(News)
            
        }
    }
    
    func loadData(completion: @escaping (News) ->  ()) {
        
        guard let url = URL(string: apiURL) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            let result = try! JSONDecoder().decode(News.self, from: data!)
            
            for i in 2...16 {
            
            DispatchQueue.main.async {
                
                if let story_desc = result.articles[i].description {
                    print(story_desc)
                    desc = story_desc
                }
                if let story_content = result.articles[i].content {
                    print(story_content)
                    c = story_content
                }
                if let story_title = result.articles[i].title {
                    print(story_title)
                    t = story_title
                }
                if let story_image = result.articles[i].urlToImage {
                    image = story_image
                }
                if let story_author = result.articles[i].author {
                    author = story_author
                }
                if let story_url = result.articles[i].url {
                    u = story_url
                }
                story.append(NewsDisplay(author: author, title: t, description: desc, urlToImage: image, content: c, url: u))
                    
                if story[0].author == "start" {
                    story.remove(at: 0)
                }
            }
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

                             
struct NewsDisplay : Identifiable {
    var id = UUID()
    var author : String
    var title : String
    var description : String
    var urlToImage : String
    var content : String
    var url : String
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


