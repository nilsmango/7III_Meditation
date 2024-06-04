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
        //        var startDate: Date
        var targetDate: Date
        var timerInMinutes: Int
        var timerStatus: TimerStatus
        //        var preparationTime: Int
        var gradientBackground: Bool
        var welcomeBackText: String
        var koanText: String
        var showKoan: Bool
        
    }
    
    // Fixed non-changing properties about your activity go here!
}

struct WidgetExtensionLiveActivity: Widget {
    let frameWidth = 50.0
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WidgetExtensionAttributes.self) { context in
            // Lock screen/banner UI goes here
            
            ActivityLockScreenView(timerStatus: context.state.timerStatus, targetDate: context.state.targetDate, timerInMinutes: context.state.timerInMinutes, welcomeBackText: context.state.welcomeBackText, koanText: context.state.koanText, showKoan: context.state.showKoan, frameWidth: frameWidth)
                .activityBackgroundTint(nil)
            //            .background(context.state.gradientBackground ? LinearGradient(gradient: Gradient(colors: [.customGray2, .accent]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [.customGray2]), startPoint: .top, endPoint: .bottom))
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                
                DynamicIslandExpandedRegion(.leading) {
                    WidgetLogoView(expanded: true)
                        .frame(width: frameWidth)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    HStack {
                        Spacer()
                        
                        CircleProgressView(timerStatus: context.state.timerStatus, targetDate: context.state.targetDate, timerInMinutes: context.state.timerInMinutes, expanded: true)
                            .frame(width: frameWidth)
                    }
                    
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    IslandExpandedBottomView(timerStatus: context.state.timerStatus, targetDate: context.state.targetDate, timerInMinutes: context.state.timerInMinutes, welcomeBackText: context.state.welcomeBackText, koanText: context.state.koanText, showKoan: context.state.showKoan, frameWidth: frameWidth)
                }
            } compactLeading: {
                WidgetLogoView()
                
            } compactTrailing: {
                CircleProgressView(timerStatus: context.state.timerStatus, targetDate: context.state.targetDate, timerInMinutes: context.state.timerInMinutes)
                //  .padding(.trailing, -2)
                
            } minimal: {
                CircleProgressView(timerStatus: context.state.timerStatus, targetDate: context.state.targetDate, timerInMinutes: context.state.timerInMinutes)
                
            }
            .keylineTint(.accent)
        }
    }
}


extension WidgetExtensionAttributes {
    fileprivate static var preview: WidgetExtensionAttributes {
        WidgetExtensionAttributes()
    }
}

extension WidgetExtensionAttributes.ContentState {
    fileprivate static var running: WidgetExtensionAttributes.ContentState {
        WidgetExtensionAttributes.ContentState(targetDate: Date().addingTimeInterval(60), timerInMinutes: 1, timerStatus: .running, gradientBackground: true, welcomeBackText: "Welcome Back!", koanText: "Love is the way.", showKoan: true)
    }
    
    fileprivate static var paused: WidgetExtensionAttributes.ContentState {
        WidgetExtensionAttributes.ContentState(targetDate: Date().addingTimeInterval(60), timerInMinutes: 1, timerStatus: .paused, gradientBackground: true, welcomeBackText: "Welcome Back!", koanText: "Love is the way.", showKoan: true)
    }
    
    fileprivate static var alarm: WidgetExtensionAttributes.ContentState {
        WidgetExtensionAttributes.ContentState(targetDate: Date().addingTimeInterval(60), timerInMinutes: 1, timerStatus: .alarm, gradientBackground: true, welcomeBackText: "Welcome Back!", koanText: "Love is the way.", showKoan: true)
    }
    
    fileprivate static var preparing: WidgetExtensionAttributes.ContentState {
        WidgetExtensionAttributes.ContentState(targetDate: Date().addingTimeInterval(60), timerInMinutes: 1, timerStatus: .preparing, gradientBackground: true, welcomeBackText: "Welcome Back!", koanText: "Love is the way.", showKoan: true)
    }
    
    fileprivate static var stopped: WidgetExtensionAttributes.ContentState {
        WidgetExtensionAttributes.ContentState(targetDate: Date().addingTimeInterval(60), timerInMinutes: 1, timerStatus: .stopped, gradientBackground: true, welcomeBackText: "Welcome Back!", koanText: "Love is the way.", showKoan: true)
    }
}

#Preview("Notification", as: .content, using: WidgetExtensionAttributes.preview) {
    WidgetExtensionLiveActivity()
} contentStates: {
    WidgetExtensionAttributes.ContentState.running
    WidgetExtensionAttributes.ContentState.paused
    WidgetExtensionAttributes.ContentState.alarm
    WidgetExtensionAttributes.ContentState.preparing
    WidgetExtensionAttributes.ContentState.stopped
}
