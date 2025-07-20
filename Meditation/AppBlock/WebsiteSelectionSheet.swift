//
//  WebsiteSelectionSheet.swift
//  Meditation
//
//  Created by Simon Lang on 19.07.2025.
//

import SwiftUI

struct WebsiteSelectionSheet: View {
    @Binding var blockedWebsites: [String]
    @State private var allWebsites: [String] = []
    @State private var newWebsiteText: String = ""
    @State private var showingAddAlert: Bool = false
    
    // Default websites list
    private let defaultWebsites = [
        "facebook.com",
        "instagram.com",
        "x.com",
        "youtube.com",
        "tiktok.com",
        "reddit.com",
        "netflix.com",
        "twitch.tv",
        "snapchat.com",
        "linkedin.com"
    ]
    
    var body: some View {
        NavigationView {
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
                }
                .padding()
                
                Divider()
                
                // Website list
                List {
                    ForEach(allWebsites, id: \.self) { website in
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
            .navigationBarHidden(true)
            .onAppear {
                loadWebsites()
            }
            .alert("Add Website", isPresented: $showingAddAlert) {
                TextField("Enter website (e.g., example.com)", text: $newWebsiteText)
                    .autocapitalization(.none)
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
    }
    
    private func loadWebsites() {
        // Load all websites from UserDefaults
        if let savedWebsites = UserDefaults.standard.array(forKey: "AllWebsites") as? [String] {
            allWebsites = savedWebsites
        } else {
            // If no websites saved, use defaults
            allWebsites = defaultWebsites
            UserDefaults.standard.set(allWebsites, forKey: "AllWebsites")
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
        
        if !cleanedWebsite.isEmpty && !allWebsites.contains(cleanedWebsite) {
            allWebsites.append(cleanedWebsite)
            allWebsites.sort() // Keep alphabetically sorted
            
            // Auto-select the newly added website
            if !blockedWebsites.contains(cleanedWebsite) {
                blockedWebsites.append(cleanedWebsite)
            }
            
            // Save to UserDefaults immediately
            UserDefaults.standard.set(allWebsites, forKey: "AllWebsites")
        }
        
        newWebsiteText = ""
    }
    
    private func deleteWebsite(_ website: String) {
        // Remove from all websites list
        allWebsites.removeAll { $0 == website }
        
        // Remove from blocked websites if it was selected
        blockedWebsites.removeAll { $0 == website }
        
        // Update UserDefaults
        UserDefaults.standard.set(allWebsites, forKey: "AllWebsites")
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
    
    private func saveWebsites() {
        // Save all websites to UserDefaults
        UserDefaults.standard.set(allWebsites, forKey: "AllWebsites")
    }
}

#Preview {
    WebsiteSelectionSheet(blockedWebsites: .constant([]))
}
