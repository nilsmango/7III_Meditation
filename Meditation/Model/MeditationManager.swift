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
    
    let meditationSessionsPathComponent = "meditationSessions.data"
    
    func saveMeditationSessionsToDisk() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(meditationSessionsPathComponent)
        
        do {
            let data = try JSONEncoder().encode(meditationSessions)
            try data.write(to: fileURL)
        } catch {
            print("Error saving meditation sessions: \(error)")
        }
    }
    
    func loadMeditationSessionsFromDisk() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(meditationSessionsPathComponent)
        
        if let data = try? Data(contentsOf: fileURL) {
            do {
                let sessions = try JSONDecoder().decode([MeditationSession].self, from: data)
                meditationSessions = sessions
            } catch {
                print("Error loading meditation sessions: \(error)")
            }
        }
    }
    
    // MARK: Timer
    
    @AppStorage("meditationTimer") private var meditationTimerData: Data = Data()
    
    var meditationTimer: MeditationTimer {
        get {
            if let loadedData = try? JSONDecoder().decode(MeditationTimer.self, from: meditationTimerData) {
                return loadedData
            } else {
                return MeditationTimer(startDate: Date.distantPast, targetDate: Date.distantPast, timerInMinutes: 12, timerStatus: .stopped, preparationTime: 3, intervalActive: false, intervalTime: 60, endSound: .kitchenTimer, startSound: .kitchenTimer, intervalSound: .kitchenTimer, timeLeft: "12:00")
            }
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                meditationTimerData = encoded
            }
        }
    }
    
    let timerNotificationIdentifier = "Meditation Timer Notification"
    @Published var welcomeMessage = "Welcome Back!"
    @Published var startMessage = "Your Meditation has Started!"
    
    var timer = Timer()
    
    /// starting the meditation timer
    func startMeditation() {
        meditationTimer.startDate = Date.now.addingTimeInterval(Double(meditationTimer.preparationTime))
        meditationTimer.targetDate = Date.now.addingTimeInterval(Double(meditationTimer.preparationTime + meditationTimer.timerInMinutes * 60))
        
        // add a notification for the timer start
        let startContent = UNMutableNotificationContent()
        
        startContent.title = startMessage
        startContent.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: meditationTimer.startSound.rawNotificationSound))
        
        let startTargetDate = meditationTimer.startDate
        let startTriggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: startTargetDate)
        let startTrigger = UNCalendarNotificationTrigger(dateMatching: startTriggerDate, repeats: false)
        
        let startRequest = UNNotificationRequest(identifier: "Start", content: startContent, trigger: startTrigger)
        
        notificationCenter.add(startRequest) { error in
            if let error = error {
                print("Error: \(error)")
            }
        }
        
        // add a notification for the timer end
        let content = UNMutableNotificationContent()
        content.title = welcomeMessage
        content.body = "Your meditation is now complete."
        
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: meditationTimer.endSound.rawNotificationSound))
        
        let targetDate = meditationTimer.targetDate
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: timerNotificationIdentifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error: \(error)")
            }
        }
        
        meditationTimer.timerStatus = .preparing
        
        // already set timeLeft to the time to get it smooth in the view
        meditationTimer.timeLeft = dateToDateFormatted(from: meditationTimer.startDate.addingTimeInterval(1), to: meditationTimer.targetDate)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(meditationTimer.preparationTime)) {
                
            // Start timer and update timeLeft and everything.
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0 , repeats: true, block: { timer in
                let currentDate = Date.now
                
                if currentDate >= self.meditationTimer.targetDate {
                    self.endMeditation()
                    
                } else {
                    // update timeLeft string
                    self.meditationTimer.timeLeft = dateToDateFormatted(from: currentDate, to: self.meditationTimer.targetDate)
                }
            })
            }
    }
    
    func stopMeditation() {
        timer.invalidate()
        
        meditationTimer.timerStatus = .alarm
        
        
        // stop  notification
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [timerNotificationIdentifier])
        
        meditationTimer.targetDate = Date()
        saveMeditationSession()
    }
    
    func pauseMeditation() {
        
        timer.invalidate()
        
        meditationTimer.timerStatus = .paused
        
        // stop  notification
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [timerNotificationIdentifier])
        
        let currentDate = Date()
        
        // update the minutes to meditate (rounded up)
        let minutesLeftToMeditate = Int(ceil(meditationTimer.targetDate.timeIntervalSince(currentDate) / 60))
        meditationTimer.timerInMinutes = minutesLeftToMeditate
        
        meditationTimer.targetDate = currentDate
        saveMeditationSession()
    }
    
    func endMeditation() {
        
        timer.invalidate()
        meditationTimer.timerStatus = .alarm
        saveMeditationSession()
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
                    print("don't worry everything is good\(success)")
                    NSLog(" Integrated SuccessFully")
                }
            }
        
        }
        }
    
    func saveMeditationSession() {
        
        // update meditations array and save it
        let meditationSession = MeditationSession(startDate: meditationTimer.startDate, endDate: meditationTimer.targetDate)
        meditationSessions.append(meditationSession)
        saveMeditationSessionsToDisk()
        
        // save mindful session to health
        if HKHealthStore.isHealthDataAvailable() {
            
            // startTime and endTime are NSDate objects
            if let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession) {
                
                // we create our new object we want to push in Health app
                let mindfulSample = HKCategorySample(type:mindfulType, value: 0, start: meditationTimer.startDate, end: meditationTimer.targetDate)
                
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
}
