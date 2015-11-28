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
    
    let TABLEVIEW_CELL_IDENTIFIER = "reuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        ideasClient.connect(onConnectError, successCallback: onConnectSuccess)
        ideaList = ideasClient.getIdeaList()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: TABLEVIEW_CELL_IDENTIFIER)
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
    
    func textForIdeaAtIndex(index: Int) -> String {
        let idea = ideaList.ideaAtIndex(index)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.stringFromDate(idea.dateTime) + ": " + idea.text
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TABLEVIEW_CELL_IDENTIFIER, forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = textForIdeaAtIndex(indexPath.row)
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 14.0)
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellText = textForIdeaAtIndex(indexPath.row)
        let font = UIFont(name: "Helvetica", size: 17.0)
        let constraintSize = CGSizeMake(tableView.bounds.width, CGFloat.max);
        let attributedText = NSAttributedString(string: cellText, attributes: [
            NSFontAttributeName: font!
            ])
        let labelSize = attributedText.boundingRectWithSize(constraintSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)

        
        return labelSize.height + 100;
    }
    
}

