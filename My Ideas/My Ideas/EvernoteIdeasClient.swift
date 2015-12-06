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
    var ideaListPrivate = IdeaList()
    let uiViewController : UIViewController
    
    let beginEMMLBlock = "<en-note>"
    let ideaEMMLFormat = "<p><span>[[%s]]</span></p>"
    let myIdeasSearch = ENNoteSearch(searchString: "intitle:'my ideas'")

    var ideaNote : ENNote?
    
    init(viewController: UIViewController) {
        self.uiViewController = viewController
    }
    
    // Connect to data source
    // Parameters:
    // errorCallback: function to execute if method fails
    // successCallback: function to execute if method suceeds
    func connect(errorCallback: (NSError) -> (), successCallback: () -> ()) {
        // Authenticate
        ENSession.sharedSession().authenticateWithViewController(
            uiViewController,
            preferRegistration: false)
            { error in
                if (error != nil) {
                    errorCallback(error)
                    return
                }
                // Find the my ideas note
                ENSession.sharedSession().findNotesWithSearch(
                    self.myIdeasSearch, 
                    inNotebook: nil,
                    orScope: ENSessionSearchScope.Personal,
                    sortOrder: ENSessionSortOrder.RecentlyUpdated,
                    maxResults: 1)
                    { results, error in
                        if (error == nil) {
                            if ( results.count < 1 ) {
                                errorCallback(NSError(domain: "My Ideas note not found", code: 1, userInfo: nil))
                                return
                            } else {
                                // Download the Note
                                let result : ENSessionFindNotesResult = results[0] as! ENSessionFindNotesResult
                                ENSession.sharedSession().downloadNote(
                                    result.noteRef,
                                    progress: nil)
                                    { note, error  in
                                        if (error == nil) {
                                            // Parse the note
                                            print(note.content.emml)
                                            self.parseData(note.content.emml)
                                            // If all that worked, call the success callback
                                            successCallback()
                                        } else {
                                            errorCallback(error)
                                            return
                                        }
                                    }
                            }
                        } else {
                            errorCallback(error)
                            return
                        }
                    }
            
        }
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

    var ideaList : IdeaList {
        get {
            return ideaListPrivate;
        }
    }
    
    // Add an idea to the data source
    // Parameters:
    // idea: the Idea to add
    // errorCallback: function to execute if method fails
    // successCallback: function to execute if method suceeds
    func addIdea(idea: Idea, errorCallback: (NSError) -> (), successCallback: () -> ()) {
        ideaListPrivate.addIdea(idea)
    }
    
}