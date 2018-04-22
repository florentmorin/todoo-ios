//
//  TasksTableViewController.swift
//  Todoo
//
//  Created by Florent Morin on 21/04/2018.
//  Copyright © 2018 SUP'TG Niort. All rights reserved.
//

import UIKit
import CoreData

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

    /// Fetch Request that provide Tasks
    fileprivate var fetchRequest: NSFetchRequest<Task> {
        let req: NSFetchRequest<Task> = Task.fetchRequest()
        let sd = NSSortDescriptor(
            key: "dueAt",
            ascending: true)

        req.sortDescriptors = [sd]

        return req
    }

    /// Specified fetched results controller
    internal lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
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

    // MARK: - Internal methods

    /**

     Delete task at specified index.

     - Parameters:
        - index: index path of task that need to be deleted

     */
    internal func deleteTask(at index: IndexPath) {
        let task = fetchedResultsController.object(at: index)
        managedObjectContext.delete(task)

        try! managedObjectContext.save()
    }

}
