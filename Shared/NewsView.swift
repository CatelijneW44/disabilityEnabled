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
    
    @State private var useGrayscale = false
    @State private var showDyslexic = false

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    // Convert the image to black and white
                    Toggle(isOn: $useGrayscale) {
                        Text("Colorblind")
                    }
                    
                    // Change all fonts to one easy one
                    Toggle(isOn: $showDyslexic) {
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
                
            VStack(alignment: .leading) {
                Text(title).bold()
                    .monospacedDigit()
                    .font(.largeTitle)
                Text(author).font(.subheadline)
                Text(content)
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
        }}}
