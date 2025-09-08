//
//  APIClient.swift
//  AuthenticationSdk
//
//  Created by Shivam Nan on 01/09/25.
//

import Foundation

import Foundation

@objc internal class APIClient: NSObject {
    
    @objc(sharedClient) public static let shared: APIClient = {
        let client = APIClient()
        return client
    }()
    
    @objc public var publishableKey: String?
    @objc public var customBackendUrl: String?
    @objc public var customParams: [String : Any]?
    @objc public var customLogUrl: String?
}
