//
//  WebBlockerView.swift
//  LifeMac
//
//  Created by Simon Lang on 21.07.2025.
//

import SwiftUI

struct WebBlockerView: View {
    @ObservedObject var model: MacModel
    
    @State private var showingWebsitesPicker: Bool = false
    @State private var blockedWebsites: [String] = []
    // for some soft sync
    
    var body: some View {
        
            VStack(spacing: 16) {
                // TODO:               HowToButton()
                
                
                
                if model.hasSelectedWebsites {
                    NavigationLink {
                        //                        TopUpTimeView(model: model)
                    } label: {
                        ButtonLabel(iconName: "plus.circle.fill", labelText: "Top up Time", accentColor: .greenAccent, navigationLink: true)
                    }
                    .buttonStyle(.plain)
                }
                
                SelectedWebsitesView(model: model)
                
                Button {
                    //                    showingWebsitePicker = true
                } label: {
                    ButtonLabel(iconName: model.hasSelectedWebsites ? "arrow.2.squarepath" : "plus.app.fill", labelText: model.hasSelectedWebsites ? "Change selected Websites" : "Select Websites to Block", accentColor: .blue)
                }
                .buttonStyle(.plain)
                
                
                if model.hasSelectedWebsites {
                    Button {
                        model.toggleBlocking()
                    } label: {
                        ButtonLabel(iconName: model.isBlocked ? "shield.slash.fill" : "shield.fill", labelText: model.isBlocked ? "Disable Blocking" : "Enable Blocking", accentColor: model.isBlocked ? .red : .green, fullColorButton: true)
                    }
                    .buttonStyle(.plain)
                }
                
                
                Spacer()
            }
            .padding()
            .popover(isPresented: $showingWebsitesPicker) {
                WebsiteSelectionSheet(blockedWebsites: $blockedWebsites)
//                .frame(width: 300, height: 400)
            }
        }
        
    
}
#Preview {
    WebBlockerView(model: MacModel())
}
