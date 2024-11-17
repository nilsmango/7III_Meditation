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
    
    var currentAd: Ad {
        meditationAds.randomElement()!
    }
    
    var showAd33: Bool {
        Int.random(in: 0..<100) < 34
//        true
    }
    
    var body: some View {
        
        // TODO: make this never to show if the upgrade was purchased
        if showAd && showAd33 {
            VStack {
                VStack {
                    ZStack {
                        HStack {
                            Text("Ad Spotlight")
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
                                    .font(.title3)
                            }
                            .tint(.primary)
                        }
                    }
                    
                    HStack {
                        currentAd.image
                        VStack(alignment: .leading) {
                            Text(currentAd.title)
                                .fontWeight(.bold)
                            Text(currentAd.subTitle)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                    Button(action: {
                        // Open the link in Safari
                        if let url = URL(string: currentAd.url.absoluteString) {
                            UIApplication.shared.open(url)
                        }
                        showAd = false
                        
                    }) {
                        Label("Visit \(currentAd.title)", systemImage: "arrow.right.circle.fill")
                    }
                    .tint(.blue)
                    .buttonStyle(.borderedProminent)
                    .padding(.vertical)
                    
                    
                    Button(action: {
                        // TODO: go to / open upgrade shop
                    }) {
                        Label("Remove Ads Forever", systemImage: "sparkles")
                    }
                    .tint(.green)
                    .buttonStyle(.bordered)
                    .padding(.bottom)
                    
                    // TODO: insert real amount
                    Label("Removing ads is only USD __ and supports the further development of this app. Thank you for your support! ❤️", systemImage: "info.circle")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                    
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
            .frame(maxWidth: 400)
            .padding()
        }
    }
}

#Preview {
    AdvertisementView()
}
