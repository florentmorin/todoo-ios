//
//  TaskTableViewCell.swift
//  Todoo
//
//  Created by Florent Morin on 21/04/2018.
//  Copyright © 2018 SUP'TG Niort. All rights reserved.
//

import UIKit

/**

 Represents a Task Cell

 */
class TaskTableViewCell: UITableViewCell {


    public var taskDueDate: String? {
        set {
            self.dateLabel.text = newValue
        }

        get {
            return self.dateLabel.text
        }
    }

    /// Detail of task
    public var taskDetail: String? {
        set {
            self.label.text = newValue
        }

        get {
            return self.label.text
        }
    }

    /// Label for date
    @IBOutlet private weak var dateLabel: UILabel!

    /// Label where text is displayed
    @IBOutlet private weak var label: UILabel!

}
