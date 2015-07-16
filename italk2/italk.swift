//
//  italk.swift
//  italk2
//
//  Created by 鴨島 潤 on 2015/07/13.
//  Copyright (c) 2015年 lbnp. All rights reserved.
//

import Foundation

class Italk : NSObject, NSStreamDelegate {
    var inputStream: NSInputStream?
    var outputStream: NSOutputStream?
    var remainData: NSData?
    var isConnected: Bool
    var isLoggedIn: Bool
    //@IBOutlet var theController:

    override init() {
        isConnected = false
        isLoggedIn = false
    }

    func connect(serverName: String, port: Int) {
        if isConnected {
            disconnect()
        }
        
        NSStream.getStreamsToHostWithName(serverName, port: port, inputStream: &inputStream, outputStream: &outputStream)
        
        inputStream!.delegate = self
        outputStream!.delegate = self
        inputStream!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        outputStream!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        inputStream!.open()
        outputStream!.open()
    }
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        switch (eventCode) {
        case NSStreamEvent.OpenCompleted:
            break
        case NSStreamEvent.HasBytesAvailable:
            var buffer = [UInt8](count: 4096, repeatedValue: 0)
            if aStream == inputStream! {
                while inputStream!.hasBytesAvailable {
                    let len = inputStream!.read(&buffer, maxLength: buffer.count)
                    if len > 0 {
                        let output = NSString(bytes: &buffer, length: buffer.count, encoding: NSISO2022JPStringEncoding)
                        if !isLoggedIn {
                            if scanPromptForHandle(output) {
                                let handle = NSUserDefaults.standardUserDefaults().stringForKey("handle")
                                if (handle != nil) {
                                    sendLine(handle!)
                                } else {
                                    sendLine("kamo")
                                }
                            }
                            isLoggedIn = true
                        }
                    }
                }
            }
            break
        case NSStreamEvent.ErrorOccurred:
            disconnect()
            break
        case NSStreamEvent.EndEncountered:
            disconnect()
            break
        case NSStreamEvent.HasSpaceAvailable:
            break
        default:
            break
        }
    }

    func disconnect() {
        if isLoggedIn {
            let quitString = "/q\n"
            let quitData = quitString.dataUsingEncoding(NSISO2022JPStringEncoding)
            outputStream!.write(UnsafePointer<UInt8>(quitData!.bytes), maxLength: quitData!.length)
            isLoggedIn = false
        }
        
        outputStream!.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        inputStream!.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        outputStream!.close()
        inputStream!.close()
        isConnected = false
    }
    
    func sendMessage(message: NSString) {
        let messageData = message.dataUsingEncoding(NSISO2022JPStringEncoding, allowLossyConversion: true)
        outputStream?.write(UnsafePointer<UInt8>(messageData!.bytes), maxLength: messageData!.length)
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