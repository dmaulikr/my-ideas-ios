//
//  IdeasClient.swift
//  My Ideas
//
//  Created by Julia Schwarz on 11/16/15.
//  Copyright © 2015 Julia Schwarz. All rights reserved.
//

import Foundation

// An IdeasClient is responsible for reading/writing an IdeasList from somewhere
// It exposes a method to connect to a data source
// It exposes a method for getting an ideas list, and also adding an idea
// For each method, pass it a continuation block that will be executed after the task has completed
protocol IdeasClient {
    
    // Connect to data source
    // Parameters:
    // errorCallback: function to execute if method fails
    // successCallback: function to execute if method suceeds
    func connect(_ errorCallback: @escaping (NSError) -> (), successCallback: @escaping () -> ())
    
    // Returns a list of ideas from the data source
    var ideaList : IdeaList { get }
    
    // Add an idea to the data source
    // Parameters:
    // idea: the Idea to add
    // errorCallback: function to execute if method fails
    // successCallback: function to execute if method suceeds
    func addIdea(_ idea: Idea, errorCallback: @escaping (NSError) -> (), successCallback: @escaping () -> ())
    
}
