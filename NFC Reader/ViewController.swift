//
//  ViewController.swift
//  NFC Reader
//
//  Created by Thomas Prosser on 07.11.17.
//  Copyright © 2017 thomIT. All rights reserved.
//

import UIKit
import CoreNFC

class ViewController: UIViewController, NFCNDEFReaderSessionDelegate {

    var isScanning = false
    
    @IBOutlet weak var payloadLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBAction func scanButtonPressed(_ sender: UIButton) {
        let readerSession: NFCNDEFReaderSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        
        if isScanning {
            readerSession.invalidate()
        } else {
            readerSession.begin()
        }

        isScanning = !isScanning
        
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        
        NSLog("Reader Session Ready: \(session.isReady), error: \(error.localizedDescription)")
        
        self.isScanning = false
        
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]){
        
        
        var type: String = "Unknown"
        var text: String = "No Text"
        
        for message:NFCNDEFMessage in messages {
            
            message.records.forEach({ (record) in
                
                switch record.parsedPayload{
                    
                case .U(let parsedPayload):
                    text = parsedPayload.getText()!
                case .T(let parsedPayload):
                    text = parsedPayload.getText()!
                case .Unknown:
                    text = "Type unknown"
                    
                    
                }
                type = record.typeString
            })
                
            DispatchQueue.main.async {
                self.typeLabel.text = String(type)
                self.payloadLabel.text = text
            }
            
            NSLog("Record Type with type: \(type), contents: \(text)")
        
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    private func parsePayload(_ payload: Data) -> String {
        let code = payload.first
        if(code == 0x01){
            return "Well known"
        }
        return "something else"
    }
    
}

