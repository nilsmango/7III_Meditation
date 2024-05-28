//
//  WidgetExtensionLiveActivity.swift
//  WidgetExtension
//
//  Created by Simon Lang on 28.05.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WidgetExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
//        var startDate: Date
        var targetDate: Date
        var timerInMinutes: Int
        var timerStatus: TimerStatus
//        var preparationTime: Int
        var gradientBackground: Bool
        
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct WidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WidgetExtensionAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                TimerBannerView(targetDate: context.state.targetDate, timerInMinutes: context.state.timerInMinutes, timerStatus: context.state.timerStatus)
                    .padding()
            }
            .background(context.state.gradientBackground ? LinearGradient(gradient: Gradient(colors: [.customGray2, .accent]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [.customGray2]), startPoint: .top, endPoint: .bottom))
            .activityBackgroundTint(Color.red)
            .activitySystemActionForegroundColor(.blackAndWhite)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension WidgetExtensionAttributes {
    fileprivate static var preview: WidgetExtensionAttributes {
        WidgetExtensionAttributes(name: "World")
    }
}

extension WidgetExtensionAttributes.ContentState {
    fileprivate static var smiley: WidgetExtensionAttributes.ContentState {
        WidgetExtensionAttributes.ContentState(emoji: "🛑🛑", targetDate: Date().addingTimeInterval(600), timerInMinutes: 10, timerStatus: .running, gradientBackground: true)
     }
     
     fileprivate static var starEyes: WidgetExtensionAttributes.ContentState {
         WidgetExtensionAttributes.ContentState(emoji: "🏃‍♂️🏃‍♂️", targetDate: Date().addingTimeInterval(600), timerInMinutes: 10, timerStatus: .paused, gradientBackground: true)
     }
}

#Preview("Notification", as: .content, using: WidgetExtensionAttributes.preview) {
   WidgetExtensionLiveActivity()
} contentStates: {
    WidgetExtensionAttributes.ContentState.smiley
    WidgetExtensionAttributes.ContentState.starEyes
}
