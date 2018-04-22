//
//  TasksTableViewController+UITableViewDelegate.swift
//  Todoo
//
//  Created by Florent Morin on 21/04/2018.
//  Copyright © 2018 SUP'TG Niort. All rights reserved.
//

import UIKit

extension TasksTableViewController {

    // Actions to display on swiping row from right to left
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Terminé") { action, index in
            self.deleteTask(at: index)
        }
        deleteAction.backgroundColor = .red

        let editAction = UITableViewRowAction(style: .normal, title: "Modifier") { action, index in
            self.updateTask(at: index)
        }
        editAction.backgroundColor = .lightGray

        return [deleteAction, editAction]
    }

    // Table view accessory selected
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        updateTask(at: indexPath)
    }

    // Called when a table view is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = "Terminée"
        let message = "Cette tâche peut-elle être supprimée ?"
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        let cancelAction = UIAlertAction(
            title: "Annuler", style: .cancel) { _ in
            tableView.deselectRow(at: indexPath, animated: true)
        }
        let deleteAction = UIAlertAction(
            title: "Supprimer", style: .destructive) { _ in
            self.deleteTask(at: indexPath)
            tableView.deselectRow(at: indexPath, animated: true)
        }

        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: true)
    }

}
