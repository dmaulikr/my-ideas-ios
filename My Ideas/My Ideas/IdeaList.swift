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
    func ideaAtIndex(index:Int) -> Idea {
        return ideas[index]
    }
    
    // add idea
    func addIdea(idea: Idea) {
        ideas.append(idea)
    }
    
    // get count
    func getCount() -> Int {
        return ideas.count
    }
    
}