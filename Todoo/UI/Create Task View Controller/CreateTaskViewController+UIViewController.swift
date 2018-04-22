//
//  CreateTaskViewController+UIViewController.swift
//  Todoo
//
//  Created by Florent Morin on 21/04/2018.
//  Copyright © 2018 SUP'TG Niort. All rights reserved.
//

import UIKit

extension CreateTaskViewController {

    // Called once loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.minimumDate = Date()
        datePicker.date = Date().addingTimeInterval(3600.0)
    }

    // Called when view appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        detailTextView.becomeFirstResponder()
    }

    // Called before view disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        detailTextView.resignFirstResponder()
    }

}
