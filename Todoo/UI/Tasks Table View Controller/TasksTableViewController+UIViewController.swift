//
//  TasksTableViewController+UIViewController.swift
//  Todoo
//
//  Created by Florent Morin on 21/04/2018.
//  Copyright © 2018 SUP'TG Niort. All rights reserved.
//

import UIKit
import CoreData

extension TasksTableViewController {

    // Prepare view on load
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()

        try! self.fetchedResultsController.performFetch()

        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(didSaveContext), name: .NSManagedObjectContextDidSave, object: nil)

        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        isTaskUpdateInProgress = false
    }

    @objc fileprivate func refreshData(sender: Any) {
        try! self.managedObjectContext.save()
        try! self.fetchedResultsController.performFetch()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    @objc fileprivate func didSaveContext(notification: Notification) {
        if isTaskUpdateInProgress {
            return
        }

        try! self.fetchedResultsController.performFetch()
    }

    // Used to prepare children view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "EditTaskSegue" {
            isTaskUpdateInProgress = true
            prepareForEditTaskSegue(destination: segue.destination)
        }
    }

    /**

     Prepare child view for adding task.

     It prepares a `CreateTaskViewController`.

     - Parameters:
        - destination: View controller to prepare

    */
    fileprivate func prepareForEditTaskSegue(destination: UIViewController) {
        guard let nvc = destination as? UINavigationController,
            let vc = nvc.viewControllers[0] as? EditTaskViewController  else {
                return
        }

        vc.managedObjectContext = fetchedResultsController.managedObjectContext
        vc.task = taskToEdit

        taskToEdit = nil
    }

}
