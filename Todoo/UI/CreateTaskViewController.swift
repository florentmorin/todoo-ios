//
//  CreateTaskViewController.swift
//  Todoo
//
//  Created by Florent Morin on 21/04/2018.
//  Copyright © 2018 SUP'TG Niort. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController {

    // MARK: - IB Outlets

    @IBOutlet weak var detailTextView: UITextView!

    // MARK: - IB Actions

    @IBAction func onSave(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }

    @IBAction func onCancel(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }

    // MARK: - View Lifetime

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
