//
//  FirstViewController.swift
//  italk2
//
//  Created by 鴨島 潤 on 2015/07/12.
//  Copyright (c) 2015年 lbnp. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate {

    var italk : Italk?
    
    @IBAction func connectClicked(sender: UIButton) {
        italk?.connect("main.italk.ne.jp", port: 12345)
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logTextView: UITextView!
    @IBOutlet weak var chatTextField: UITextField!
    @IBAction func sendClicked(sender: AnyObject) {
        sendText()
        chatTextField.endEditing(true)
    }
    func sendText() {
        let textToSend = chatTextField.text! + "\n"
        logTextView.text = logTextView.text + textToSend
        chatTextField.text = nil
        chatTextField.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scrollView.delegate = self
        chatTextField.delegate = self
        logTextView.delegate = self
        logTextView.text = nil
        italk = Italk()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeShown:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillBeShown(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
        let textLimit = chatTextField.frame.origin.y + chatTextField.frame.height + 8.0
        let keyboardLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        
        if textLimit >= keyboardLimit {
            scrollView.contentOffset.y = textLimit - keyboardLimit
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        scrollView.contentOffset.y = 0
    }
}

