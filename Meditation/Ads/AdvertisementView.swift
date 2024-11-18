//
//  AdvertisementView.swift
//  Meditation
//
//  Created by Simon Lang on 16.11.2024.
//

import SwiftUI
import StoreKit

struct AdvertisementView: View {
    @ObservedObject var meditationManager: MeditationManager

    @State private var dragOffset = CGSize.zero
    @State private var isDragging = false
    @State private var showAd: Bool = true
    
    var currentAd: Ad = meditationAds.randomElement()!
    
    @State private var showRedeemCode: Bool = false
    @State private var wasPurchased: Bool = false
    @State private var isShowingError = false
    @State private var errorTitle = ""
    
    var body: some View {
        
        // TODO: make this never to show if the upgrade was purchased
        if showAd && !wasPurchased && !meditationManager.hasPurchasedPremium {
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
                    .tint(.primary)
                    .buttonStyle(.borderedProminent)
                    .padding(.vertical)
                    
                    
                    if let premium = meditationManager.premiumProducts.first(where: { $0.id == "com.project7III.meditation.removeAds"}) {
                        Button(action: {
                            Task {
                                await buy(product: premium)
                            }
                            
                        }) {
                            Label("Remove Ads Forever", systemImage: "sparkles")
                        }
                        .tint(.green)
                        .buttonStyle(.bordered)
                        .padding(.bottom, 6)
                        .padding(.top, 6)
                        
                        Label("Removing ads costs only \(premium.displayPrice) and helps support the development of this app. Thank you for your support! ❤️", systemImage: "info.circle")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                        
                        
                    }
                    
                    
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
                
            }
            .frame(maxWidth: 400)
            .padding()
            .onAppear {
                if Int.random(in: 0..<100) < 66 {
                    showAd = false
                }
            }
            .alert(isPresented: $isShowingError, content: {
                Alert(title: Text(errorTitle), message: nil, dismissButton: .default(Text("Okay")))
            })
        }
    }
    
    func buy(product: Product) async {
           do {
               if try await meditationManager.purchase(product: product) != nil {
                   wasPurchased = true
               }
           } catch StoreError.failedVerification {
               errorTitle = "Your purchase could not be verified by the App Store."
               isShowingError = true
           } catch {
               print("Failed purchase for \(product.id). \(error)")
           }
       }
}

#Preview {
    AdvertisementView(meditationManager: MeditationManager())
}
