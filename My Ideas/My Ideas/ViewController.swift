//
//  ViewController.swift
//  My Ideas
//
//  Created by Julia Schwarz on 11/13/15.
//  Copyright (c) 2015 Julia Schwarz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITextViewDelegate {

    weak var textLabel2: UILabel!
    weak var textLabel: UILabel!
    weak var textView: UITextView!
    weak var tableView: UITableView!
    weak var submitButton: UIButton!
    
    var ideasClient : IdeasClient = DummyIdeasClient()
    var ideaList = IdeaList()
    
    let TABLEVIEW_CELL_IDENTIFIER = "reuseIdentifier"

    func textViewDidBeginEditing(textView: UITextView) {
        textLabel.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: TABLEVIEW_CELL_IDENTIFIER)
    }
    
    override func viewDidAppear(animated: Bool) {
        ideasClient = EvernoteIdeasClient(viewController: self)
        ideasClient.connect(onConnectError, successCallback: onConnectSuccess)
    }
    
    func onConnectError(error: NSError) {
        let alertController = UIAlertController(title: "Connect Error", message: error.domain, preferredStyle: .Alert)
        
        let exitAction = UIAlertAction(title: "Exit", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            exit(0)
        }
        
        alertController.addAction(exitAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    func onConnectSuccess() {
        updateUI()
    }
    
    func updateUI() {
        ideaList = ideasClient.ideaList
        textLabel2.text = "\(ideaList.getCount()) ideas in \(ideaList.getNumberOfDays()) days"
        textLabel2.sizeToFit()
        tableView.reloadData()
    }

    @IBAction func onSubmitButtonClicked(sender: AnyObject) {
        let newIdea = Idea(text: textView.text, dateTime: NSDate())
        textView.text = ""
        textLabel.text = "adding idea..."
        textLabel.hidden = false
        
        ideasClient.addIdea(
            newIdea,
            errorCallback: {(error: NSError) in },
            successCallback: {
                self.updateUI()
                self.textLabel.text = "Type another idea"
        })
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
        let idea = ideaList[index]
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

