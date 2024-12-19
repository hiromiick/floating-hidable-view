//
//  ContentView.swift
//  FloatingHidableView
//
//  Created by hiromiick on 2024/12/18.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isShowing: Bool = true
    @State private var width: CGFloat = .zero
    @State private var offset: CGSize = .zero
    @State var dragStartPosition: CGPoint = .zero
    @State var isDragging: Bool = false
    
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                ResetButton(offset: $offset)
            }
            
            GeometryReader { proxy in
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .shadow(radius: 16)
                    
                    Text("Hello, World!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                    ZStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 24, height: 80)
                            .clipShape(.rect(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 10,
                                topTrailingRadius: 10
                            ))
                            .environment(\.colorScheme, .dark)
                        
                        Image(systemName: "chevron.compact.right")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    .position(CGPoint(x: getPosition(), y: 100))
                    .gesture(DragGesture()
                        .onChanged { value in
                            if isDragging == false {
                                dragStartPosition = CGPoint(x: offset.width, y: offset.height)
                                isDragging = true
                            }
                            offset =  CGSize(width: value.translation.width + dragStartPosition.x,
                                             height: value.translation.height + dragStartPosition.y)
                        }
                        .onEnded { value in
                            isDragging = false
                            dragStartPosition = CGPoint(x: offset.width, y: offset.height)
                            if (isShowing && value.translation.width < -40.0) ||
                                (!isShowing && value.translation.width > 40.0) {
                                isShowing.toggle()
                            }
                            updateOffset()
                        }
                    )
                }
                .frame(maxWidth: getMaxWidth(), maxHeight: .infinity)
                .onAppear {
                    width = proxy.size.width
                }
            }
            .padding()
            .offset(x: offset.width)
            .animation(.spring(response: 0.55, dampingFraction: 0.825), value: offset)
        }
    }
    
    private func getMaxWidth() -> CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 400 : .infinity
    }
    
    private func getPosition() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 400 + 12
        } else {
            return width + 12
        }
    }
    
    private func updateOffset() {
        offset.width = isShowing ? .zero : max(-width, -getMaxWidth())
    }
}

struct ResetButton: View {
    
    @Binding var offset: CGSize
    
    var body: some View {
        Button("reset") {
            withAnimation {
                offset = .zero
            }
        }
        .tint(.black)
        .buttonStyle(.borderedProminent)
        .fontWeight(.bold)
        .textCase(.uppercase)
    }
}

#Preview {
    ContentView()
}
