//
//  AppDelegate.swift
//  Todoo
//
//  Created by Florent Morin on 21/04/2018.
//  Copyright © 2018 SUP'TG Niort. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        prepareForReceivingNotifications()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        updateBadge()
        renumberNotifications()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
        self.updateBadge()
        self.renumberNotifications()
    }

    // MARK: - Core Data stack

    var groupContainerURL: URL {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.morin-innovation.Todoo")!
    }

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Todoo")
        let url = groupContainerURL.appendingPathComponent("Data.sqlite")
        let description = NSPersistentStoreDescription(url:  url)

        container.persistentStoreDescriptions = [description]

        let group = DispatchGroup()

        group.enter()
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }

            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.retainsRegisteredObjects = true

            group.leave()
        }

        group.wait()

        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Notifications

    /// Ensure user allow notifications
    fileprivate func prepareForReceivingNotifications() {
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
        }
    }

    /// Update badge of app
    func updateBadge() {
        self.saveContext()
        self.persistentContainer.performBackgroundTask { context in
            guard let tasks = try? context.fetch(Task.dueTasksFetchRequest) as [Task] else {
                return
            }

            let count = tasks.count

            DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = count
            }
        }
    }

    /// Create a notification request from a badge
    fileprivate func createNotificationRequest(with task: Task, badge: Int) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = "Todoo"
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
    func renumberNotifications() {
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

