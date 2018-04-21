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

    /// Detail of task
    public var taskDetail: String? {
        set {
            self.label.text = newValue
        }

        get {
            return self.label.text
        }
    }

    @IBOutlet private weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
