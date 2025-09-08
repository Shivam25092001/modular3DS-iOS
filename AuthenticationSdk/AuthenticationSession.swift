//
//  AuthenticationSession.swift
//  AuthenticationSdk
//
//  Created by Shivam Nan on 01/09/25.
//

import Foundation

public class AuthenticationSession {
    internal static var authIntentClientSecret: String?
    internal static var authConfiguration: AuthenticationConfiguration?
    private var threeDSProvider: ThreeDSProvider?
    private var sessionProvider: ThreeDSSessionProvider?
    
    public init(publishableKey: String, customBackendUrl: String? = nil, customParams: [String : Any]? = nil, customLogUrl: String? = nil) {
        APIClient.shared.publishableKey = publishableKey
        APIClient.shared.customBackendUrl = customBackendUrl
        APIClient.shared.customLogUrl = customLogUrl
        APIClient.shared.customParams = customParams
    }
    
    public func initThreeDsSession(authIntentClientSecret: String, configuration: AuthenticationConfiguration? = nil) throws {
        AuthenticationSession.authIntentClientSecret = authIntentClientSecret
        AuthenticationSession.authConfiguration = configuration
        
        // Initialize the 3DS provider using the factory
        do {
            self.threeDSProvider = try ThreeDSProviderFactory.createProvider(preferredProvider: configuration?.preferredProvider)
            try self.threeDSProvider?.initialize(configuration: configuration)
            self.sessionProvider = try self.threeDSProvider?.createSession()
        } catch {
            // Clean up on failure
            self.threeDSProvider = nil
            self.sessionProvider = nil
            throw error
        }
    }
    
    public func createTransaction(messageVersion: String, directoryServerId: String?, cardNetwork: String?) throws -> Transaction {
        guard let sessionProvider = self.sessionProvider else {
            throw TransactionError.transactionCreationFailed("Failed to create transaction provider", nil)

        }
        
        let transactionProvider = try sessionProvider.createTransaction(
            messageVersion: messageVersion,
            directoryServerId: directoryServerId,
            cardNetwork: cardNetwork
        )
        
        return Transaction(
            messageVersion: messageVersion,
            directoryServerId: directoryServerId,
            cardNetwork: cardNetwork,
            transactionProvider: transactionProvider
        )
    }
}

public struct AuthenticationConfiguration {
    public let apiKey: String?
    public let preferredProvider: ProviderType?
    
    public init(apiKey: String? = nil, preferredProvider: ProviderType? = nil) {
        self.apiKey = apiKey
        self.preferredProvider = preferredProvider
    }
}
