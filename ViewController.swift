//
//  ViewController.swift
//  Test Notif
//
//  Created by Kevin Jonathan on 31/05/23.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBAction func onTapped(_ sender: UIButton) {
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    self.scheduleNotification()
                    // Schedule Local Notification
                })
            case .authorized:
                self.scheduleNotification()
            case .denied:
                print("Application Not Allowed to Display Notifications")
            case .provisional:
                return
            case .ephemeral:
                return
            @unknown default:
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }

            completionHandler(success)
        }
    }
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Write in your journal"
        content.body = "Take a few minutes to write down your thoughts and feelings."
        content.sound = UNNotificationSound.default

        let date = Date()
        
        let updatedDate = date.addingTimeInterval(60)

        var dateComponents = DateComponents()
        let calendar = Calendar.current
        dateComponents.year = calendar.component(.year, from: updatedDate)
        dateComponents.month = calendar.component(.month, from: updatedDate)
        dateComponents.day = calendar.component(.day, from: updatedDate)
        dateComponents.hour = calendar.component(.hour, from: updatedDate)
        dateComponents.minute = calendar.component(.minute, from: updatedDate)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: "journalReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Success")
            }
        }
    }
}
