//
//  RemoveAdsView.swift
//  Meditation
//
//  Created by Simon Lang on 17.11.2024.
//

import SwiftUI
import StoreKit

struct RemoveAdsView: View {
    var body: some View {
        StoreView(ids:  ["com.project7III.meditation.removeAds"])
            .storeButton(.visible, for: .restorePurchases, .redeemCode, .policies)
    }
}

#Preview {
    RemoveAdsView()
}
