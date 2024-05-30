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
        
    }

    // Fixed non-changing properties about your activity go here!
}

struct WidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WidgetExtensionAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Spacer()
                HStack {
                    switch context.state.timerStatus {
                    case .running:
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            WidgetButtonLabel(buttonState: .pause)
                        })
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.circle)
                        .tint(.accent)
                        
                        Button(intent: StopMeditation()) {
                            WidgetButtonLabel(buttonState: .stop)
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.circle)
                        .tint(.accent)
                        .padding(.trailing, 4)

                        ProgressView(timerInterval: context.state.targetDate.addingTimeInterval(-Double(context.state.timerInMinutes*60))...context.state.targetDate, countsDown: false) {
                                     Text("Meditation")
                                 } currentValueLabel: {
                                     Text(context.state.targetDate, style: .timer)
                                  }
                        .tint(.accent)
                        
                    case .alarm:
                        Spacer()
                        Text(context.state.welcomeBackText)
                        Spacer()
                    case .stopped:
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            WidgetButtonLabel(buttonState: .play)
                        })
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.circle)
                        .tint(.accent)
                        .padding(.trailing, 43)
                        
        //                Text(dateToDateFormatted(from: Date(), to: Date().addingTimeInterval(Double(timerInMinutes * 60))))
                        
                        ProgressView(value: 0.0) {
                                     Text("Meditation")
                                 } currentValueLabel: {
                                     Text(dateToDateFormatted(from: Date(), to: Date().addingTimeInterval(Double(context.state.timerInMinutes * 60))))
                                  }
                        .tint(.accent)
                        
                    case .paused:
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            WidgetButtonLabel(buttonState: .resume)
                        })
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.circle)
                        .tint(.accent)
                        
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            WidgetButtonLabel(buttonState: .stop)
                        })
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.circle)
                        .tint(.accent)
                        .padding(.trailing, 4)
                        
                        ProgressView(value: 0.0) {
                                     Text("Meditation")
                                 } currentValueLabel: {
                                     Text(dateToDateFormatted(from: Date(), to: Date().addingTimeInterval(Double(context.state.timerInMinutes * 60))))
                                  }
                        .tint(.accent)
                            
                    case .preparing:
                        Spacer()
                        Text(context.state.koanText)
                        Spacer()
                    }
                    
                }
                    
                Spacer()
            }
            .padding()
//            .background(context.state.gradientBackground ? LinearGradient(gradient: Gradient(colors: [.customGray2, .accent]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [.customGray2]), startPoint: .top, endPoint: .bottom))
            .activityBackgroundTint(nil)
//            .activitySystemActionForegroundColor(.blackAndWhite)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Circle()
                        .fill(.accent)
                        .frame(width: 25, height: 25)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    HStack {
//                        Spacer()
//                        Spacer()
//                        
                        if context.state.timerStatus == .running {
                            Text(context.state.targetDate, style: .timer)
                        } else {
                            Text(dateToDateFormatted(from: Date(), to: Date().addingTimeInterval(Double(context.state.timerInMinutes * 60))))
                                .font(.body)
                        }
                    }
                    .padding(.horizontal)
                    
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
                        
                        switch context.state.timerStatus {
                        case .running:
                            HStack {
                                Spacer()
                                
                                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                    Label("Pause", systemImage: "pause")
                                })
                                .font(.title2)
                                .buttonStyle(.borderedProminent)
                                .buttonBorderShape(.capsule)
                                .tint(.accent)
                                
                                Spacer()
                                
                                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                    Label("Stop", systemImage: "xmark")
                                })
                                .font(.title2)
//                                .fontWeight(.bold)
                                .buttonStyle(.borderedProminent)
                                .buttonBorderShape(.capsule)
                                .tint(.accent)
                                
                                Spacer()
                            }
                        case .alarm:
                            Text(context.state.welcomeBackText)
                                .font(.title2)
                                .padding(10)
                            
                        case .paused:
                            HStack {
                                Spacer()
                                
                                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                    Label("Resume", systemImage: "arrow.clockwise")
                                })
                                .font(.title2)
