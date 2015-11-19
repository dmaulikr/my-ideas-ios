//
//  ViewController.swift
//  My Ideas
//
//  Created by Julia Schwarz on 11/13/15.
//  Copyright (c) 2015 Julia Schwarz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    var ideasClient = DummyIdeasClient()
    var ideaList = IdeaList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        ideasClient.connect(onConnectError, successCallback: onConnectSuccess)
        ideaList = ideasClient.getIdeaList()
    }
    
    func onConnectError(error: NSError) {
        
    }
    
    func onConnectSuccess() {
        ideaList = ideasClient.getIdeaList()
        // refresh the UI
    }

    @IBAction func onSubmitButtonClicked(sender: AnyObject) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return ideaList.getCount()
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) 
        
        // Configure the cell...
        let idea = ideaList.ideaAtIndex(indexPath.row)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        cell.textLabel?.text = formatter.stringFromDate(idea.dateTime) + ": " + idea.text
        return cell
    }
    
}

