//
//  AdvertisementView.swift
//  Meditation
//
//  Created by Simon Lang on 16.11.2024.
//

import SwiftUI

struct AdvertisementView: View {
    @State private var dragOffset = CGSize.zero
    @State private var isDragging = false
    @State private var showAd: Bool = true
    
    var body: some View {
        
        // TODO: make this always not show if the upgrade was purchased
        if showAd {
            let currentAd = meditationAds.randomElement()!
            
            VStack {
                VStack {
                    ZStack {
                        HStack {
                            Text(currentAd.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .fontDesign(.rounded)
                        }
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                showAd = false
                                
                            }) {
                                Label("Close", systemImage: "xmark.circle.fill")
                                    .labelStyle(.iconOnly)
                                    .font(.title2)
                            }
                            .tint(.primary)
                        }
                    }
                    
                    HStack {
                        currentAd.image
                        Text(currentAd.subTitle)
                    }
                    
                    Button(action: {
                        // Open the link in Safari
                        if let url = URL(string: currentAd.url.absoluteString) {
                            UIApplication.shared.open(url)
                        }
                        showAd = false
                        
                    }) {
                        Label("Visit \(currentAd.title)", systemImage: currentAd.title == "Molecule Store" ? "flask" : "checkmark.circle.fill")
                    }
                    .tint(.red)
                    .buttonStyle(.borderedProminent)
                    .padding(.vertical)
                    
                    
                    Button(action: {
                        // TODO: go to / open upgrade shop
                    }) {
                        Label("Remove Ads Forever", systemImage: "heart.fill")
                    }
                    .tint(.green)
                    .buttonStyle(.borderedProminent)
                    .padding(.bottom, 8)
                    
                    Label("Removing ads is only USD __ and supports the further development of this app. Thank you for your support! ❤️", systemImage: "info.circle")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 21.67, style: .continuous)
                        .fill(.background)
                        .shadow(radius: 10)
                }
                .offset(x: dragOffset.width, y: dragOffset.height)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation
                            isDragging = true
                        }
                        .onEnded { _ in
                            withAnimation(.interpolatingSpring(stiffness: 300, damping: 9)) {
                                dragOffset = .zero
                                isDragging = false
                            }
                        }
                )
                
//                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    AdvertisementView()
}
