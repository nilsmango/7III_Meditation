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
    @State private var showAd: Bool = false
    
    var currentAd: Ad
    
    @State private var showRemoveAds: Bool = false
    
    @State private var showRedeemCode: Bool = false
    @State private var isShowingError = false
    @State private var errorTitle = ""
    
    @AppStorage("showAdsNumber") var showAdsNumber = 0
    
    var body: some View {
        ZStack {
            if showAd && !meditationManager.hasPurchasedPremium {
                VStack {
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    VStack {
                        
                        if showRemoveAds, let premium = meditationManager.premiumProducts.first(where: { $0.id == "com.project7III.meditation.removeAds"}) {
                            
                            Text("Remove Ads Forever")
                                .font(.title2)
                                .fontWeight(.bold)
                                .fontDesign(.rounded)
                            
                            Text("Removing ads costs only \(premium.displayPrice) and helps support the development of this app. Thank you for your support! ❤️")
                                .padding(.horizontal)
                                .padding(.top, 1)
                            
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    
                                    showAd = false
                                    showRemoveAds = false
                                }) {
                                    Text("No Thanks")
                                }
                                .tint(.primary)
                                .buttonStyle(.bordered)
                                .padding(.vertical)
                                
                                
                                
                                Spacer()
                                
                                Button(action: {
                                    Task {
                                        await buy(product: premium)
                                    }
                                    
                                }) {
                                    Label("Remove Ads", systemImage: "sparkles")
                                }
                                .tint(.green)
                                .buttonStyle(.borderedProminent)
                                .padding(.vertical)
                                
                                Spacer()
                                
                            }
                            
                        } else {
                            Text("Ad Spotlight")
                                .font(.title2)
                                .fontWeight(.bold)
                                .fontDesign(.rounded)
                            
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
                            
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    
                                    showRemoveAds = true
                                }) {
                                    Text("No Thanks")
                                }
                                .tint(.primary)
                                .buttonStyle(.bordered)
                                .padding(.vertical)
                                
                                Spacer()
                                
                                Button(action: {
                                    // Open the link in Safari
                                    if let url = URL(string: currentAd.url.absoluteString) {
                                        UIApplication.shared.open(url)
                                    }
                                    showAd = false
                                }) {
                                    Label("Check it out", systemImage: "checkmark.circle.fill")
                                }
                                .tint(.accentColor)
                                .buttonStyle(.borderedProminent)
                                .padding(.vertical)
                                
                                Spacer()
                            }
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
                    
                    Spacer()
                }
                .frame(maxWidth: 400)
                .padding()
            }
        }
            .onAppear {
                showAdsNumber += 1
                print(showAdsNumber)
                if showAdsNumber > 6 {
                    showAdsNumber = 0
                    
                    showAd = true
                    
                    // review
                    if meditationManager.showPromptForReview {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.73) {
                            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                                SKStoreReviewController.requestReview(in: scene)
                            }
                            meditationManager.showPromptForReview = false
                        }
                    }
                }
            }
            .alert(isPresented: $isShowingError, content: {
                Alert(title: Text(errorTitle), message: nil, dismissButton: .default(Text("Okay")))
            })
    }
    
    func buy(product: Product) async {
        do {
            if try await meditationManager.purchase(product: product) != nil {
                showAd = false
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
    AdvertisementView(meditationManager: MeditationManager(), currentAd: meditationAds.randomElement()!)
}
