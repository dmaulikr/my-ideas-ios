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
    
    let TEXT_SIZE = CGFloat(12.0)
    let TABLEVIEW_CELL_IDENTIFIER = "reuseIdentifier"

    func textViewDidBeginEditing(_ textView: UITextView) {
        textLabel.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textLabel.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: TABLEVIEW_CELL_IDENTIFIER)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tableView.addGestureRecognizer(tap)
    }
    
    // Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        textView.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ideasClient = EvernoteIdeasClient(viewController: self)
        ideasClient.connect(onConnectError, successCallback: onConnectSuccess)
    }
    
    func onConnectError(_ error: NSError) {
        let alertController = UIAlertController(title: "Connect Error", message: error.domain, preferredStyle: .alert)
        
        let exitAction = UIAlertAction(title: "Exit", style: UIAlertActionStyle.default) {
            UIAlertAction in
            exit(0)
        }
        
        alertController.addAction(exitAction)
        
        self.present(alertController, animated: true, completion: nil)

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

    @IBAction func onSubmitButtonClicked(_ sender: AnyObject) {
        let newIdea = Idea(text: textView.text, dateTime: Date())
        textView.text = ""
        textLabel.text = "adding idea..."
        textLabel.isHidden = false
        
        ideasClient.addIdea(
            newIdea,
            errorCallback: {(error: NSError) in },
            successCallback: {
                self.updateUI()
                self.textLabel.text = "Type another idea"
        })
        dismissKeyboard()
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ideaList.getCount()
    }
    
    func textForIdeaAtIndex(_ index: Int) -> String {
        let idea = ideaList[index]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: idea.dateTime as Date) + ": " + idea.text
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TABLEVIEW_CELL_IDENTIFIER, for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = textForIdeaAtIndex(indexPath.row)
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.font = UIFont(name: "Helvetica", size: TEXT_SIZE)

        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {

        let cellText = textForIdeaAtIndex(indexPath.row)
        let font = UIFont(name: "Helvetica", size: TEXT_SIZE)
        let constraintSize = CGSize(width: tableView.bounds.width - 30, height: CGFloat.greatestFiniteMagnitude)
        let attributedText = NSAttributedString(string: cellText, attributes: [
            NSFontAttributeName: font!
            ])
        let labelSize = attributedText.boundingRect(with: constraintSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)

        
        let result = round(labelSize.height + 20)
        return result
    }
    
}

