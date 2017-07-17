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
    let dateTime: Date
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
    func addIdea(_ idea: Idea) {
        ideas.append(idea)
    }
    
    // add idea to beginning of idea list
    func prependIdea(_ idea: Idea) {
        ideas.insert(idea, at: 0)
    }
    
    // get count
    func getCount() -> Int {
        return ideas.count
    }
    
    func getNumberOfDays() -> Int {
        let cal = Calendar.current
        let unit:NSCalendar.Unit = NSCalendar.Unit.day
        
        var firstDate = ideas[0].dateTime
        var lastDate = ideas[0].dateTime
        for i in 1 ..< ideas.count {
            let date = ideas[i].dateTime;
            if (date.timeIntervalSince1970 > lastDate.timeIntervalSince1970) {
                lastDate = date;
            }
            if (date.timeIntervalSince1970 < firstDate.timeIntervalSince1970) {
                firstDate = date
            }
        }
        let components = (cal as NSCalendar).components(unit, from: firstDate, to: lastDate, options: NSCalendar.Options.matchStrictly)
        return components.day!;

    }
}
