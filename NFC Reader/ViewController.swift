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
    @IBOutlet weak var tnrLabel: UILabel!
    
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
        
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]){
        
        for message:NFCNDEFMessage in messages {
        
            message.records.forEach({ (record) in
                
                let type = String(data: record.type, encoding: String.Encoding.utf8)
                let identifier: String = String(data: record.identifier, encoding: String.Encoding.utf8)!
                let payload: String = String(data: record.payload, encoding: String.Encoding.ascii)!
                let tnf: String = NSNumber(value: record.typeNameFormat.rawValue).stringValue
                
                self.tnrLabel.text = tnf
                self.typeLabel.text = type
                self.payloadLabel.text = payload
                
                NSLog("Record Type: \(parsePayload(record.payload)) with identifier: \(identifier), contents: \(payload)")
            })
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

