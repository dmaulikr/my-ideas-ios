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
    
    let myIdeasSearch = ENNoteSearch(searchString: "intitle:'my ideas'")

    var ideaSearchResult : ENSessionFindNotesResult?
    
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
                if let error = error {
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
                        if let error = error {
                            errorCallback(error)
                            return
                        }
                        
                        if ( results.count < 1 ) {
                            errorCallback(NSError(domain: "My Ideas note not found", code: 1, userInfo: nil))
                            return
                        }

                        // Download the Note
                        self.ideaSearchResult = results[0] as? ENSessionFindNotesResult
                        if let unwrappedIdeaSearchResult = self.ideaSearchResult {
                            self.downloadAndParseMyIdeasNote(unwrappedIdeaSearchResult, errorCallback: errorCallback, successCallback: successCallback)
                        } else {
                            errorCallback(NSError(domain: "failed to get ideaSearchResult", code: 1, userInfo: nil))
                        }
                    }
        }
    }
    
    // Downloads the my ideas note and parses it to a list of ideas
    func downloadAndParseMyIdeasNote(searchResult: ENSessionFindNotesResult, errorCallback: (NSError) -> (), successCallback: () -> ()) {
        ENSession.sharedSession().downloadNote(
            searchResult.noteRef,
            progress: nil)
            { note, error  in
                if let error = error {
                    errorCallback(error)
                    return
                }
                // Parse the note
                self.parseData(note.content.emml)
                // If all that worked, call the success callback
                successCallback()
        }
    }
    

    // Modifies the Emml
    // If Emml is not in correct format, return nil
    func addIdeaToEmml(ideaEmml: String, idea: Idea) -> String? {
        if let startIndex = ideaEmml.rangeOfString( "<en-note>") {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

            let newString = "<p><span>[[ \(dateFormatter.stringFromDate(idea.dateTime)): \(idea.text) ]]</span></p>"
            let firstPart = ideaEmml.substringWithRange(Range<String.Index>(start: ideaEmml.startIndex, end: startIndex.startIndex))
            let lastPart = ideaEmml.substringWithRange(Range<String.Index>(start: startIndex.endIndex, end: ideaEmml.endIndex))
            return firstPart + "<en-note>" + newString + lastPart
        } else {
            return  nil
        }

        
    }
    
    // Add an idea to the data source
    // Parameters:
    // idea: the Idea to add
    // errorCallback: function to execute if method fails
    // successCallback: function to execute if method suceeds
    func addIdea(idea: Idea, errorCallback: (NSError) -> (), successCallback: () -> ()) {
        // get idea emml
        if let unwrappedIdeaSearchResult = self.ideaSearchResult {
            ENSession.sharedSession().downloadNote(
                unwrappedIdeaSearchResult.noteRef,
                progress: nil)
                { note, error  in
                    if let error = error {
                        errorCallback(error)
                        return
                    }
                    
                    note.content.emml = self.addIdeaToEmml(note.content.emml, idea: idea)
                    ENSession.sharedSession().uploadNote(
                        note,
                        policy: ENSessionUploadPolicy.Replace,
                        toNotebook: nil,
                        orReplaceNote: self.ideaSearchResult?.noteRef,
                        progress: nil)
                        { result, error in
                            if let error = error {
                                errorCallback(error)
                                return
                            }
                            self.downloadAndParseMyIdeasNote(unwrappedIdeaSearchResult, errorCallback: errorCallback, successCallback: successCallback)
                        }
            }
        } else {
            errorCallback(NSError(domain: "Failed to add idea: My Ideas note not found", code: 1, userInfo: nil))
        }
    }
    
    func parseData(rawData: String) {
        self.ideaListPrivate = IdeaList();
        var startIndex = rawData.rangeOfString("[[")
        var endIndex = rawData.rangeOfString("]]")
        
        var rawDataCopy = rawData
        while (startIndex != nil) {
            
            let ideaStr = rawDataCopy.substringWithRange(Range<String.Index>(start: (startIndex?.endIndex)!, end: (endIndex?.startIndex)!))
            let parts = ideaStr.componentsSeparatedByString(":")
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let date = dateFormatter.dateFromString(parts[0])
            var ideaText = parts[1]
            for (var i = 2; i < parts.count; i++) {
                ideaText = ideaText + ": " + parts[i]
            }
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
    
}