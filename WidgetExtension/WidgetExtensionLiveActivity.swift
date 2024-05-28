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
//            VStack {
                TimerBannerView(targetDate: context.state.targetDate, timerInMinutes: context.state.timerInMinutes, timerStatus: context.state.timerStatus)
                    .padding()
//            }
            .background(context.state.gradientBackground ? LinearGradient(gradient: Gradient(colors: [.customGray2, .accent]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [.customGray2]), startPoint: .top, endPoint: .bottom))
//            .activityBackgroundTint(Color.red)
//            .activitySystemActionForegroundColor(.blackAndWhite)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    if context.state.timerStatus == .running {
                        Text(context.state.targetDate, style: .timer)
                    } else {
                        Text(dateToDateFormatted(from: Date(), to: Date().addingTimeInterval(Double(context.state.timerInMinutes * 60))))
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Meditation")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack {
                        if context.state.timerStatus == .running {
                            ProgressView(timerInterval: context.state.targetDate.addingTimeInterval(-Double(context.state.timerInMinutes*60))...context.state.targetDate, countsDown: false) {
                                         Text("")
                                     } currentValueLabel: {
                                         Text("")
                                      }
                            .tint(.accent)
                        } else {
                            ProgressView(value: 0.0) {
                                         Text("")
                                     } currentValueLabel: {
                                         Text("")
                                      }
                            .tint(.accent)
                        }
                        
                        // TODO: buttons for play stop, again with the switch timerStatus (but use text, instead icons)
                    }
                    
                    // more content
                }
            } compactLeading: {
                if context.state.timerStatus == .running {
                    Text(context.state.targetDate, style: .timer)
                } else {
                    Text(dateToDateFormatted(from: Date(), to: Date().addingTimeInterval(Double(context.state.timerInMinutes * 60))))
                }
            } compactTrailing: {
                Text("Meditation")
            } minimal: {
                switch context.state.timerStatus {
                case .running:
                    WidgetButtonLabel(buttonState: .play)
                case .alarm:
                    WidgetButtonLabel(buttonState: .resume)
                case .paused:
                    WidgetButtonLabel(buttonState: .pause)
                case .preparing:
                    WidgetButtonLabel(buttonState: .play)
                case .stopped:
                    WidgetButtonLabel(buttonState: .stop)
                }
            }
            // TODO: change the widgetURL!
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(.accent)
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
