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
    
}