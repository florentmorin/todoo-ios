//
//  Task+Requests.swift
//  Todoo
//
//  Created by Florent Morin on 22/04/2018.
//  Copyright © 2018 SUP'TG Niort. All rights reserved.
//

import CoreData

extension Task {

    /// Default fetch request for displaying tasks
    static var defaultFetchRequest: NSFetchRequest<Task> {
        let req: NSFetchRequest<Task> = Task.fetchRequest()
        let sd = NSSortDescriptor(
            key: "dueAt",
            ascending: true)

        req.sortDescriptors = [sd]

        return req
    }

    /// Default fetch request for requesting due tasks
    @nonobjc class var dueTasksFetchRequest: NSFetchRequest<Task> {
        let req: NSFetchRequest<Task> = Task.fetchRequest()
        let sd = NSSortDescriptor(
            key: "dueAt",
            ascending: true)
        let predicate = NSPredicate(format: "dueAt <= %@", Date() as CVarArg)

        req.sortDescriptors = [sd]
        req.predicate = predicate

        return req
    }

    /// Default fetch request for requesting due tasks
    @nonobjc class var futureTasksFetchRequest: NSFetchRequest<Task> {
        let req: NSFetchRequest<Task> = Task.fetchRequest()
        let sd = NSSortDescriptor(
            key: "dueAt",
            ascending: true)
        let predicate = NSPredicate(format: "dueAt > %@", Date() as CVarArg)

        req.sortDescriptors = [sd]
        req.predicate = predicate

        return req
    }

}
