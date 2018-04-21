//
//  TasksTableViewController+UIViewController.swift
//  Todoo
//
//  Created by Florent Morin on 21/04/2018.
//  Copyright © 2018 SUP'TG Niort. All rights reserved.
//

import UIKit

extension TasksTableViewController {

    // Prepare view on load
    override func viewDidLoad() {
        super.viewDidLoad()

        try! self.fetchedResultsController.performFetch()
    }

    // Used to prepare children view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTaskSegue" {
            self.prepareForAddTaskSegue(destination: segue.destination)
        }
    }

    /**

     Prepare child view for adding task.

     It prepares a `CreateTaskViewController`.

     - Parameters:
        - destination: View controller to prepare

    */
    fileprivate func prepareForAddTaskSegue(destination: UIViewController) {
        guard let nvc = destination as? UINavigationController,
            let vc = nvc.viewControllers[0] as? CreateTaskViewController  else {
                return
        }

        vc.managedObjectContext = fetchedResultsController.managedObjectContext
    }

}
