//
//  ContentView.swift
//  DynamicList_Gradiant
//
//  Created by Bhavesh Patel on 16/07/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView(.vertical){
            VStack {
                ForEach(0..<25) { index in
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(randomColor().gradient)
                        .frame(height: 100)
                        .visualEffect { content, proxy in
                                                    let frame = proxy.frame(in: .scrollView(axis: .vertical))
                                                    let distance = min(0, frame.minY)
//                            print("Distance \(distance) And Frame \(frame) And index \(index)")
                            return content
//                                .hueRotation(.degrees(frame.origin.y / 5))
                                .scaleEffect(1 + distance / (UIScreen.current?.bounds.height)!)
                                .offset(y: -distance / 1.35)
                                .brightness(-distance / (UIScreen.current?.bounds.height)!)
                                .blur(radius: -distance / 50)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

func randomColor() -> Color{
    return Color(red: getRandomValue(), green: getRandomValue(), blue: getRandomValue());
}

func getRandomValue() -> Double{
    return Double.random(in: 0...1);
}
