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
    
    @AppStorage("meditationTimer") private var meditationTimerData: Data = Data()
    
    var meditationTimer: MeditationTimer {
        get {
            if let loadedData = try? JSONDecoder().decode(MeditationTimer.self, from: meditationTimerData) {
                return loadedData
            } else {
                return MeditationTimer(targetDate: Date.distantFuture, timerInMinutes: 12, timerStatus: .stopped, preparationTime: 3, intervalActive: false, intervalTime: 60, timerSound: .kitchenTimer, intervalSound: .kitchenTimer)
            }
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                meditationTimerData = encoded
            }
        }
    }
        
    /// starting the meditation timer
    func startTimer() {
        meditationTimer.targetDate = Date.now.addingTimeInterval(Double(meditationTimer.preparationTime + meditationTimer.timerInMinutes * 60))
        
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
        
        meditationTimer.timerStatus = .preparing
    }
    
    /// returns a random koan
    func koanFunc() -> String {
        let koanArray: [String] = ["Love is the way.", "Have a great flight.", "What is the sound of one hand clapping?", "May all beings be happy and free from suffering.", "You miss 100% of the shots you don’t take.\n– Wayne Gretzky\n- Michael Scott", "Let it be.", "Don't panic.", "Be here now.", "Know your self.", "If you meet the Buddha, kill him."]
        return koanArray.randomElement() ?? "If you meet the Buddha, kill him."
    }
    
    // MARK: Notifications
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    // This method will be called when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Play a sound
        completionHandler([.sound])
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
