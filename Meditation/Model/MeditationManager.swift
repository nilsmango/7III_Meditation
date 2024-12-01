//
//  MeditationManager.swift
//  Meditation
//
//  Created by Simon Lang on 14.05.2024.
//

import Foundation
import SwiftUI
import HealthKit
import ActivityKit
import StoreKit

typealias Transaction = StoreKit.Transaction

public enum StoreError: Error {
    case failedVerification
}



class MeditationManager: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
        
    override init() {
        super.init()
        // Start a transaction listener as close to app launch as possible so you don't miss any transactions.
        updateListenerTask = listenForTransactions()
        
        Task {
            // During store initialization, request products from the App Store.
            await loadProductIdentifiersAndRequestProducts()
            
            await updateCustomerProductStatus()
        }
        
        appOpened += 1
        
        if appOpened > 0 && appOpened % 10 == 0 && self.currentAppVersion != self.lastVersionPromptedForReview  {
            self.showPromptForReview = true
            // The app already displayed the rating and review request view. Store this current version.
            self.lastVersionPromptedForReview = self.currentAppVersion
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    static let shared = MeditationManager()
    
    
    // MARK: - Statistics
    
    @Published var meditationSessions = [MeditationSession]()
    
    // calendar for everybody
    let calendar = Calendar.current
    
    /// Computed property to calculate total meditation duration for each day in the last month
    var meditationDurationPerDay: [Date: TimeInterval] {
        var durations: [Date: TimeInterval] = [:]
        
        let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: Date())!
        
        for session in meditationSessions {
            // Filter out sessions older than 30 days
            guard session.startDate >= thirtyDaysAgo else { continue }
            
            let startOfDay = calendar.startOfDay(for: session.startDate)
            let duration = session.endDate.timeIntervalSince(session.startDate)
            
            if let existingDuration = durations[startOfDay] {
                durations[startOfDay] = existingDuration + duration
            } else {
                durations[startOfDay] = duration
            }
        }
        
        // add 0 minute session for today if no session was done today
        let startOfToday = calendar.startOfDay(for: Date())
        let duration = 0.0
        
        if durations[startOfToday] == nil {
            durations[startOfToday] = duration
        }
        
        return durations
    }
    
    var averageMeditationsPerMonth: [DateComponents: TimeInterval] {
        var timePerMonth: [DateComponents: TimeInterval] = [:]
        
        // calculating total time per month
        for session in meditationSessions {
            let yearAndMonthComponent = calendar.dateComponents([.year, .month], from: session.startDate)
            let duration = session.endDate.timeIntervalSince(session.startDate)
            
            if var existingMonthData = timePerMonth[yearAndMonthComponent] {
                existingMonthData += duration
                timePerMonth[yearAndMonthComponent] = existingMonthData
            } else {
                timePerMonth[yearAndMonthComponent] = duration
            }
        }
        
        // getting the average per month
        for monthAndTime in timePerMonth {
            // get the days the month of the DateComponent has
            if let date = calendar.date(from: monthAndTime.key) {
                
                let currentMonthComponent = calendar.dateComponents([.year, .month], from: Date())
                
                if monthAndTime.key == currentMonthComponent {
                    // If it is the current month, count only days up to today
                    let numberOfDays = calendar.component(.day, from: Date())
                    let averagePerDay = monthAndTime.value / Double(numberOfDays)
                    timePerMonth[monthAndTime.key] = averagePerDay
                    
                } else {
                    // If it is a past month, count all days in the month
                    if let daysRange = calendar.range(of: .day, in: .month, for: date) {
                        let numberOfDays = daysRange.count
                        let averagePerDay = monthAndTime.value / Double(numberOfDays)
                        timePerMonth[monthAndTime.key] = averagePerDay
                    }
                }
            }
        }
        
        return timePerMonth
    }
    
    @AppStorage("healthPermission") var healthPermission = false
    
    let meditationSessionsPathComponent = "meditationSessions.data"
    
    /// gets the meditation sessions, either from the documents, or from health if provided
    private func getMeditationSessions() {
        // load meditation session from health if possible
        if HKHealthStore.isHealthDataAvailable() && healthPermission {
            loadMeditationSessionsFromHealth()
        } else {
            loadMeditationSessionsFromDisk()
        }
        
    }
    
    /// loading meditation sessions from health store
    private func loadMeditationSessionsFromHealth() {
        let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession)!

        let startDate = Date.distantPast // or a specific date
            let endDate = Date()
            
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
            
            let query = HKSampleQuery(sampleType: mindfulType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { (query, results, error) in
                guard error == nil else {
                    print("Error fetching mindfulness sessions from HealthKit: \(String(describing: error))")
                    return
                }
                
                guard let results = results as? [HKCategorySample] else {
                    print("Failed to cast results as [HKCategorySample]")
                    return
                }
                
                DispatchQueue.main.async {
                    var loadedMeditationSessions: [MeditationSession] = []
                    for sample in results {
                        let session = MeditationSession(startDate: sample.startDate, endDate: sample.endDate)
                        loadedMeditationSessions.append(session)
                    }
                    self.meditationSessions = loadedMeditationSessions
                    self.updateMeditationStatistics()
                }
            }
        
            healthStore.execute(query)
        }
    
    /// saving meditation sessions to disk (for if we have no health store available)
    private func saveMeditationSessionsToDisk() {
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
    
    /// loading meditation sessions from disk (for if we have no health store available)
    private func loadMeditationSessionsFromDisk() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(meditationSessionsPathComponent)
        
        if let data = try? Data(contentsOf: fileURL) {
            do {
                let sessions = try JSONDecoder().decode([MeditationSession].self, from: data)
                meditationSessions = sessions
                updateMeditationStatistics()
            } catch {
                print("Error loading meditation sessions: \(error)")
            }
        }
    }

    // updating the meditation statistics from the meditation sessions
    func updateMeditationStatistics() {
        // reverse the meditation sessions so we have the newest to oldest
        let sortedSessions = meditationSessions.reversed()
        
        // update current streak
        if let newestSession = sortedSessions.first {
            
            // Calculate the start of yesterday
            if let startOfYesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: Date())) {
                
                // last session was yesterday or today
                if newestSession.endDate >= startOfYesterday {

                    // Calculate the active streak length
                    var streakLength = 0
                    var lastSessionDate: Date? = nil
                    
                    for session in sortedSessions {
                        let sessionDate = calendar.startOfDay(for: session.endDate)
                        
                        if let lastDate = lastSessionDate {
                            let daysDifference = calendar.dateComponents([.day], from: sessionDate, to: lastDate).day!
                            
                            if daysDifference == 1 {
                                // The session is on the previous day of the last session
                                streakLength += 1
                                lastSessionDate = sessionDate
                            } else if daysDifference == 0 {
                                // The session is on the same day as the last session
                                continue
                            } else {
                                // The session is not on the previous day, break the streak
                                break
                            }
                        } else {
                            // First session in the streak
                            streakLength = 1
                            lastSessionDate = sessionDate
                        }
                    }

                    meditationTimer.statistics.currentStreak = streakLength
                    
                } else {
                    // no active streak
                    meditationTimer.statistics.currentStreak = 0
                }
            }
        }
        
        // Calculate the longest streak
        var lastSessionDate: Date? = nil
        var longestStreak = 0
        var currentStreak = 0
        
        for session in sortedSessions {
            let sessionDate = calendar.startOfDay(for: session.endDate)
            
            if let lastDate = lastSessionDate {
                let daysDifference = calendar.dateComponents([.day], from: sessionDate, to: lastDate).day!

                if daysDifference == 1 {
                    // The session is on the previous day of the last session
                    currentStreak += 1
                } else if daysDifference > 1 {
                    // The session is not on the previous day, reset the streak
                    longestStreak = max(longestStreak, currentStreak)
                    currentStreak = 0
                }
                // If daysDifference is 0, the session is on the same day, no change in streak
            } else {
                // First session in the streak
                currentStreak = 1
            }
            
            lastSessionDate = sessionDate
        }
        
        // Check the final streak
        longestStreak = max(longestStreak, currentStreak)
                
        meditationTimer.statistics.longestStreak = longestStreak
        
    }
    
        
    /// update the current streak when we are meditating
    /// use before saving the meditation session!
    private func updateCurrentStreak() {
        if meditationTimer.statistics.currentStreak > 0 {
            // get the last meditation session
            if let lastDate = meditationSessions.last?.endDate {
                if dateIsToday(date: lastDate) {
                    // keep the streak as is
                } else {
                    // +1!
                    meditationTimer.statistics.currentStreak += 1
                    updateLongestStreakFromCurrentStreak()
                }
            }
        } else {
            meditationTimer.statistics.currentStreak = 1
            updateLongestStreakFromCurrentStreak()
        }
    }
    
    private func dateIsToday(date: Date) -> Bool {
        let startOfToday = calendar.startOfDay(for: Date())
        
        return date >= startOfToday ? true : false
    }
    
    private func updateLongestStreakFromCurrentStreak() {
        if meditationTimer.statistics.currentStreak > meditationTimer.statistics.longestStreak {
            meditationTimer.statistics.longestStreak = meditationTimer.statistics.currentStreak
        }
    }
    

    
    
    // MARK: - Design
    
    @AppStorage("gradientBackground") var gradientBackground: Bool = true
    
    // MARK: - Timer
    
    @AppStorage("meditationTimer") private var meditationTimerData: Data = Data()
    
    var meditationTimer: MeditationTimer {
        get {
            if let loadedData = try? JSONDecoder().decode(MeditationTimer.self, from: meditationTimerData) {
                return loadedData
            } else {
                return MeditationTimer(startDate: Date.distantPast, targetDate: Date.distantPast, timerInMinutes: 12, timerStatus: .stopped, preparationTime: 3, intervalActive: false, intervalTime: 60, endSound: TimerSound(name: "Friendly End", fileName: "Friendly End.caf"), startSound: TimerSound(name: "Friendly", fileName: "Friendly.caf"), secondReminder: false, intervalSound: TimerSound(name: "Kitchen Timer", fileName: "Kitchen Timer Normal.caf"), reminderSound: TimerSound(name: "Dual Bowl", fileName: "Dual Bowl.caf"), showKoan: true, koans: ["Let go or be dragged.", "Love is the way.", "Have a great flight.", "What is the sound of one hand clapping?", "May all beings be happy and free from suffering.", "You miss 100% of the shots you don’t take.\n- Wayne Gretzky\n- Michael Scott", "Let it be.", "Don't panic.", "Be here now.", "Know your self.", "If you meet the Buddha, kill him.", "Don’t seek the truth; just drop your opinions."], statistics: MeditationStatistics(currentStreak: 0, longestStreak: 0))
            }
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                meditationTimerData = encoded
            }
        }
    }
    
    let timerNotificationIdentifier = "Meditation Timer Notification"
    let secondTimerNotificationIdentifier = "Second Meditation Timer Notification"
    
    @AppStorage("welcomeMessage") var welcomeMessage = "Welcome Back!"
    @AppStorage("startMessage") var startMessage = "Your Meditation has Started!"
    @AppStorage("backgroundNote") var backgroundNote = ""
    
    var timer: Timer?
    
    /// starting the meditation timer
    func startMeditation() {
        meditationTimer.startDate = Date.now.addingTimeInterval(Double(meditationTimer.preparationTime))
        meditationTimer.targetDate = Date.now.addingTimeInterval(Double(meditationTimer.preparationTime + meditationTimer.timerInMinutes * 60))
        
        // add a notification for the timer start
        let startContent = UNMutableNotificationContent()
        
        startContent.title = startMessage
        startContent.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: meditationTimer.startSound.fileName))
        
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
//        content.body = "Your meditation is now complete."
        
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: meditationTimer.endSound.fileName))
        
        let targetDate = meditationTimer.targetDate
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: timerNotificationIdentifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error: \(error)")
            }
        }
        
        // add second notification at end if activated
        if meditationTimer.secondReminder  {
            let content = UNMutableNotificationContent()
            content.title = welcomeMessage
            
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: meditationTimer.endSound.fileName))
            
            let targetDate = meditationTimer.targetDate.addingTimeInterval(10)
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            
            let request = UNNotificationRequest(identifier: secondTimerNotificationIdentifier, content: content, trigger: trigger)
            
            notificationCenter.add(request) { error in
                if let error = error {
                    print("Error: \(error)")
                }
            }
        }
        
        
        meditationTimer.timerStatus = .preparing
        
        // setting the timer status change
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: Double(meditationTimer.preparationTime) + Double(meditationTimer.timerInMinutes * 60) , repeats: false, block: { timer in
            self.endMeditation()
        })
        
        startStatusTimer(updateInterval: updateInterval)
        
        // start live activity
        startActivity()
        
        // update the current streak
        updateCurrentStreak()
        
        // save meditation session
        saveMeditationSession()
    }
    
    func checkStatusOfTimer() {
        timer?.invalidate()
        if meditationTimer.timerStatus == .running {
            if meditationTimer.targetDate >= Date() {
                // start timer to targetDate again
                let timeInterval = meditationTimer.targetDate.timeIntervalSinceNow
                timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { timer in
                    print("running the check and ending with timer")
                    self.endMeditation()
                })
            } else {
                print("ending normal with check")
                endMeditation()
            }
        }
    }
    
    func stopMeditation(withSaving: Bool = true) {
        
        // little security thing to make sure the button was not pressed after meditation ended
        if Date() >= meditationTimer.targetDate {
            stopActivity()
            meditationTimer.timerStatus = .stopped
            
        } else {
            timer?.invalidate()
            stopStatusTimer()
            
            meditationTimer.timerStatus = .alarm
            
            // stop  notifications
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [timerNotificationIdentifier, secondTimerNotificationIdentifier])
            
            // edit meditation session
            meditationTimer.targetDate = Date()
            
            editMeditationSession(withSaving: withSaving)
            
            // add a notification for the timer end
            let content = UNMutableNotificationContent()
            content.title = welcomeMessage
            content.body = "Your meditation is now complete."
            
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: meditationTimer.endSound.fileName))
            
            let targetDate = meditationTimer.targetDate.addingTimeInterval(1.2)
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            
            let request = UNNotificationRequest(identifier: timerNotificationIdentifier, content: content, trigger: trigger)

            notificationCenter.add(request) { error in
                if let error = error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func pauseMeditation() {
        
        // little security thing to make sure the button was not pressed after meditation ended
        if Date() >= meditationTimer.targetDate {
            stopActivity()
            meditationTimer.timerStatus = .stopped
            
        } else {
            timer?.invalidate()
            stopStatusTimer()
            
            meditationTimer.timerStatus = .paused
            
            // stop  notification
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [timerNotificationIdentifier, secondTimerNotificationIdentifier])
            
            let currentDate = Date()
            
            // update the minutes to meditate (rounded up)
            let minutesLeftToMeditate = Int(ceil(meditationTimer.targetDate.timeIntervalSince(currentDate) / 60))
            meditationTimer.timerInMinutes = minutesLeftToMeditate
            
            meditationTimer.targetDate = currentDate.addingTimeInterval(TimeInterval(minutesLeftToMeditate*60 + meditationTimer.preparationTime))
            
            // edit meditation session
            editMeditationSession(pause: true)
        }
    }
    
    func endMeditation() {
        if meditationTimer.timerStatus == .running || meditationTimer.timerStatus == .paused {
            meditationTimer.timerStatus = .alarm
            
            stopActivity()
        }
    }
    
    /// returns a random koan
    private func makeKoanOfTheDay() {
        koanOfTheDay = meditationTimer.koans.randomElement() ?? "If you meet the Buddha, kill him."
    }
    
    func deleteKoan(at offsets: IndexSet) {
        meditationTimer.koans.remove(atOffsets: offsets)
    }
    
    func addKoan(text: String) {
        meditationTimer.koans.append(text)
    }
    
    // MARK: - Notifications
    
    private let notificationCenter = UNUserNotificationCenter.current()
    let soundOptions = [
        TimerSound(name: "Synth Bell", fileName: "Synth Bell.caf"),
        TimerSound(name: "Basic Bells 1", fileName: "Basic Bells 1.caf"),
        TimerSound(name: "Basic Bells 2", fileName: "Basic Bells 2.caf"),
        TimerSound(name: "Basic Bells 3", fileName: "Basic Bells 3.caf"),
        TimerSound(name: "Chimes", fileName: "Chimes.caf"),
        TimerSound(name: "Chimes 2", fileName: "Chimes 2.caf"),
        TimerSound(name: "Chimes 3", fileName: "Chimes 3.caf"),
        TimerSound(name: "Chimes 4", fileName: "Chimes 4.caf"),
        TimerSound(name: "Dual Bowl", fileName: "Dual Bowl.caf"),
        TimerSound(name: "Friendly", fileName: "Friendly.caf"),
        TimerSound(name: "Friendly End", fileName: "Friendly End.caf"),
        TimerSound(name: "Gong 2", fileName: "Gong 2.caf"),
        TimerSound(name: "Gong 2b", fileName: "Gong 2b.caf"),
        TimerSound(name: "Metallophone", fileName: "Metallophone.caf"),
        TimerSound(name: "Singing Bowl 1", fileName: "Singing Bowl 1.caf"),
        TimerSound(name: "Singing Bowl 2", fileName: "Singing Bowl 2.caf"),
        TimerSound(name: "Singing Bowl 2b", fileName: "Singing Bowl 2b.caf"),
        TimerSound(name: "Kitchen Timer", fileName: "Kitchen Timer Normal.caf")
    ]
    
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
    
    // MARK: - Meditation Circle View
    
    var statusTimer: Timer?
    @Published var circleProgress = 0.0
    var updateInterval = 1.0
    var koanOfTheDay = "Let go or get dragged."
    
    func startStatusTimer(updateInterval: Double) {
        stopStatusTimer()
        self.updateInterval = updateInterval
        updateProgress()
        
        statusTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { _ in
            self.updateProgress()
        }
    }
    
    private func stopStatusTimer() {
        circleProgress = 0.0
        statusTimer?.invalidate()
        statusTimer = nil
    }
    
    private func updateProgress() {
        let elapsedTime = Date().timeIntervalSince(meditationTimer.startDate) + updateInterval
        let totalDuration = Double(meditationTimer.timerInMinutes * 60)
        circleProgress = elapsedTime / totalDuration
        
        if Date() >= meditationTimer.targetDate.addingTimeInterval(3) {
            endMeditation()
            stopStatusTimer()
        }
    }
    
    
    
    // MARK: HealthKit
    
    let healthStore = HKHealthStore()
    
    func startupChecks() {
        
        if HKHealthStore.isHealthDataAvailable() {
            
            let typesToRead = Set([
                HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!
            ])
            
            let typesToShare = Set([
                HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!
            ])
            
            healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) -> Void in
                DispatchQueue.main.async {
                    if success == false {
                        print("Couldn't get get Health Store authorization")
                        self.healthPermission = false
                        self.getMeditationSessions()
                    }
                    if success == true {
                        print("Health Store authorization granted")
                        self.healthPermission = true
                        self.getMeditationSessions()
                    }
                }
            }
        }
        
        makeKoanOfTheDay()
        checkStatusOfTimer()
    }
    
    func saveMeditationSession() {
        
        // update meditations array and save it either to disk or to health if available
        let meditationSession = MeditationSession(startDate: meditationTimer.startDate, endDate: meditationTimer.targetDate)
        meditationSessions.append(meditationSession)
        
        if healthPermission {
            // save mindful session to health
            if HKHealthStore.isHealthDataAvailable() {
                
                // startTime and endTime are NSDate objects
                if let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession) {
                    
                    // we create our new object we want to push in Health app
                    let mindfulSample = HKCategorySample(type:mindfulType, value: 0, start: meditationTimer.startDate, end: meditationTimer.targetDate)
                    
                    // at the end, we save it
                    healthStore.save(mindfulSample, withCompletion: { (success, error) -> Void in
                        
                        if error != nil {
                            // something happened, let's just save to disk
                            self.saveMeditationSessionsToDisk()
                            return
                        }
                        
                        if success {
                            print("New meditation data was saved in HealthKit")
                            
                        } else {
                            // something happened again
                            self.saveMeditationSessionsToDisk()
                        }
                        
                    })
                }
            }
        } else {
            saveMeditationSessionsToDisk()
        }
    }
    
    func editMeditationSession(pause: Bool = false, withSaving: Bool = true) {
        // update activity
        updateActivity(pause: pause)
        
        // remove the last saved meditation from array
        if withSaving {
            meditationSessions.removeLast()
            
            // remove last saved mindful session from health
            if HKHealthStore.isHealthDataAvailable() {
                deleteLastMindfulSession {
                    // Save new meditation session only after the last mindful session is deleted
                    self.saveMeditationSession()
                }
                
            }
        }
        
        if meditationTimer.timerStatus == .alarm || meditationTimer.timerStatus == .stopped {
            stopActivity()
        }
    }
    
    private func deleteLastMindfulSession(completion: @escaping () -> Void) {
        guard let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession) else {
            print("Mindful session type not available")
            DispatchQueue.main.async {
                completion()
            }
            return
        }
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: mindfulType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { query, samples, error in
            guard let sample = samples?.first as? HKCategorySample, error == nil else {
                print("Error fetching last mindful session: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            
            self.healthStore.delete(sample) { success, error in
                if success {
                    print("Successfully deleted the last mindful session")
                } else {
                    print("Error deleting the last mindful session: \(error?.localizedDescription ?? "Unknown error")")
                }
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
        
        healthStore.execute(query)
    }
    
    // MARK: - Widget Extension
    
    private var activity: Activity<WidgetExtensionAttributes>? = nil
    
    private func startActivity() {
        
        // schedule update
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(meditationTimer.preparationTime)) {
            self.updateActivity(switchToRunning: true)
        }
        
        if activity == nil {
            let attributes = WidgetExtensionAttributes()
            let state = WidgetExtensionAttributes.ContentState(targetDate: meditationTimer.targetDate, timerInMinutes: meditationTimer.timerInMinutes, timerStatus: meditationTimer.timerStatus, gradientBackground: gradientBackground, welcomeBackText: welcomeMessage, koanText: koanOfTheDay, showKoan: meditationTimer.showKoan)
            let content = ActivityContent(state: state, staleDate: meditationTimer.targetDate)
            
            do {
                activity = try Activity<WidgetExtensionAttributes>.request(
                    attributes: attributes,
                    content: content,
                    pushType: nil
                )
                print("Activity started")
            } catch {
                print("Failed to start activity: \(error)")
            }
        } else {
            updateActivity()
        }        
    }
    
    private func stopActivity() {
        
//        let state = WidgetExtensionAttributes.ContentState(targetDate: meditationTimer.targetDate, timerInMinutes: meditationTimer.timerInMinutes, timerStatus: meditationTimer.timerStatus, gradientBackground: gradientBackground, welcomeBackText: welcomeMessage, koanText: koanOfTheDay, showKoan: meditationTimer.showKoan)
//        let content = ActivityContent(state: state, staleDate: Date().addingTimeInterval(1.7))
        
        Task {
            // TODO: test if this nil does work better than the content I have used (should work better)
            await activity?.end(nil, dismissalPolicy: .immediate)
            self.activity = nil
            print("Activity ended")
            }
    }
    
    private func updateActivity(switchToRunning: Bool = false, pause: Bool = false) {
        if switchToRunning {
            print("switching to running now!")
        }
        let state = WidgetExtensionAttributes.ContentState(
            targetDate: meditationTimer.targetDate,
            timerInMinutes: meditationTimer.timerInMinutes,
            timerStatus: switchToRunning ? .running : meditationTimer.timerStatus,
            gradientBackground: gradientBackground,
            welcomeBackText: welcomeMessage,
            koanText: koanOfTheDay,
            showKoan: meditationTimer.showKoan
        )
        let content = ActivityContent(state: state, staleDate: pause ? Date.distantFuture : meditationTimer.targetDate)

        Task {
            await activity?.update(content)
            print("Activity updated, pause was \(pause)")
        }
    }
    
    // MARK: - Meditation Reminders
    @AppStorage("reminders") private var remindersData: Data = Data()
    
    let remindersIdentifier = "Meditation Reminders Identifier"
    
    var reminders: Reminders {
        get {
            if let loadedData = try? JSONDecoder().decode(Reminders.self, from: remindersData) {
                return loadedData
            } else {
                return Reminders(activateReminders: false, remindAgain: false, reminderStyle: .manual, reminderTime: Date.now)
            }
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                remindersData = encoded
            }
        }
    }
    
    func updateReminders() {
        
        // stopp all reminders notifications
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [remindersIdentifier])
        
        if reminders.activateReminders {
            // add a notification for the reminder
            let content = UNMutableNotificationContent()
            content.title = "Time to Meditate!"
    //        content.body = "Your meditation is now complete."
            
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: meditationTimer.reminderSound.fileName))
            
            let targetDate = reminders.reminderTime
            let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: targetDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
            
            let request = UNNotificationRequest(identifier: remindersIdentifier, content: content, trigger: trigger)

            notificationCenter.add(request) { error in
                if let error = error {
                    print("Error: \(error)")
                }
            }
        }
        
    }
    
    // MARK: - In App Purchases
        
    @AppStorage("Premium") var hasPurchasedPremium = false
    @Published var purchasedProducts = [Product]()
    @Published var premiumProducts: [Product] = []
    @Published var unableToLoadProducts = false
   
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    @MainActor
    func loadProductIdentifiersAndRequestProducts() async {
            guard let url = Bundle.main.url(forResource: "product_ids", withExtension: "plist") else {
                fatalError("Unable to resolve url for in the bundle.")
            }
            do {
                unableToLoadProducts = false
                let data = try Data(contentsOf: url)
                if let productIdentifiers = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as? [String] {
                    await requestProducts(productIdentifiers: productIdentifiers)
                }
            } catch {
                unableToLoadProducts = true
                print("\(error.localizedDescription)")
            }
        }
    
    private func requestProducts(productIdentifiers: [String]) async {
        do {
            // Request products from the App Store using the identifiers that the `product_ids.plist` file defines.
            let products = try await Product.products(for: productIdentifiers)
            DispatchQueue.main.async {
                self.premiumProducts = products
            }

        } catch {
            print("Failed product request from the App Store server. \(error)")
            DispatchQueue.main.async {
                self.unableToLoadProducts = true
            }
        }
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            // Iterate through any transactions that don't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)

                    // Deliver products to the user.
                    await self.updateCustomerProductStatus()

                    // Always finish a transaction.
                    await transaction.finish()
                } catch {
                    // StoreKit has a transaction that fails verification. Don't deliver content to the user.
                    print("Transaction failed verification.")
                }
            }
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        // Check whether the JWS passes StoreKit verification.
        switch result {
        case .unverified:
            // StoreKit parses the JWS, but it fails verification.
            throw StoreError.failedVerification
        case .verified(let safe):
            // The result is verified. Return the unwrapped value.
            return safe
        }
    }
    
    @MainActor
    func updateCustomerProductStatus() async {
        
        var currentEntitledPurchases: [Product] = []

        // Iterate through all of the user's purchased products.
        for await result in Transaction.currentEntitlements {
            do {
                // Check whether the transaction is verified. If it isn’t, catch `failedVerification` error.
                let transaction = try checkVerified(result)

                // Check the `productType` of the transaction and get the corresponding product from the store.
                switch transaction.productType {
                case .nonConsumable:
                    if let premium = premiumProducts.first(where: { $0.id == transaction.productID }) {
                        currentEntitledPurchases.append(premium)
                    }
                case .nonRenewable:
                    // we don't have this in our purchases
                    break
                case .autoRenewable:
                    // we don't have this in our purchases
                    break
                default:
                    break
                }
            } catch {
                print("Something went wrong")
            }
        }
        
        // Update the store information with the purchased products.
        purchasedProducts = currentEntitledPurchases
        hasPurchasedPremium = !currentEntitledPurchases.isEmpty
    }
    
    func purchase(product: Product) async throws -> Transaction? {
        // Begin purchasing the `Product` the user selects.
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            // Check whether the transaction is verified. If it isn't,
            // this function rethrows the verification error.
            let transaction = try checkVerified(verification)

            // The transaction is verified. Deliver content to the user.
            await updateCustomerProductStatus()

            // Always finish a transaction.
            await transaction.finish()

            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
        
    func createImageForPurchasedProduct(product: Product? = nil) -> Image {
        let id = product?.id ?? purchasedProducts.first?.id
        if id != nil {
            return Image("PremiumTap")
        }
        return Image("NormalTap")
    }
    
    func isWillRenew(product: Product) async -> Bool? {
        guard let SubscriptionGroupStatus = try? await product.subscription?.status.first else {
            print("There is no AutoRenewable Group")
            return nil
        }
        
        guard case .verified(let renewalInfo) = SubscriptionGroupStatus.renewalInfo else {
            print("The App Store could not verify your subscription status.")
            return nil
        }
        return renewalInfo.willAutoRenew
    }
    
    // MARK: - Review Reminder
    
    /// The most recent app version that prompts for a review.
    @AppStorage("lastVersionPromptedForReview") var lastVersionPromptedForReview = ""
    @AppStorage("timesOpened") var appOpened = 0
    @Published var showPromptForReview = false
    
    let currentAppVersion: String = {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "Unknown"
        }
        return version
    }()
}
