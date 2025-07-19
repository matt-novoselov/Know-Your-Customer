//
//  HomeView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer().frame(height: 50)
            
            VStack {
                HStack {
                    AppIconView()
                        .frame(height: 44)
                    
                    Text("KYCa")
                        .font(.dazzed(size: 24, weight: .bold, width: 0))
                        .fontWeight(.black)
                }
                
                Text("Simple investing for everyone")
                    .font(.dazzed(size: 20, weight: .semibold, width: 0))
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            Button("I am new to KYC") { isExpanded.toggle() }
                .buttonStyle(PeaksButtonStyle(.accent))
            
            Button("I already have an account") { }
                .buttonStyle(PeaksButtonStyle())
                .disabled(true)
        }
        .padding()
        .background(){
            AnimatedColorsMeshGradientView()
                .opacity(0.5)
        }
        .fullScreenCover(isPresented: $isExpanded){
            CountrySelectionView()
                .interactiveDismissDisabled(true)
                .presentationDetents([.large])
                .presentationDragIndicator(.hidden)
        }
    }
}

#Preview {
    ContentView()
}
