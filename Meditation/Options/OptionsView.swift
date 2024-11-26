//
//  OptionsView.swift
//  Meditation
//
//  Created by Simon Lang on 20.05.2024.
//

import SwiftUI
import StoreKit


struct OptionsView: View {
    @ObservedObject var meditationManager: MeditationManager
    
    @State private var showRedeemCode: Bool = false
    @State private var wasPurchased: Bool = false
    @State private var isShowingError = false
    @State private var errorTitle = ""

    var body: some View {
            List {
                
                Section("Messages") {
                    TextField("Welcome Back Text", text: $meditationManager.welcomeMessage)
                    
                    TextField("Meditation Started Text", text: $meditationManager.startMessage)
                    
                    Toggle("Show Koan", isOn: $meditationManager.meditationTimer.showKoan)
                        .tint(.accentColor)
                    
                    if meditationManager.meditationTimer.showKoan {
                        NavigationLink("Edit Koans", destination: KoansEditView(meditationManager: meditationManager))
                    }
                }
                
                Section("Meditation Sounds") {
                    NavigationLink {
                        NotificationSoundView(chosenSound: $meditationManager.meditationTimer.startSound, title: "Start Sound", soundOptions: meditationManager.soundOptions)
                    } label: {
                        HStack {
                            Text("Start Sound")
                            Spacer()
                            
                            Text(meditationManager.meditationTimer.startSound.name)
                                .opacity(0.5)
                        }
                    }
                    
                    NavigationLink {
                        NotificationSoundView(chosenSound: $meditationManager.meditationTimer.endSound, title: "End Sound", soundOptions: meditationManager.soundOptions)
                    } label: {
                        HStack {
                            Text("End Sound")
                            Spacer()
                            Text(meditationManager.meditationTimer.endSound.name)
                                .opacity(0.5)
                        }
                    }
                    
    //                Picker("Interval Sound", selection: $meditationManager.meditationTimer.intervalSound) {
    //                    ForEach(TimerSound.allCases, id: \.self) { sound in
    //                                        Text(sound.prettyString).tag(sound)
    //                                    }
    //                            }
                    // TODO: reminders to meditate, intervals
                }

                
                Section("Misc") {
                    Toggle("Activate Second End Sound", isOn: $meditationManager.meditationTimer.secondReminder)
                        .tint(.accentColor)
                    
                    Picker("Preparation Time", selection: $meditationManager.meditationTimer.preparationTime) {
                        ForEach(1...60, id: \.self) { seconds in
                            Text("\(seconds) \(seconds == 1 ? "Second" : "Seconds")")
                        }
                    }
    //                .pickerStyle(.wheel)
                    
                    Toggle("Gradient Background", isOn: $meditationManager.gradientBackground)
                        .tint(.accentColor)
                }
                
                Section(content:  {
                    Toggle("Activate Reminders", isOn: $meditationManager.reminders.activateReminders)
                        .tint(.accentColor)
                    
                    if meditationManager.reminders.activateReminders {
                        NavigationLink {
                            NotificationSoundView(chosenSound: $meditationManager.meditationTimer.reminderSound, title: "Reminder Sound", soundOptions: meditationManager.soundOptions)
                        } label: {
                            HStack {
                                Text("Reminder Sound")
                                Spacer()
                                Text(meditationManager.meditationTimer.reminderSound.name)
                                    .opacity(0.5)
                            }
                        }
                        
                        DatePicker("Reminder Time", selection: $meditationManager.reminders.reminderTime, displayedComponents: .hourAndMinute)
                                        
//                        Toggle("Remind Again", isOn: $meditationManager.reminders.remindAgain)
                                                
                    }
                }, header: {
                    Text("Reminders")
                }, footer: {
//                    Label("**Remind Again** will remind you to meditate if you don't meditate after the first reminder.", systemImage: "info.circle")
                })
                .onChange(of: meditationManager.reminders) {
                    meditationManager.updateReminders()
                }
                if let premium = meditationManager.premiumProducts.first(where: { $0.id == "com.project7III.meditation.removeAds"}) {
                Section(content: {
                    if meditationManager.hasPurchasedPremium || wasPurchased {
                        
                        Text("You’ve purchased the ads removal upgrade. Thank you for your support! ❤️")
                        
                        NavigationLink("Request a Refund") {
                            RefundView(meditationManager: meditationManager)
                        }
                    } else {
                        
                        Button {
                            Task {
                                try? await AppStore.sync()
                            }
                        } label: {
                            Label("Restore Purchases", systemImage: "arrow.clockwise.circle.fill")
                        }
                        
                        Button {
                            showRedeemCode = true
                        } label: {
                            Label("Redeem Code", systemImage: "numbers.rectangle.fill")
                        }
                        
                        
                            Button {
                                Task {
                                    await buy(product: premium)
                                }
                            } label: {
                                Label("Support Us & Remove Ads", systemImage: "sparkles")
                            }
                            .fontWeight(.bold)

                    }
                }, header: {
                    Text("Purchases")
                }, footer: {
                    if !meditationManager.hasPurchasedPremium {
                        Label("Removing ads costs only \(premium.displayPrice) and helps support the development of this app. Thank you for your support! ❤️", systemImage: "info.circle")
                    }
                })
                .tint(.primary)
                    
                }
                Section(content: {
                    Link(destination: URL(string: "mailto:hi@project7iii.com")!) {
                        Label("Contact", systemImage: "envelope.fill")
                    }
                    
                    Link(destination: URL(string: "https://project7iii.com")!, label: { Label("More from project7III", systemImage: "globe.europe.africa.fill") })
                    
                    
                    Link(destination: URL(string: "https://project7iii.com/meditation/privacy-policy/")!) {
                        Label("Privacy Policy", systemImage: "lock.fill")
                    }
                    
                    Link(destination: URL(string: "https://project7iii.com/meditation/terms-and-conditions/")!) {
                        Label("Terms and Conditions", systemImage: "doc.text.fill")
                    }
                    
                    NavigationLink(destination: TricksView()) {
                        Label("Tips & Tricks", systemImage: "lightbulb.fill")
                    }
                    
                    Link(destination: URL(string: "https://apps.apple.com/app/id6738342562?action=write-review")!) {
                        Label("Help Us Out & Review this App!", systemImage: "star.fill")
                    }
                    .fontWeight(.bold)
                    
                }, header: {
                    Text("Help & More")
                }, footer: {
                    Label("Use the \"Contact\" button to send us bugs or suggestions.", systemImage: "info.circle")
                })
                .tint(.primary)
                
            }
            .scrollContentBackground(.hidden)
            .background(.customGray)
            .navigationTitle("Options")
            .navigationBarTitleDisplayMode(.inline)
            .offerCodeRedemption(isPresented: $showRedeemCode, onCompletion: { result in
                            switch result {
                            case .success:
                                if meditationManager.hasPurchasedPremium {
                                    wasPurchased = true
                                }
                            case .failure(let error):
                                print("Code redemption failed: \(error.localizedDescription)")
                            }
                        })
            .alert(isPresented: $isShowingError, content: {
                Alert(title: Text(errorTitle), message: nil, dismissButton: .default(Text("Okay")))
            })
        
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
    NavigationView {
        OptionsView(meditationManager: MeditationManager())
    }
}
