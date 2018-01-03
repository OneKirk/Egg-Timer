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
    var accessToNotifications: Bool = false

    // Outlets
    @IBOutlet weak var resultLabel: UILabel!

    // IBActions
    @IBAction func pauseButton(_ sender: Any) {
        timer.invalidate()
        center.removeAllPendingNotificationRequests()
    }

    @IBAction func playButton(_ sender: Any) {
        // Creating the timer
        if time > 0 {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(processTimer), userInfo: nil, repeats: true)
            setupNotifications()
            endTime = startTime.addingTimeInterval(TimeInterval(time))
            
            requestingAccessToSendNotifications()
        }
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
        
        // Adding observers to detect transition to/from background state
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        accessToNotifications = UserDefaults.standard.bool(forKey: "accessToNotifications")
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
        content.title = NSLocalizedString("Eggs are done", comment: "message")
        content.body = NSLocalizedString("Perfect eggs", comment: "message")
        content.sound = UNNotificationSound.init(named: "bell.mp3")
        content.categoryIdentifier = "TIMER_EXPIRED"
        content.setValue(true, forKey: "shouldAlwaysAlertWhileAppIsForeground")
        
        // Defining trigger,request and requesting authorization.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(time), repeats: false)
        let request = UNNotificationRequest(identifier: "Timer expired", content: content, trigger: trigger)
        
        // Sending the request to Notification Center
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
                }
            }
        }

    func requestingAccessToSendNotifications() {
        
        if accessToNotifications == false {
         
            // Setting up the alert controller
            let alertController = UIAlertController(title: NSLocalizedString("Soft push titel", comment: "message"), message: NSLocalizedString("Soft push message", comment: "message"), preferredStyle: UIAlertControllerStyle.alert)
            
            // Adding actions to alert controller
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Soft push action NO", comment: "message"), style: .default, handler: { (action) in
                
                let alertController = UIAlertController(title: NSLocalizedString("Soft push decline titel", comment: "message"), message: NSLocalizedString("Soft push decline message", comment: "message"), preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Soft push decline action OK", comment: "message"), style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                }))

                self.present(alertController, animated: true, completion: nil)
            }))

            alertController.addAction(UIAlertAction(title: NSLocalizedString("Soft push action YES", comment: "message"), style: .default, handler: { (action) in
                
                self.dismiss(animated: true, completion: nil)
                
                self.accessToNotifications = true
                    
                UserDefaults.standard.set(self.accessToNotifications, forKey: "accessToNotifications")
                
                // Requesting access to local notifications
                self.center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                    if granted == false {
                        let alertController = UIAlertController(title: NSLocalizedString("Hard push decline titel", comment: "message"), message: NSLocalizedString("Hard push decline message", comment: "message"), preferredStyle: UIAlertControllerStyle.alert)
                        
                        alertController.addAction(UIAlertAction(title: NSLocalizedString("Hard push decline action OK", comment: "message"), style: .default, handler: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        }))

                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }))

            self.present(alertController, animated: true, completion: nil)
        }
    }

    // Removing observers for notification center
    deinit {
        NotificationCenter.default.removeObserver(self)
        }
    }
