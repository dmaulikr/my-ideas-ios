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
        let dummyIdeaFilePath = NSBundle.mainBundle().pathForResource("dummy_idea", ofType: "txt")
        let fileData: String?
        do {
            fileData = try String(contentsOfFile: dummyIdeaFilePath!, encoding: NSUTF8StringEncoding)
        } catch _ {
            fatalError("can't find dummy_idea.txt")
        }
        return fileData!
    }

    func parseData(rawData: String) {
        
        var startIndex = rawData.rangeOfString("[[")
        var endIndex = rawData.rangeOfString("]]")

        var rawDataCopy = rawData
        while (startIndex != nil) {

            let ideaStr = rawDataCopy.substringWithRange(Range<String.Index>(start: (startIndex?.endIndex)!, end: (endIndex?.startIndex)!))
            let parts = ideaStr.componentsSeparatedByString(":")
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let date = dateFormatter.dateFromString(parts[0])
            let ideaText = parts[1]
            
            ideaListPrivate.addIdea(Idea(text: ideaText, dateTime: date!))
            
            
            rawDataCopy = rawDataCopy.substringWithRange(Range<String.Index>(start: (endIndex?.endIndex)!, end: rawDataCopy.endIndex))
            startIndex = rawDataCopy.rangeOfString("[[")
            endIndex = rawDataCopy.rangeOfString("]]")
            
        }

    }
    
    // Connect to data source
    // Parameters:
    // errorCallback: function to execute if method fails
    // successCallback: function to execute if method suceeds
    func connect(errorCallback: (NSError) -> (), successCallback: () -> ()) {
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
    func addIdea(idea: Idea, errorCallback: (NSError) -> (), successCallback: () -> ()) {
        ideaListPrivate.prependIdea(idea)
        successCallback()
    }

}