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
    
    let myIdeasSearch = ENNoteSearch(search: "intitle:'my ideas'")

    var ideaSearchResult : ENSessionFindNotesResult?
    
    init(viewController: UIViewController) {
        self.uiViewController = viewController
    }
    
    
    
    // Connect to data source
    // Parameters:
    // errorCallback: function to execute if method fails
    // successCallback: function to execute if method suceeds
    func connect(_ errorCallback: @escaping (NSError) -> (), successCallback: @escaping () -> ()) {
    
        // Authenticate
        ENSession.shared().authenticate(
            with: uiViewController,
            preferRegistration: false)
            { error in
                if let error = error {
                    errorCallback(error as NSError)
                    return
                }
                
                
                // Find the my ideas note
                ENSession.shared().findNotes(
                    with: self.myIdeasSearch, 
                    in: nil,
                    orScope: ENSessionSearchScope.personal,
                    sortOrder: ENSessionSortOrder.recentlyUpdated,
                    maxResults: 1)
                    { results, error in
                        if let error = error {
                            errorCallback(error as NSError)
                            return
                        }
                        
                        if ( (results?.count)! < 1 ) {
                            errorCallback(NSError(domain: "My Ideas note not found", code: 1, userInfo: nil))
                            return
                        }

                        // Download the Note
                        self.ideaSearchResult = results?[0] as? ENSessionFindNotesResult
                        if let unwrappedIdeaSearchResult = self.ideaSearchResult {
                            self.downloadAndParseMyIdeasNote(unwrappedIdeaSearchResult, errorCallback: errorCallback, successCallback: successCallback)
                        } else {
                            errorCallback(NSError(domain: "failed to get ideaSearchResult", code: 1, userInfo: nil))
                        }
                    }
            }
        }
    
    // Downloads the my ideas note and parses it to a list of ideas
    func downloadAndParseMyIdeasNote(_ searchResult: ENSessionFindNotesResult, errorCallback: @escaping (NSError) -> (), successCallback: @escaping () -> ()) {
        ENSession.shared().downloadNote(
            searchResult.noteRef,
            progress: nil)
            { note, error  in
                if let error = error {
                    errorCallback(error as NSError)
                    return
                }
                // Parse the note
                self.parseData((note?.content.emml)!)
                // If all that worked, call the success callback
                successCallback()
        }
    }
    

    // Modifies the Emml
    // If Emml is not in correct format, return nil
    func addIdeaToEmml(_ ideaEmml: String, idea: Idea) -> String? {
        if let startIndex = ideaEmml.range( of: "<en-note>") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

            let newString = "<p><span>[[ \(dateFormatter.string(from: idea.dateTime as Date)): \(idea.text) ]]</span></p>"
            let firstPart = ideaEmml.substring(with: (ideaEmml.startIndex ..< startIndex.lowerBound))
            let lastPart = ideaEmml.substring(with: (startIndex.upperBound ..< ideaEmml.endIndex))
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
    func addIdea(_ idea: Idea, errorCallback: @escaping (NSError) -> (), successCallback: @escaping () -> ()) {
        // get idea emml
        if let unwrappedIdeaSearchResult = self.ideaSearchResult {
            ENSession.shared().downloadNote(
                unwrappedIdeaSearchResult.noteRef,
                progress: nil)
                { note, error  in
                    if let error = error {
                        errorCallback(error as NSError)
                        return
                    }
                    
                    note?.content.emml = self.addIdeaToEmml((note?.content.emml)!, idea: idea)
                    ENSession.shared().uploadNote(
                        note,
                        policy: ENSessionUploadPolicy.replace,
                        to: nil,
                        orReplace: self.ideaSearchResult?.noteRef,
                        progress: nil)
                        { result, error in
                            if let error = error {
                                errorCallback(error as NSError)
                                return
                            }
                            self.downloadAndParseMyIdeasNote(unwrappedIdeaSearchResult, errorCallback: errorCallback, successCallback: successCallback)
                        }
            }
        } else {
            errorCallback(NSError(domain: "Failed to add idea: My Ideas note not found", code: 1, userInfo: nil))
        }
    }
    
    func parseData(_ rawData: String) {
        self.ideaListPrivate = IdeaList();
        var startIndex = rawData.range(of: "[[")
        var endIndex = rawData.range(of: "]]")
        
        var rawDataCopy = rawData
        while (startIndex != nil) {
            
            let ideaStr = rawDataCopy.substring(with: ((startIndex?.upperBound)! ..< (endIndex?.lowerBound)!))
            let parts = ideaStr.components(separatedBy: ":")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let date = dateFormatter.date(from: parts[0])
            var ideaText = parts[1]
            for i in 2 ..< parts.count {
                ideaText = ideaText + ": " + parts[i]
            }
            ideaListPrivate.addIdea(Idea(text: ideaText, dateTime: date!))
            
            
            rawDataCopy = rawDataCopy.substring(with: ((endIndex?.upperBound)! ..< rawDataCopy.endIndex))
            startIndex = rawDataCopy.range(of: "[[")
            endIndex = rawDataCopy.range(of: "]]")
            
        }
    }
    
    var ideaList : IdeaList {
        get {
            return ideaListPrivate;
        }
    }
    
}
