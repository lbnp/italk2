//
//  italk.swift
//  italk2
//
//  Created by 鴨島 潤 on 2015/07/13.
//  Copyright (c) 2015年 lbnp. All rights reserved.
//

import Foundation

class Italk {
    var sockHandle: NSFileHandle?
    var remainData: NSData?
    var isConnected: Bool
    var isLoggedIn: Bool
    //@IBOutlet var theController:

    init() {
        isConnected = false
        isLoggedIn = false
    }

    func connect(serverName: NSString, port: Int) {
        if isConnected {
            disconnect()
        }
        
        //var hostName = CFHOst
    }

    func disconnect() {
        if isLoggedIn {
            let quitString = "/q\n"
            let quitData = quitString.dataUsingEncoding(NSISO2022JPStringEncoding)
            sockHandle?.writeData(quitData!)
            isLoggedIn = false
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        sockHandle?.closeFile()
        isConnected = false
    }
    
    func receiveMessage(notification: NSNotification) {
        
    }
    
    func sendMessage(message: NSString) {
        let messageData = message.dataUsingEncoding(NSISO2022JPStringEncoding, allowLossyConversion: true)
        sockHandle?.writeData(messageData!)
    }
    
    func sendLine(message: NSString) {
        let toSend = message.stringByAppendingString("\n")
        sendMessage(toSend)
    }
    
    func scanPromptForHandle(message: NSString?) -> Bool {
        let prompt = "\n#What's your name?"
        if message == nil {
            return false
        }
        let range = message!.rangeOfString(prompt)
        if range.location != NSNotFound {
            return true
        } else {
            return false
        }
    }
}