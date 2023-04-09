//
//  NewsView.swift
//  disabilities enable
//
//  Created by Cate Wessels on 4/8/23.
//

import Foundation
import SwiftUI
import AVFoundation

struct NewsView : View {
    @State var title : String
    @State var author : String
    @State var content : String
    @State var image : String
    @State var url : String
    let synthesizer = AVSpeechSynthesizer()
    @State private var useGrayscale = false
    @State private var showDyslexic = false

    var body: some View {
            VStack {
                Divider()
                HStack {
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
                    

                }
                
                HStack() {
                    Spacer()
                    // Read the article outloud
                    Button() {
                        
                        // read the text
                        var readingAloud = title + "--" + content
                        let utterance = AVSpeechUtterance(string: readingAloud)
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
                Divider()
                
            VStack(alignment: .leading) {
                Text(title).bold()
                    .monospacedDigit()
                    .font(.custom(showDyslexic ? "OpenDyslexic3-Regular" : "TimesNewRomanPSMT", fixedSize: 20))
                    .multilineTextAlignment(.leading)
                Text(author).font(.subheadline)
                    .multilineTextAlignment(.leading).font(.custom(showDyslexic ? "OpenDyslexic3-Regular" : "TimesNewRomanPSMT", fixedSize: 13))
                Text(content)
                    .font(.custom(showDyslexic ? "OpenDyslexic3-Regular" : "TimesNewRomanPSMT", fixedSize: 15))
                    .multilineTextAlignment(.leading)
                AsyncImage (
                    url: URL(string: image),
                    content: { image in
                        image.resizable()
                        //.frame(maxWidth: 100, maxHeight: 100)
                            .aspectRatio(contentMode: .fit)
                    }, placeholder: {
                        ProgressView()
                    }).grayscale(useGrayscale ? 1: 0) // toggles grayscale
                Text("Continue Reading")
                    .onTapGesture {
                        UIApplication.shared.open(URL(string: url)!, options: [:])
                    }
            }
            .padding()
        }
        }
}
