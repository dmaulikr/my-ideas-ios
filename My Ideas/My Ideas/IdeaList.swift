//
//  Idea.swift
//  My Ideas
//
//  Created by Julia Schwarz on 11/16/15.
//  Copyright © 2015 Julia Schwarz. All rights reserved.
//

// Represents a single idea
// An idea has text content, and a DateTime
// An idea's content and time cannot be modified after it's been created
struct Idea {
    let text: String
    let dateTime: NSDate
}

class IdeaList {
    var ideas : [Idea]
    
    init() {
        ideas = []
    }
    
    // get idea at index
    subscript(i: Int) -> Idea {
        get {
            return ideas[i]
        }
        set {
            ideas[i] = newValue
        }
    }
    
    // add idea to end of idea list
    func addIdea(idea: Idea) {
        ideas.append(idea)
    }
    
    // add idea to beginning of idea list
    func prependIdea(idea: Idea) {
        ideas.insert(idea, atIndex: 0)
    }
    
    // get count
    func getCount() -> Int {
        return ideas.count
    }
    
    func getNumberOfDays() -> Int {
        let cal = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = NSCalendarUnit.Day
        
        var firstDate = ideas[0].dateTime
        var lastDate = ideas[0].dateTime
        for (var i = 1; i < ideas.count; i++) {
            let date = ideas[i].dateTime;
            if (date.timeIntervalSince1970 > lastDate.timeIntervalSince1970) {
                lastDate = date;
            }
            if (date.timeIntervalSince1970 < firstDate.timeIntervalSince1970) {
                firstDate = date
            }
        }
        let components = cal.components(unit, fromDate: firstDate, toDate: lastDate, options: NSCalendarOptions.MatchStrictly)
        return components.day;

    }
}