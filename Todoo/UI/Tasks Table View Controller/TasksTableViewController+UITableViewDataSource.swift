//
//  TasksTableViewController+UITableViewDataSource.swift
//  Todoo
//
//  Created by Florent Morin on 21/04/2018.
//  Copyright © 2018 SUP'TG Niort. All rights reserved.
//

import UIKit

extension TasksTableViewController {

    // Number of rows to display in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tasks = fetchedResultsController.fetchedObjects

        return tasks?.count ?? 0
    }

    // Configure cell for provided index
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell

        let task = fetchedResultsController.object(at: indexPath)

        let dueDate = task.dueAt!

        cell.expired = dueDate < Date()
        cell.taskDueDate = dateFormatter.string(from: dueDate)
        cell.taskDetail = task.detail

        return cell
    }

    // Return true to allow editing
    // (swipe from right to left on rows)
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}
