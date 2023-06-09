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
    @State var titleList = []
    @State var descList = []
    @State var complete = ""
    let synthesizer = AVSpeechSynthesizer()
    @State var apiURL = "https://newsapi.org/v2/top-headlines?country=us&apiKey=aa38365c9dbf479ebdb342c83d3c5141"

    @State private var useGrayscale = false
    @State private var showDyslexic = false
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
            VStack {
                HStack() {
                Text("Current Stories").bold()
                    .font(.largeTitle
                        .monospaced()
                        .smallCaps()
                    )
                }
                .background(Color("lightBlue"))
                .cornerRadius(20)
//                .overlay(
//                        RoundedRectangle(cornerRadius: 16)
//                            .stroke(.blue)
//                    )
                
                Divider()
                VStack() {
                HStack() {
                    Spacer()
                    // Convert the image to black and white
                    Toggle(isOn: $useGrayscale) {
                        Text("Color vision deficiency")
                            .font(.footnote)
                    }
                    
                    // Change all fonts to one easy one
                    Toggle(isOn: $showDyslexic) {
                        Text("Dyslexia")
                            .font(.footnote)
                    }
                    Spacer()
                }//.shadow(radius: 10)
                
                
                HStack() {
                    Spacer()
                    // Read the article outloud
                    Button() {
                        
                        // read the text
                        
                        for i in 0...9 {
                            let titleNumber = titleList[i] as! String
                            let descNumber = descList[i] as! String
                            complete = complete + titleNumber + "--" + descNumber + "--"
                        }
                        
                        
                        let utterance = AVSpeechUtterance(string: complete)
                        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                        utterance.rate = 0.3
                        utterance.volume = 0.5
                        utterance.volume = 0.2
                        synthesizer.speak(utterance)
                        
                        
                        
                    } label: {
                        Image(systemName: "speaker.wave.3.fill")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                    }
                    Spacer()
                    Button() {
                        
                        // Pause audio
                        
                        synthesizer.pauseSpeaking(at: .word)
                    
                    } label: {
                        Text("Pause Listening")
                    }
                    
                    Text("  ")
                    
                    Button() {
                        
                        // Continue audio
                        
                        synthesizer.continueSpeaking()
                    
                    } label: {
                        Text("Continue Listening")
                    }
                    Spacer()
                }
                }
                .background(.white)
                .cornerRadius(20)
                Divider()
                
                
                    ForEach(story) { result in
                        VStack {
                        NavigationLink(destination: NewsView(title: result.title, author: result.author, content: result.content, image: result.urlToImage, url: result.url)) {
                            HStack(spacing: 15) {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(result.title).bold()
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.leading)
                                        .font(.custom(showDyslexic ? "OpenDyslexic3-Regular" : "TimesNewRomanPSMT", fixedSize: 25))
                                    Text(result.description)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.leading)
                                        .font(.custom(showDyslexic ? "OpenDyslexic3-Regular" : "TimesNewRomanPSMT", fixedSize: 20))
                                    
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
                                .navigationBarTitle(Text("Headlines"), displayMode: .inline)
                            
                        }
                    }
                        .background(.white)
                        .cornerRadius(20)
                }
                Divider()
                   
            } .background(Color(useGrayscale ? "white" : "lightBlue"))
                    //.ignoresSafeArea()
                    .edgesIgnoringSafeArea(.all)

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
                    desc = story_desc
                    descList.append(desc)
                    //print(descList)
                }
                if let story_content = result.articles[i].content {
                    c = story_content
                }
                if let story_title = result.articles[i].title {
                    t = story_title
                    titleList.append(t)
                    //print(titleList)
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


