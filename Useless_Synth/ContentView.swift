//
//  ContentView.swift
//  Useless_Synth
//
//  Created by Alex Nascimento on 15/04/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var synth = Synth()
    let frases = [
        "\"Wow, such random\" - Doge",
        "\"Still a better lovestory than twilight\" - Reddit 2012",
        "\"That's... interesting\" - Bob",
        "\"What are you doing with your life...\" - My father"]
    @State var isPlaying = false
    
    var body: some View {
        VStack {
            Text("Totally Random Synth")
                .font(.largeTitle)
                .fontWeight(.medium)
            Button(action: {
                self.synth.toggleEngine()
                self.isPlaying.toggle()
            }) {
                if isPlaying {
                    HStack {
                        Image(systemName: "stop.fill")
                        Text("Stop")
                            .fontWeight(.medium)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [.red, .orange]), startPoint: .leading, endPoint: .trailing))
                    .font(.largeTitle)
                    .cornerRadius(20)
                } else {
                    HStack{
                        Image(systemName: "play.fill")
                        Text("Play")
                            .fontWeight(.medium)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .leading, endPoint: .trailing))
                    .font(.largeTitle)
                    .cornerRadius(20)
                }
            }
            if isPlaying {
                Text(frases.randomElement()!)
                .italic()
                .foregroundColor(.gray)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
