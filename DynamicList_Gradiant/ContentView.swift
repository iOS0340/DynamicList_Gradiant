//
//  ContentView.swift
//  DynamicList_Gradiant
//
//  Created by Bhavesh Patel on 16/07/24.
//

import SwiftUI

enum ScrollEffects: String, CaseIterable {
    case noEffect = "Normal"
    case rotating = "Rotating"
    case vEffect = "V-Effect"
    case hEffect = "H-Effect"
}

struct ContentView: View {
    
    var imageNames : [String] = (1..<11).map { index in
        "image\(index)"
    }
    
    @State private var selectedEffect : ScrollEffects = .noEffect
    
    var body: some View {
//        DynamicGradientList()
        ScrollViewWithEffects(selectedEffect: $selectedEffect, imageNames: imageNames)        
    }
}

#Preview {
    ContentView(imageNames: ["image1", "image2"])
}


struct ScrollViewWithEffects : View {
    
    @Binding var selectedEffect : ScrollEffects;
    let imageNames : [String]
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedEffect) {
                ForEach(ScrollEffects.allCases, id: \.self) { option in
                    Text(option.rawValue)
                        .tag(option)
                }
            }
            .pickerStyle(.palette)
            .padding(.horizontal)
            .padding(.top)
            
            switch selectedEffect {
            case .noEffect:
                SelectedScrollView(selectedEffectStyle: .noEffect, imageNames: imageNames)
            case .rotating:
                SelectedScrollView(selectedEffectStyle: .rotating, imageNames: imageNames)
            case .vEffect:
                SelectedScrollView(selectedEffectStyle: .vEffect, imageNames: imageNames)
            case .hEffect:
                SelectedScrollView(selectedEffectStyle: .hEffect, imageNames: imageNames)
            }

        }
    }
    
}

struct ScrollItem : View {
    let imageName : String;
    
    var body: some View {
        return Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(height: 500)
            .containerRelativeFrame(.horizontal)
            .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

struct SelectedScrollView : View {
    
    let selectedEffectStyle : ScrollEffects;
    let imageNames : [String]
    
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(0..<imageNames.count, id: \.self) {index in
                    ScrollItem(imageName: imageNames[index])
                        .if(selectedEffectStyle == .noEffect) { content in
                            content
                        }
                        .if(selectedEffectStyle == .rotating) { content in
                            content
                                .modifier(RotatingOffsetViewModifier())
                        }
                        .if(selectedEffectStyle == .vEffect) { content in
                            content
                                .modifier(VerticalOffsetViewModifier())
                        }
                        .if(selectedEffectStyle == .hEffect) { content in
                            content
                                .modifier(HorizontalOffsetViewModifier())
                        }
                        .containerRelativeFrame(.horizontal)
                        .clipShape(RoundedRectangle(cornerRadius: 36))
                }
            }
        }
        .contentMargins(36)
        .scrollTargetBehavior(.paging)
    }
}

struct DynamicGradientList : View {
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

func randomColor() -> Color{
    return Color(red: getRandomValue(), green: getRandomValue(), blue: getRandomValue());
}

func getRandomValue() -> Double{
    return Double.random(in: 0...1);
}

struct HorizontalOffsetViewModifier : ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .scrollTransition(axis: .horizontal) { content, phase in
                content
                    .offset(x: phase.isIdentity ? 0 : phase.value * -220)
            }
    }
}

struct VerticalOffsetViewModifier : ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .scrollTransition(axis: .horizontal) { content, phase in
                content
                    .offset(y: phase.isIdentity ? 0 : -50)
            }
    }
}

struct RotatingOffsetViewModifier : ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .scrollTransition(axis: .horizontal) { content, phase in
                content
                    .rotationEffect(.degrees(phase.value * 3.5))
                    .offset(y: phase.isIdentity ? 0 : 16)
            }
    }
}


extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
