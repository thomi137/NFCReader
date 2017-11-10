//
//  WellKnownNDEFTypes.swift
//  NFC Reader
//
//  Created by Thomas Prosser on 07.11.17.
//  Copyright © 2017 thomIT. All rights reserved.
//

import Foundation
import CoreNFC

extension NFCNDEFPayload {
    
    var statusByte: UInt8 {
        return self.payload.first!
    }
    
    var payloadLength: Int{
        return self.payload.count
    }
    
    var typeLength: Int {
        return self.type.count
    }
    
    var isUri: Bool{
        return self.type == Data(bytes: [0x55])
    }
    
    var payloadString: String{
        switch self.typeNameFormat{
        case .absoluteURI:
            return ""
        case .empty:
            return ""
        case .media:
            return ""
        case .nfcExternal:
            return ""
        case .nfcWellKnown:
            let payload = self.payload.subdata(in: typeLength..<payloadLength)
            let payloadString = String(data: payload, encoding: .utf8)
            let uri = WellKnownNDEFURI(rawValue: statusByte)
            return uri!.uriString(payloadString: payloadString!)!
        case .unchanged:
            return ""
        case .unknown:
            return ""
        }
    }
    
}

enum NDEFRTDType{
    
    case U(prefix: String, address: String)
    case T(locale: String, text: String)
    
}

enum WellKnownNDEFURI: UInt8 {

    case Full           = 0x00
    case HttpWww        = 0x01
    case HttpsWww       = 0x02
    case Http           = 0x03
    case Https          = 0x04
    case Tel            = 0x05
    case Mailto         = 0x06
    case AnonFtp        = 0x07
    case FtpFtp         = 0x08
    case Ftps           = 0x09
    case Sftp           = 0x0A
    case Smb            = 0x0B
    case Nfs            = 0x0C
    case Ftp            = 0x0D
    case Dav            = 0x0E
    case News           = 0x0F
    case Telnet         = 0x10
    case Imap           = 0x11
    case Rtsp           = 0x12
    case Urn            = 0x13
    case Pop            = 0x14
    case Sip            = 0x15
    case Sips           = 0x16
    case Tftp           = 0x17
    case Btspp          = 0x18
    case Btl2cap        = 0x19
    case Btgoep         = 0x1A
    case Tcpobex        = 0x1B
    case Irdaobex       = 0x1C
    case File           = 0x1D
    case UrnEpcId       = 0x1E
    case UrnEpcTag      = 0x1F
    case UrnEpcPat      = 0x20
    case UrnEpcRaw      = 0x21
    case UrnEpc         = 0x22
    case UrnNfc         = 0x23
    
}

extension WellKnownNDEFURI {
    
    func uriString(payloadString: String) -> String?{
        switch self {
        case .Full:
            return payloadString
        case .HttpWww:
            return "http://www." + payloadString
        case .HttpsWww:
            return "https://www." + payloadString
        case .Http:
            return "http://" + payloadString
        case .Https:
            return "https://" + payloadString
        case .Tel:
            return "tel:" + payloadString
        case .Mailto:
            return "mailto:" + payloadString
        case .AnonFtp:
            return "ftp://anonymous:anonymous@" + payloadString
        case .FtpFtp:
            return "ftp://ftp." + payloadString
        case .Ftps:
            return "ftps://" + payloadString
        case .Sftp:
            return "sftp://" + payloadString
        case .Smb:
            return "smb://" + payloadString
        case .Nfs:
            return "nfs://" + payloadString
        case .Ftp:
            return "ftp://" + payloadString
        case .Dav:
            return "dav://" + payloadString
        case .News:
            return "news:" + payloadString
        case .Telnet:
            return "telnet://" + payloadString
        case .Imap:
            return "imap:" + payloadString
        case .Rtsp:
            return "rtsp://" + payloadString
        case .Urn:
            return "urn:" + payloadString
        case .Pop:
            return "pop:" + payloadString
        case .Sip:
            return "sip:" + payloadString
        case .Sips:
            return "sips:" + payloadString
        case .Tftp:
            return "tftp:" + payloadString
        case .Btspp:
            return "btspp://" + payloadString
        case .Btl2cap:
            return "btl2cap://" + payloadString
        case .Btgoep:
            return "btgoep://" + payloadString
        case .Tcpobex:
            return "tcpobex://" + payloadString
        case .Irdaobex:
            return "iradobex://" + payloadString
        case .File:
            return "file://" + payloadString
        case .UrnEpcId:
            return "urn:epc:id:" + payloadString
        case .UrnEpcTag:
            return "urn:epc:tag:" + payloadString
        case .UrnEpcPat:
            return "urn:epc:pat:" + payloadString
        case .UrnEpcRaw:
            return "urn:epc:raw:" + payloadString
        case .UrnEpc:
            return "urn:epc:" + payloadString
        case .UrnNfc:
            return "urn:nfc:" + payloadString
        }
    }
}


