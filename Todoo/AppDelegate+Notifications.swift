//
//  AppDelegate+Notifications.swift
//  Todoo
//
//  Created by Florent Morin on 22/04/2018.
//  Copyright © 2018 SUP'TG Niort. All rights reserved.
//

import UIKit
import UserNotifications
import Intents

extension AppDelegate {

    /// Ensure user allow notifications
    internal func prepareForReceivingNotifications() {
        let center = UNUserNotificationCenter.current()

        let options: UNAuthorizationOptions = [.alert, .sound, .badge]

        let doneAction = UNNotificationAction(identifier: "TaskDoneAction",
                                              title: "Terminé", options: [.destructive])
        let laterAction = UNNotificationAction(identifier: "TaskLaterAction",
                                               title: "Plus tard", options: [])
        let taskCategory = UNNotificationCategory(
            identifier: "TaskCategory",
            actions: [doneAction, laterAction],
            intentIdentifiers: [], options: [])
        center.setNotificationCategories([taskCategory])

        center.delegate = self

        center.requestAuthorization(options: options) { result, _ in
            // do what you want here ;-)
            INPreferences.requestSiriAuthorization { _ in
            }
        }
    }

    /// Create a notification request from a badge
    fileprivate func createNotificationRequest(with task: Task, badge: Int) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = "Rappel"
        content.body = task.detail!
        content.sound = UNNotificationSound.default()
        content.badge = badge as NSNumber

        let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let triggerDate = Calendar.current.dateComponents(components, from: task.dueAt!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let identifier = task.objectID.uriRepresentation().absoluteString

        content.categoryIdentifier = "TaskCategory"

        return UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger)
    }

    /// Renumber notifications to ensure good number is displayed on badge
    internal func renumberNotifications() {
        self.persistentContainer.performBackgroundTask { context in
            let futureTasks = try! context.fetch(Task.futureTasksFetchRequest) as [Task]
            let dueTasks = try! context.fetch(Task.dueTasksFetchRequest) as [Task]

            let count = dueTasks.count

            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()

            for (index, task) in futureTasks.enumerated() {
                let request = self.createNotificationRequest(
                    with: task,
                    badge: count + index + 1)

                center.add(request) { _ in
                }
            }

            DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = count
            }
        }
    }

}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {

    // Receive response
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "TaskDoneAction" {
            self.persistentContainer.performBackgroundTask { context in
                let url = URL(string: response.notification.request.identifier)!
                let objectID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url)
                let task = context.object(with: objectID!) as! Task
                context.delete(task)
                try! context.save()

                DispatchQueue.main.async {
                    self.saveContext()
                    self.updateBadge()
                    self.renumberNotifications()
                    completionHandler()
                }
            }
        } else {
            completionHandler()
        }
    }

    // Foreground notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        self.renumberNotifications()
        self.updateBadge()

        completionHandler([.alert, .sound])
    }

}
