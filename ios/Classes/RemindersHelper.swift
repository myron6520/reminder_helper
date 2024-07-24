//
//  RemindersHelper.swift
//  reminder_helper
//
//  Created by 钟园园 on 2024/7/5.
//

import EventKit
import Foundation

class ReminderHelper{
    let eventStore: EKEventStore = EKEventStore()
    var hasAccess: Bool = false
    func requestPermission() -> Bool {
        if(hasAccess) {return true}
            var granted = false
            let semaphore = DispatchSemaphore(value: 0)
            if #available(iOS 17.0.0, *) {
//                eventStore.requestFullAccessToReminders(completion: { (success, error) in
//                    granted = success
//                    semaphore.signal()
//                })
                eventStore.requestAccess(to: EKEntityType.reminder) { (success, error) in
                    granted = success
                    semaphore.signal()
                }
            }else{
                eventStore.requestAccess(to: EKEntityType.reminder) { (success, error) in
                    granted = success
                    semaphore.signal()
                }

            }

            semaphore.wait()
            hasAccess = granted
            return granted
        }
    func encodeCalendar(calendar:EKCalendar)->[String:String]{
        var calendarDict: [String: String] = [:]
        calendarDict["id"] = calendar.calendarIdentifier;
        calendarDict["title"] = calendar.title;
        return calendarDict;
    }
    func getCalendars() -> String? {
        
            let lists:[EKCalendar] = eventStore.calendars(for: .reminder)
        let jsonData = try? JSONEncoder().encode(lists.map { encodeCalendar(calendar: $0) })
            return String(data: jsonData ?? Data(), encoding: .utf8)
        }
    func encodeReminder(reminder:EKReminder)->[String: Any]{
        var res: [String: Any] = [:]
        res["id"] = reminder.calendarItemIdentifier;
        res["title"] = reminder.title;
        res["isCompleted"] = reminder.isCompleted;
        if(reminder.completionDate != nil){
            res["completionDate"] = reminder.completionDate!.timeIntervalSince1970;
        }
        if(reminder.startDateComponents != nil){
            res["startDateComponents"] = reminder.startDateComponents!.date!.timeIntervalSince1970;
        }
        if(reminder.dueDateComponents != nil){
            res["dueDateComponents"] = reminder.dueDateComponents!.date!.timeIntervalSince1970;
        }
        if(reminder.creationDate != nil){
            res["creationDate"] = reminder.creationDate!.timeIntervalSince1970;
        }
        ///Per RFC 5545, priorities of 1-4 are considered "high," a priority of 5 is "medium," and priorities of 6-9 are "low."
        res["priority"] = reminder.priority;
        
        if(reminder.lastModifiedDate != nil){
            res["lastModifiedDate"] = reminder.lastModifiedDate?.timeIntervalSince1970;
        }
        
        res["hasAlarms"] = reminder.hasAlarms;
        if(reminder.hasAlarms){
            let alarms = reminder.alarms?.map{
                var alarm: [String:Any] = [:];
                alarm["relativeOffset"] = $0.relativeOffset;
                if($0.absoluteDate != nil){
                    alarm["absoluteDate"] = $0.absoluteDate!.timeIntervalSince1970
                }
                return alarm;
            }
            res["alarms"] = alarms;
        }
        res["hasRecurrenceRules"] = reminder.hasRecurrenceRules;
        if(reminder.hasRecurrenceRules){
            let recurrenceRules = reminder.recurrenceRules?.map{
                var rule: [String:Any] = [:];
                rule["interval"] = $0.interval;
                rule["frequency"] = $0.frequency.rawValue;
                if($0.recurrenceEnd != nil){
                    var recurrenceEnd: [String:Any] = [:];
                    if($0.recurrenceEnd?.endDate != nil){
                        recurrenceEnd["endDate"] = $0.recurrenceEnd!.endDate!.timeIntervalSince1970;
                    }
                    ///The maximum occurrence count, or 0 if it's date-based.
                    recurrenceEnd["occurrenceCount"] = $0.recurrenceEnd!.occurrenceCount;
                    rule["recurrenceEnd"] = recurrenceEnd;
                }
                return rule;
            }
            res["recurrenceRules"] = recurrenceRules;
        }
        
        
        res["hasAttendees"] = reminder.hasAttendees;
        res["hasNotes"] = reminder.hasNotes;
        if(reminder.hasNotes&&reminder.notes != nil){
            res["notes"] = reminder.notes;
        }
        return res;
    }
    func getReminders(_ id: String?, _ completion: @escaping(String?) -> ()) {
            var calendar: [EKCalendar]? = nil
            if let id = id { calendar = [eventStore.calendar(withIdentifier: id) ?? EKCalendar()] }
            let predicate: NSPredicate? = eventStore.predicateForReminders(in: calendar)
            if let predicate = predicate {
                eventStore.fetchReminders(matching: predicate) { (_ reminders: [Any]?) -> Void in
                    let rems = reminders as? [EKReminder] ?? [EKReminder]()
                    let result = rems.map {[weak self] in self?.encodeReminder(reminder: $0) }
                    let json = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                    completion(String(data: json ?? Data(), encoding: .utf8))
                }
            }
        }
}