//                                .fontWeight(.bold)
                                .buttonStyle(.borderedProminent)
                                .buttonBorderShape(.capsule)
                                .tint(.accent)
                                
                                Spacer()
                                
                                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                    Label("Stop", systemImage: "xmark")
                                })
                                .font(.title2)
//                                .fontWeight(.bold)
                                .buttonStyle(.borderedProminent)
                                .buttonBorderShape(.capsule)
                                .tint(.accent)
                                
                                Spacer()
                            }
                        case .preparing:
                            Text(context.state.koanText)
                                .font(.title2)
                                .padding(10)
                            
                        case .stopped:
                            HStack {
                                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                    Label("Start", systemImage: "play.fill")
                                })
                                .font(.title2)
//                                .fontWeight(.bold)
                                .buttonStyle(.borderedProminent)
                                .buttonBorderShape(.capsule)
                                .tint(.accent)
                                
                            }
                        }
                    }
                }
            } compactLeading: {
                Circle()
                    .fill(.accent)
                    .frame(width: 25, height: 25)
                
            } compactTrailing: {
//                HStack {

                    
                    if context.state.timerStatus == .running {
                        Text(context.state.targetDate, style: .timer)
                    } else {
                        Text(dateToDateFormatted(from: Date(), to: Date().addingTimeInterval(Double(context.state.timerInMinutes * 60))))
                            .font(.body)
                    }
//                }
//                .padding(.horizontal)
            } minimal: {
                if context.state.timerStatus == .running {
                    
                    Text(context.state.targetDate, style: .timer)
                        .font(.caption2)
                } else {
                    Circle()
                        .fill(.accent)
                        .frame(width: 25, height: 25)
                }
            }
//            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(.accent)
        }
    }
}

struct WidgetButtonLabel: View {
    let buttonState: WidgetButtonState
    
    var body: some View {
        ZStack {
            Label(buttonState.rawValue.capitalized, systemImage: buttonState.symbolName)
                .fontWeight(.bold)
                .labelStyle(.iconOnly)
            
            if buttonState == .pause {
                Label("", systemImage: "xmark")
                    .fontWeight(.bold)
                    .labelStyle(.iconOnly)
                    .opacity(0.0)
            }
        }
        

    }
}

enum WidgetButtonState: String {
    case play, stop, pause, resume
    var symbolName: String {
        switch self {
        case .play:
            "play.fill"
        case .stop:
            "xmark"
        case .pause:
            "pause"
        case .resume:
            "arrow.clockwise"
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
        WidgetExtensionAttributes.ContentState(targetDate: Date().addingTimeInterval(60), timerInMinutes: 1, timerStatus: .running, gradientBackground: true, welcomeBackText: "Welcome Back!", koanText: "Love is the way.")
     }
     
     fileprivate static var paused: WidgetExtensionAttributes.ContentState {
         WidgetExtensionAttributes.ContentState(targetDate: Date().addingTimeInterval(60), timerInMinutes: 1, timerStatus: .paused, gradientBackground: true, welcomeBackText: "Welcome Back!", koanText: "Love is the way.")
     }
    
    fileprivate static var alarm: WidgetExtensionAttributes.ContentState {
        WidgetExtensionAttributes.ContentState(targetDate: Date().addingTimeInterval(60), timerInMinutes: 1, timerStatus: .alarm, gradientBackground: true, welcomeBackText: "Welcome Back!", koanText: "Love is the way.")
    }
    
    fileprivate static var preparing: WidgetExtensionAttributes.ContentState {
        WidgetExtensionAttributes.ContentState(targetDate: Date().addingTimeInterval(60), timerInMinutes: 1, timerStatus: .preparing, gradientBackground: true, welcomeBackText: "Welcome Back!", koanText: "Love is the way.")
    }
    
    fileprivate static var stopped: WidgetExtensionAttributes.ContentState {
        WidgetExtensionAttributes.ContentState(targetDate: Date().addingTimeInterval(60), timerInMinutes: 1, timerStatus: .stopped, gradientBackground: true, welcomeBackText: "Welcome Back!", koanText: "Love is the way.")
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
