//
//  DummyIdeasClient.swift
//  My Ideas
//
//  Created by Julia Schwarz on 11/19/15.
//  Copyright © 2015 Julia Schwarz. All rights reserved.
//

import Foundation

class DummyIdeasClient : IdeasClient {
    var ideaListPrivate = IdeaList()
    
    
    // Loads dummy data from Assets/dummy_ideas.txt
    func loadDummyData() -> String {
        let dummyIdeaFilePath = Bundle.main.path(forResource: "dummy_idea", ofType: "txt")
        let fileData: String?
        do {
            fileData = try String(contentsOfFile: dummyIdeaFilePath!, encoding: String.Encoding.utf8)
        } catch _ {
            fatalError("can't find dummy_idea.txt")
        }
        return fileData!
    }

    func parseData(_ rawData: String) {
        
        var startIndex = rawData.range(of: "[[")
        var endIndex = rawData.range(of: "]]")

        var rawDataCopy = rawData
        while (startIndex != nil) {

            let ideaStr = rawDataCopy.substring(with: ((startIndex?.upperBound)! ..< (endIndex?.lowerBound)!))
            let parts = ideaStr.components(separatedBy: ":")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let date = dateFormatter.date(from: parts[0])
            let ideaText = parts[1]
            
            ideaListPrivate.addIdea(Idea(text: ideaText, dateTime: date!))
            
            
            rawDataCopy = rawDataCopy.substring(with: ((endIndex?.upperBound)! ..< rawDataCopy.endIndex))
            startIndex = rawDataCopy.range(of: "[[")
            endIndex = rawDataCopy.range(of: "]]")
            
        }

    }
    
    // Connect to data source
    // Parameters:
    // errorCallback: function to execute if method fails
    // successCallback: function to execute if method suceeds
    func connect(_ errorCallback: @escaping (NSError) -> (), successCallback: @escaping () -> ()) {
        // parse hardcoded ideas list
        let dummyData = loadDummyData()
        parseData(dummyData)
        successCallback()
    }
    
    // Returns a list of ideas from the data source
    var ideaList : IdeaList {
        get {
            return ideaListPrivate;
        }
    }
    
    // Add an idea to the data source
    // Parameters:
    // idea: the Idea to add
    // withErrorCallback: function to execute if method fails
    // withSuccessCallback: function to execute if method suceeds
    func addIdea(_ idea: Idea, errorCallback: @escaping (NSError) -> (), successCallback: @escaping () -> ()) {
        ideaListPrivate.prependIdea(idea)
        successCallback()
    }

}
