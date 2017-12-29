//
//  TimerViewController.swift
//  Egg Timer
//
//  Created by Thomas Kirk on 17/12/2017.
//  Copyright © 2017 OneKirk. All rights reserved.
//

import UIKit
import UserNotifications

class TimerViewController: UIViewController {
    
    // Variable declaration
    var timer: Timer = Timer()
    var userSelectedTime: Int = 0
    var time: Int = Int()
    var startTime: NSDate = NSDate()
    var endTime: NSDate = NSDate()
    var timeString: String = String()
    var content: UNMutableNotificationContent = UNMutableNotificationContent()
    let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
    var wasSendToBackground: Bool = false

    // Outlets
    @IBOutlet weak var resultLabel: UILabel!
    
    // IBActions
    @IBAction func pauseButton(_ sender: Any) {
        timer.invalidate()
        center.removeAllPendingNotificationRequests()
    }
  
    @IBAction func playButton(_ sender: Any) {
        // Creating the timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(processTimer), userInfo: nil, repeats: true)
        setupNotifications()
        endTime = startTime.addingTimeInterval(TimeInterval(time))
    }
    
    @IBAction func resetButton(_ sender: Any) {
        timer.invalidate()
        center.removeAllPendingNotificationRequests()
        
        time = userSelectedTime
        convertToMinuttesAndSeconds(userSeconds: userSelectedTime)
        resultLabel.text = timeString
    }
    
    // Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        time = userSelectedTime
        convertToMinuttesAndSeconds(userSeconds: time)
        resultLabel.text = timeString
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        // Requesting access to local notifications
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            print(granted)
            print(error ?? "No Error")
        }
    }
    
    @objc func applicationDidEnterBackground() {

        UserDefaults.standard.set(endTime, forKey: "endTime")
        wasSendToBackground = true
    }
    
    @objc func applicationDidBecomeActive() {
        if wasSendToBackground {
            
            wasSendToBackground = false
            
            if let remainingTime = UserDefaults.standard.object(forKey: "endTime") as? NSDate {
                
                time = Int(remainingTime.timeIntervalSinceNow)
                
                if time > 0 {
                    convertToMinuttesAndSeconds(userSeconds: time)
                    resultLabel.text = timeString
                } else {
                    resultLabel.text = "00:00"
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func processTimer() {
        
        if time > 0 {
            time -= 1
            convertToMinuttesAndSeconds(userSeconds: time)
            resultLabel.text = timeString
        } else {
            timer.invalidate()
        }
    }
    
    func convertToMinuttesAndSeconds(userSeconds: Int) {
        
        var minutesToString = String()
        var secondsToString = String()
        
        if userSeconds / 60 < 10 {
            minutesToString = "0\(userSeconds / 60)"
        } else {
            minutesToString = "\(userSeconds / 60)"
        }
        
        if userSeconds % 60 < 10 {
            secondsToString = "0\(userSeconds % 60)"
        } else {
            secondsToString = "\(userSeconds % 60)"
        }
        
        timeString = minutesToString + ":" + secondsToString
    }
    
    func setupNotifications() {
        // Defining the content of the local notification
        content.title = "Your eggs are done!"
        content.body = "Enjoy the perfect eggs"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "TIMER_EXPIRED"
        content.setValue(true, forKey: "shouldAlwaysAlertWhileAppIsForeground")
        
        // Defining trigger,request and requesting authorization.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(time), repeats: false)
        let request = UNNotificationRequest(identifier: "Timer expired", content: content, trigger: trigger)
        
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
                }
            }
        }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        }
    }
