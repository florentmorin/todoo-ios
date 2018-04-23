//
//  IntentHandler.swift
//  TodooIntent
//
//  Created by Florent Morin on 22/04/2018.
//  Copyright © 2018 SUP'TG Niort. All rights reserved.
//

import Intents

// Based on https://github.com/martinmitrevski/ListsSiriKit
// Complete as you want :-)

class IntentHandler: INExtension, INAddTasksIntentHandling, INCreateTaskListIntentHandling, INSetTaskAttributeIntentHandling {

    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }

    func createTasks(fromTitles taskTitles: [String]) -> [INTask] {
        var tasks: [INTask] = []
        tasks = taskTitles.map { taskTitle -> INTask in
            let task = INTask(title: INSpeakableString(spokenPhrase: taskTitle),
                              status: .notCompleted,
                              taskType: .completable,
                              spatialEventTrigger: nil,
                              temporalEventTrigger: nil,
                              createdDateComponents: nil,
                              modifiedDateComponents: nil,
                              identifier: nil)
            return task
        }
        return tasks
    }

    // MARK: - INCreateTaskListIntentHandling

    @objc func handle(intent: INCreateTaskListIntent, completion: @escaping (INCreateTaskListIntentResponse) -> Void) {
        let resp = INCreateTaskListIntentResponse(code: .success, userActivity: nil)

        var tasks: [INTask] = []

        if let taskTitles = intent.taskTitles {
            let taskTitlesStrings = taskTitles.map {
                taskTitle -> String in
                return taskTitle.spokenPhrase
            }

            tasks = createTasks(fromTitles: taskTitlesStrings)
        }

        resp.createdTaskList = INTaskList(title: intent.title!,
                                          tasks: tasks,
                                          groupName: nil,
                                          createdDateComponents: nil,
                                          modifiedDateComponents: nil,
                                          identifier: nil)

        completion(resp)
    }
    
    // MARK: - INAddTasksIntentHandling

    func handle(intent: INAddTasksIntent, completion: @escaping (INAddTasksIntentResponse) -> Void) {
        var tasks: [INTask] = []
        if let taskTitles = intent.taskTitles {
            let taskTitlesStrings = taskTitles.map {
                taskTitle -> String in
                return taskTitle.spokenPhrase
            }
            tasks = createTasks(fromTitles: taskTitlesStrings)
        }

        let response = INAddTasksIntentResponse(code: .success, userActivity: nil)
        response.modifiedTaskList = intent.targetTaskList
        response.addedTasks = tasks
        completion(response)

    }

    // MARK: - INSetTaskAttributeIntentHandling

    func handle(intent: INSetTaskAttributeIntent, completion: @escaping (INSetTaskAttributeIntentResponse) -> Void) {
        guard let title = intent.targetTask?.title else {
            completion(INSetTaskAttributeIntentResponse(code: .failure, userActivity: nil))
            return
        }

        let status = intent.status

        if status == .completed {
            // done
        }

        let response = INSetTaskAttributeIntentResponse(code: .success, userActivity: nil)
        response.modifiedTask = intent.targetTask
        completion(response)
    }

}

