//
//  TasksTableViewController.swift
//  Todoo
//
//  Created by Florent Morin on 21/04/2018.
//  Copyright © 2018 SUP'TG Niort. All rights reserved.
//

import UIKit
import CoreData

class TasksTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    private let persistentContainer = NSPersistentContainer(name: "Todoo")

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]

        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
            }
        }

        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tasks = fetchedResultsController.fetchedObjects else {
            return 0
        }

        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell

        // Retrieve object
        let task = fetchedResultsController.object(at: indexPath)

        // Configure the cell...

        cell.taskDetail = task.detail

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "Supprimer",
            message: "Êtes-vous sûr de vouloir supprimer cette tâche ?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel) { _ in
            tableView.deselectRow(at: indexPath, animated: true)
        }
        let deleteAction = UIAlertAction(title: "Supprimer", style: .destructive) { _ in
            self.deleteTask(at: indexPath)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: true)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTaskSegue",
            let nvc = segue.destination as? UINavigationController,
            let vc = nvc.viewControllers[0] as? CreateTaskViewController {
            vc.managedObjectContext = fetchedResultsController.managedObjectContext
        }
    }


    // MARK: - NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            self.tableView.reloadRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Supprimer") { action, index in
            self.deleteTask(at: index)
        }
        deleteAction.backgroundColor = .red

        return [deleteAction]
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    private func deleteTask(at index: IndexPath) {
        let object = self.fetchedResultsController.object(at: index)
        let managedObjectContext = self.fetchedResultsController.managedObjectContext
        managedObjectContext.delete(object)

        do {
            try managedObjectContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
