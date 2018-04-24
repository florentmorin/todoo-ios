//
//  TasksTableViewController.swift
//  Todoo
//
//  Created by Florent Morin on 21/04/2018.
//  Copyright © 2018 SUP'TG Niort. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

/**

 Table view which list tasks

 */
class TasksTableViewController: UITableViewController {

    // MARK: - Properties

    /// Shortcut to App Delegate
    fileprivate var appDelegate: AppDelegate {
        return (UIApplication.shared.delegate as! AppDelegate)
    }

    /// Persistent store container
    internal var persistentContainer: NSPersistentContainer {
        return appDelegate.persistentContainer
    }

    /// Main managed object context
    internal var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    /// Specified fetched results controller
    internal lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: Task.defaultFetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

    /// Date Formatter
    internal lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short

        return dateFormatter
    }()

    /// Task to edit
    internal var taskToEdit: Task?

    /// Task edition
    internal var isTaskUpdateInProgress = false

    // MARK: - Internal methods

    /**

     Update task at specified index.

     - Parameters:
        - index: index path of task that need to be updated

     */
    internal func updateTask(at index: IndexPath) {
        taskToEdit = fetchedResultsController.object(at: index)
        performSegue(withIdentifier: "EditTaskSegue", sender: nil)
    }

    /**

     Delete task at specified index.

     - Parameters:
        - index: index path of task that need to be deleted

     */
    internal func deleteTask(at index: IndexPath) {
        isTaskUpdateInProgress = true
        let task = fetchedResultsController.object(at: index)
        managedObjectContext.delete(task)

        try! managedObjectContext.save()

        isTaskUpdateInProgress = false

        let center = UNUserNotificationCenter.current()
        let identifier = task.objectID.uriRepresentation().absoluteString
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }

}
