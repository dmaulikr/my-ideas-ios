//
//  EvernoteIdeasClient.swift
//  My Ideas
//
//  Created by Julia Schwarz on 11/29/15.
//  Copyright © 2015 Julia Schwarz. All rights reserved.
//

import Foundation

// An IdeasClient is responsible for reading/writing an IdeasList from somewhere
// It exposes a method to connect to a data source
// It exposes a method for getting an ideas list, and also adding an idea
// For each method, pass it a continuation block that will be executed after the task has completed
class EvernoteIdeasClient : IdeasClient {
    var ideaList = IdeaList()
    
    // Connect to data source
    // Parameters:
    // errorCallback: function to execute if method fails
    // successCallback: function to execute if method suceeds
    func connect(errorCallback: (NSError) -> (), successCallback: () -> ()) {
        errorCallback(NSError(domain: "generic error", code: 1, userInfo: nil))
    }
    
    // Returns a list of ideas from the data source
    func getIdeaList() -> IdeaList {
        return ideaList
    }
    
    // Add an idea to the data source
    // Parameters:
    // idea: the Idea to add
    // errorCallback: function to execute if method fails
    // successCallback: function to execute if method suceeds
    func addIdea(idea: Idea, errorCallback: (NSError) -> (), successCallback: () -> ()) {
        ideaList.addIdea(idea)
    }
    
}