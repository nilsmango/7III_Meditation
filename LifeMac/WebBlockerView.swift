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
    @State private var showingTopUpTimeView: Bool = false
    // for some soft sync
    
    var body: some View {
        
            VStack(spacing: 16) {
                
                NavigationLink(destination: {
                    MacHowToView()
                }) {
                    ButtonLabel(iconName: "lightbulb.max.fill", labelText: "How To", accentColor: .yellow, navigationLink: true)
                }
                .buttonStyle(.plain)
                
                if model.hasSelectedWebsites {
                    Button {
                        showingTopUpTimeView = true
                    } label: {
                        ButtonLabel(iconName: "plus.circle.fill", labelText: "Top up Time", accentColor: .greenAccent, navigationLink: false, fullColorButton: true)
                    }
                    .buttonStyle(.plain)
                }
                
                SelectedWebsitesView(model: model)
                
                NavigationLink {
                    MacWebsiteSelection(model: model)
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
            .sheet(isPresented: $showingTopUpTimeView) {
                MacTopUpTimeView(model: model)
            }
        }
}

#Preview {
    WebBlockerView(model: MacModel())
}
