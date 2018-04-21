//
//  CreateTaskViewController.swift
//  Todoo
//
//  Created by Florent Morin on 21/04/2018.
//  Copyright © 2018 SUP'TG Niort. All rights reserved.
//

import UIKit
import CoreData

/**

 View for creating task

 */
class CreateTaskViewController: UIViewController {

    // MARK: Core Data stack

    /// Managed object context provided by caller
    public var managedObjectContext: NSManagedObjectContext?

    // MARK: - IB Outlets

    /// Text view
    @IBOutlet weak var detailTextView: UITextView!

    // MARK: - IB Actions

    /// Action when save button is tapped
    @IBAction func onSave(_ sender: Any) {
        save()
        dismiss()
    }

    /// Action when cancel button is tapped
    @IBAction func onCancel(_ sender: Any) {
        dismiss()
    }

    // MARK: - Actions

    /// Save to Core Data
    fileprivate func save() {
        guard let moc = managedObjectContext else {
            dismiss()

            return
        }

        let detail = self.detailTextView.text

        let task = Task(context: moc)

        task.createdAt = Date()
        task.detail = detail

        try! moc.save()
    }

    /// Dismiss from modal
    fileprivate func dismiss() {
        presentingViewController?.dismiss(animated: true)
    }

}
