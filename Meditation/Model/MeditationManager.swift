//
//  MeditationManager.swift
//  Meditation
//
//  Created by Simon Lang on 14.05.2024.
//

import Foundation
import SwiftUI
import HealthKit

class MeditationManager: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
    
    // MARK: History
    
    @Published var meditationSessions = [MeditationSession]()
    
    // MARK: Timer
    
    @Published var meditationTimer = MeditationTimer(targetDate: Date.distantFuture, timerInMinutes: 10.0, running: .stopped)
    
    // Timer time in minutes
    @AppStorage("selectedMinutes") var selectedMinutes = 60
    
    // Preparation time in seconds
    @AppStorage("preparationTime") var preparationTime = 3
    
    /// starting the meditation timer
    func startTimer() {
        meditationTimer.timerInMinutes = Double(selectedMinutes)
        meditationTimer.targetDate = Date.now.addingTimeInterval(Double(preparationTime + selectedMinutes * 60))
        
        // add a notification for the timer
        let content = UNMutableNotificationContent()
        content.title = "Welcome Back!"
        content.body = "Your meditation is now complete."
        
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "Kitchen Timer Normal.caf"))
        
        let targetDate = meditationTimer.targetDate
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: "Meditation Timer Notification", content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error: \(error)")
            }
        }
//        withAnimation {
            meditationTimer.running = .preparing
//        }
    }
    
    // MARK: Notifications
    private let notificationCenter = UNUserNotificationCenter.current()
    
    // This method will be called when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show an banner and play a sound
        completionHandler([.banner, .sound])
    }
    
    // Handle notification when the user taps on it
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        // Handle user's response to the notification
//        let identifier = response.notification.request.identifier
//        
//        // Extract information from the notification content and perform actions
//        if let recipeTitle = identifier.components(separatedBy: Constants.notificationSeparator).first {
//            // change path to the recipe of the notification
//            if let recipeIndex = recipes.firstIndex(where: { $0.title == recipeTitle }) {
//                path = NavigationPath()
//                path.append(recipes[recipeIndex])
//            }
//        }
//        
//        completionHandler()
//    }
    
    
    
    // MARK: HealthKit
    
    let healthStore = HKHealthStore()
    
    func activateHealthKit() {
        
        if HKHealthStore.isHealthDataAvailable() {
            
        
            let typestoRead = Set([
                HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!
                ])
            
            let typestoShare = Set([
                HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!
                ])
            
            self.healthStore.requestAuthorization(toShare: typestoShare, read: typestoRead) { (success, error) -> Void in
                if success == false {
                    print("couldn't get get authorization")
                    NSLog(" Display not allowed")
                }
                if success == true {
                    print("dont worry everything is good\(success)")
                    NSLog(" Integrated SuccessFully")
                }
            }
        
        }
        }
    
    func saveMeditationSession() {
            
            // startTime and endTime are NSDate objects
            if let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession) {
                
                // we create our new object we want to push in Health app
                let mindfulSample = HKCategorySample(type:mindfulType, value: 0, start: meditationTimer.targetDate.addingTimeInterval(-Double(meditationTimer.timerInMinutes * 60)), end: meditationTimer.targetDate)
                
                // at the end, we save it
                healthStore.save(mindfulSample, withCompletion: { (success, error) -> Void in
                    
                    if error != nil {
                        // something happened
                        return
                    }
                    
                    if success {
                        print("New meditation data was saved in HealthKit")
                        
                    } else {
                        // something happened again
                    }
                    
                })
            
            }
            
        }
}
