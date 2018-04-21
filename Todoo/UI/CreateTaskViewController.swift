//
//  CreateTaskViewController.swift
//  Todoo
//
//  Created by Florent Morin on 21/04/2018.
//  Copyright © 2018 SUP'TG Niort. All rights reserved.
//

import UIKit
import CoreData

class CreateTaskViewController: UIViewController {

    public var managedObjectContext: NSManagedObjectContext?

    // MARK: - IB Outlets

    @IBOutlet weak var detailTextView: UITextView!

    // MARK: - IB Actions

    @IBAction func onSave(_ sender: Any) {
        guard let managedObjectContext = managedObjectContext else {
            self.presentingViewController?.dismiss(animated: true)

            return
        }

        let detail = self.detailTextView.text

        let task = Task(context: managedObjectContext)

        task.createdAt = Date()
        task.detail = detail

        do {
            try managedObjectContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

        self.presentingViewController?.dismiss(animated: true)
    }

    @IBAction func onCancel(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }

    // MARK: - View Lifetime

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.detailTextView.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.detailTextView.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
