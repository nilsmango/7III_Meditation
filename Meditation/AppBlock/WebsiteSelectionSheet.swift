//
//  WebsiteSelectionSheet.swift
//  Meditation
//
//  Created by Simon Lang on 19.07.2025.
//

import SwiftUI

struct WebsiteSelectionSheet: View {
#if os(macOS)
    @ObservedObject var model: MacModel
    #else
    @ObservedObject var model: TheModel
    #endif
    @Binding var blockedWebsites: [String]
    @State private var newWebsiteText: String = ""
    @State private var showingAddAlert: Bool = false
    
    var body: some View {

            VStack(spacing: 0) {
                // Header with add button
                HStack {
                    Text("Select Websites to Block")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button {
                        showingAddAlert = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.greenAccent)
                    }
                    #if os(macOS)
                    .buttonStyle(.plain)
                    #endif
                }
                .padding()
                
                Divider()
                
                // Website list
                List {
                    ForEach(model.allWebsites, id: \.self) { website in
                        WebsiteRow(
                            website: website,
                            isSelected: blockedWebsites.contains(website),
                            onToggle: { toggleWebsite(website) },
                            onDelete: { deleteWebsite(website) }
                        )
                    }
                }
                .listStyle(PlainListStyle())
            }
            .alert("Add Website", isPresented: $showingAddAlert) {
                TextField("Enter website (e.g., example.com)", text: $newWebsiteText)
                #if os(iOS)
                    .autocapitalization(.none)
                    .keyboardType(.URL)
                #endif
                    .disableAutocorrection(true)
                
                Button("Cancel", role: .cancel) {
                    newWebsiteText = ""
                }
                
                Button("Add") {
                    addNewWebsite()
                }
                .disabled(newWebsiteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            } message: {
                Text("Enter the domain name of the website you want to add to your list.")
            }
        }
    
    private func toggleWebsite(_ website: String) {
        if blockedWebsites.contains(website) {
            blockedWebsites.removeAll { $0 == website }
        } else {
            blockedWebsites.append(website)
        }
    }
    
    private func addNewWebsite() {
        let cleanedWebsite = cleanWebsiteURL(newWebsiteText.trimmingCharacters(in: .whitespacesAndNewlines))
        
        if !cleanedWebsite.isEmpty && !model.allWebsites.contains(cleanedWebsite) {
            model.allWebsites.append(cleanedWebsite)
            model.allWebsites.sort() // Keep alphabetically sorted
            
            // Auto-select the newly added website
            if !blockedWebsites.contains(cleanedWebsite) {
                blockedWebsites.append(cleanedWebsite)
            }
            
        }
        
        newWebsiteText = ""
    }
    
    private func deleteWebsite(_ website: String) {
        // Remove from all websites list
        model.allWebsites.removeAll { $0 == website }
        
        // Remove from blocked websites if it was selected
        blockedWebsites.removeAll { $0 == website }
        
        // Also remove from blocked websites in model
        model.websitesSelection.removeAll { $0 == website }
    }
    
    private func cleanWebsiteURL(_ input: String) -> String {
        var cleaned = input.lowercased()
        
        // Remove common prefixes
        if cleaned.hasPrefix("https://") {
            cleaned = String(cleaned.dropFirst(8))
        } else if cleaned.hasPrefix("http://") {
            cleaned = String(cleaned.dropFirst(7))
        }
        
        if cleaned.hasPrefix("www.") {
            cleaned = String(cleaned.dropFirst(4))
        }
        
        // Remove trailing slash
        if cleaned.hasSuffix("/") {
            cleaned = String(cleaned.dropLast())
        }
        
        return cleaned
    }
}

#Preview {
#if os(macOS)
    WebsiteSelectionSheet(model: MacModel(), blockedWebsites: .constant([]))
    #else
    WebsiteSelectionSheet(model: TheModel(), blockedWebsites: .constant([]))
    #endif
    
}
