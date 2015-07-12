//
//  italk.swift
//  italk2
//
//  Created by 鴨島 潤 on 2015/07/13.
//  Copyright (c) 2015年 lbnp. All rights reserved.
//

import Foundation

class Italk {
    var sockHandle: NSFileHandle
    var remainData: NSData
    var isConnected: Bool
    var isLoggedIn: Bool
    //@IBOutlet var theController:

    init() {
        isConnected = false
        isLoggedIn = false
    }

    func connect(serverName: NSString, port: Int) {

    }

    func disconnect() {
    }
    
    func receiveMessage(notification: NSNotification) {
    
    }
    
    func sendMessage(message: NSString) {
        
    }
    
    func sendLine(message: NSString) {
        
    }
    
    func scanPromptForHandle(message: NSString) {

    }
}