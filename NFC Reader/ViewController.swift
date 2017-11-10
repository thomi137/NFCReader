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
        
        self.isScanning = false
        
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]){
        
        for message:NFCNDEFMessage in messages {
        
            message.records.forEach({ (record) in
                let type = String(data: record.type, encoding: .utf8)
                let string = record.payloadString
                let tnf: String = NSNumber(value: record.typeNameFormat.rawValue).stringValue
                
                let uriType = record.statusByte
                
                DispatchQueue.main.async {
                    self.tnrLabel.text = tnf
                    self.typeLabel.text = type
                    self.payloadLabel.text = string
                }
    
                
                NSLog("Record Type Name Format: \(tnf) with with type: \(type), uri type \(uriType), contents: \(string)")
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

