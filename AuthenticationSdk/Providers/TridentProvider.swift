//
//  TridentProvider.swift
//  AuthenticationSdk
//
//  Created by Shivam Nan on 02/09/25.
//

import Foundation
import UIKit

#if canImport(Trident)
import Trident

class TridentProvider: ThreeDSProvider {
    private lazy var threeDS2Service: Trident.ThreeDS2Service = {
        TridentSDK()
    }()
    
    func initialize(configuration: AuthenticationConfiguration?) throws {
        // Initialize Trident SDK with configuration
    }
    
    func createSession() throws -> ThreeDSSessionProvider {
        return TridentSessionProvider(service: threeDS2Service)
    }
    
    func cleanup() {
    }
}

class TridentSessionProvider: ThreeDSSessionProvider {
    private let service: Trident.ThreeDS2Service
    
    init(service: Trident.ThreeDS2Service) {
        self.service = service
    }
    
    func createTransaction(messageVersion: String, directoryServerId: String?, cardNetwork: String?) throws -> ThreeDSTransactionProvider {
        let transaction = try service.createTransaction(
            directoryServerId: directoryServerId ?? "",
            messageVersion: messageVersion
        )
        return TridentTransactionProvider(transaction: transaction)
    }
}

class TridentTransactionProvider: ThreeDSTransactionProvider {
    private let transaction: Trident.Transaction
    
    init(transaction: Trident.Transaction) {
        self.transaction = transaction
    }
    
    func getAuthenticationRequestParameters() throws -> AuthenticationRequestParameters {
        let aReqParams = try transaction.getAuthenticationRequestParameters()
        
        return AuthenticationRequestParameters(sdkTransactionID: aReqParams.sdkTransactionID, deviceData: aReqParams.deviceData, sdkEphemeralPublicKey: aReqParams.sdkEphemeralPublicKey, sdkAppID: aReqParams.sdkAppID, sdkReferenceNumber: aReqParams.sdkReferenceNumber, messageVersion: aReqParams.messageVersion)
    }
    
    func doChallenge(viewController: UIViewController, challengeParameters: ChallengeParameters, challengeStatusReceiver: ChallengeStatusReceiver, timeOut: Int) throws {
//        try transaction.doChallenge(
//            viewController: viewController,
//            challengeParameters: challengeParameters,
//            challengeStatusReceiver: challengeStatusReceiver,
//            timeOut: timeOut
//        )
    }
    
//    func getProgressView() throws -> ProgressDialog {
//        <#code#>
//    }
    
    func close() {
        // deinit
    }
}

#endif
