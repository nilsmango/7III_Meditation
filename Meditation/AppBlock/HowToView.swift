//
//  HowToView.swift
//  Meditation
//
//  Created by Simon Lang on 15.07.2025.
//

import SwiftUI

struct HowToView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("1. Download and start 7III Life.")
                Text("2. Add the apps (iOS only) and websites you want to control, then tap Enable Blocking to start blocking.")
                Text("3. Add alternative activities if you want to get asked to do those before you are able to top up time.")
                Text("4. Remove all the apps and websites you have selected from Screen Time to avoid mayhem: Settings → Screen Time → App Limits.")
                Text("5. Activate the Safari browser extension: Safari → Settings → Browser Extensions, and check the box next to 7III Life Safari Extension to turn the extension on.")
                Text("6. If you want to use a blocked app or website for some time, you need to open 7III Life again, tap Top up Time, then select the time you want to spend, go back to the App, and tap the Unlock for xx min button.\nYes, this is intentionally inconvenient.")
            }
            .padding()
            
        }
        .navigationTitle("How To")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HowToView()
    }
}
