//
//  EditTaskViewController.swift
//  Todoo
//
//  Created by Florent Morin on 21/04/2018.
//  Copyright © 2018 SUP'TG Niort. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

/**

 View for creating task

 */
class EditTaskViewController: UIViewController {

    // MARK: Core Data stack

    /// Managed object context provided by caller
    public var managedObjectContext: NSManagedObjectContext?

    /// Task to edit
    public var task: Task? {
        didSet {
            updateUI()
        }
    }

    // MARK: - IB Outlets

    /// Date picker
    @IBOutlet weak var datePicker: UIDatePicker!

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

    /// Action on tap to background (ie. Scroll View)
    @IBAction func tapOnBackground(_ sender: Any) {
        detailTextView!.resignFirstResponder()
    }

    // MARK: - Action

    /// Save to Core Data
    fileprivate func save() {
        guard let moc = managedObjectContext else {
            dismiss()

            return
        }

        let cs = CharacterSet.whitespacesAndNewlines

        guard let detail = self.detailTextView.text?.trimmingCharacters(in: cs) else {
            detailTextView!.becomeFirstResponder()

            return
        }

        let task = self.task ?? Task(context: moc)

        task.dueAt = self.datePicker.date
        task.detail = detail

        try! moc.save()

        self.prepareNotification(for: task)
    }

    // Prepare notification
    fileprivate func prepareNotification(for task: Task) {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Rappel"
        content.body = task.detail!
        content.sound = UNNotificationSound.default()

        let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let triggerDate = Calendar.current.dateComponents(components, from: task.dueAt!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let identifier = task.objectID.uriRepresentation().absoluteString

        content.categoryIdentifier = "TaskCategory"

        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)

        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        center.add(request) { _ in
        }
    }

    /// Dismiss from modal
    fileprivate func dismiss() {
        presentingViewController?.dismiss(animated: true)
    }

    /// Update UI if necessary
    internal func updateUI() {
        if let task = task {
            let dueDate = task.dueAt!
            let now = Date()
            title = "Modifier"
            detailTextView?.text = task.detail
            datePicker?.minimumDate = now > dueDate ? dueDate : now
            datePicker?.date = dueDate
        } else {
            title = "Ajouter"
            detailTextView?.text = nil
            datePicker?.minimumDate = Date()
            datePicker?.date = Date().addingTimeInterval(3600.0)

        }
    }

}
