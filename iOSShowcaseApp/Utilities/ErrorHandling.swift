//
//  ErrorHandling.swift
//  iOSShowcaseApp
//
//  Created by Umang Davessar on 4/6/19.
//  Copyright © 2019 Umang Davessar. All rights reserved.
//

import Foundation

public struct RZError {
    
    public let error: Error?
    public let errorMessage: String?
    public var errorCode : Int? = 0
    // We may add more custom properties in future, like error code etc...
    
    init(error:Error? , customeMessage: String?) {
        if let theError = error as NSError? {
            self.errorCode = theError.code
        }
        
        self.error = error
        
        if customeMessage == nil || customeMessage?.count == 0 {
            self.errorMessage = error?.localizedDescription
        }
        else {
            self.errorMessage = customeMessage
        }
    }
}



