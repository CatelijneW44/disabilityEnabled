//
//  NewsView.swift
//  disabilities enable
//
//  Created by Cate Wessels on 4/8/23.
//

import Foundation
import SwiftUI

struct NewsView : View {
    @State var title : String
    @State var author : String
    @State var content : String
    @State var image : String
    @State var url : String

    var body: some View {
        NavigationView {
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
                    })
                Text("Continue Reading")
                    .onTapGesture {
                        UIApplication.shared.open(URL(string: url)!, options: [:])
                    }
            }
            .padding()
        }}}
