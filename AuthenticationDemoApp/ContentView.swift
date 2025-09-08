//
//  ContentView.swift
//  AuthenticationDemoApp
//
//  Created by Shivam Nan on 01/09/25.
//

import SwiftUI
import AuthenticationSdk

struct ContentView: View {
    @State private var statusMessage = "Ready to test 3DS SDK"
    @State private var authSession: AuthenticationSession?
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "creditcard")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("3DS Authentication Demo")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(statusMessage)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(spacing: 15) {
                Button("Initialize 3DS Session") {
                    initializeThreeDSSession()
                }
                .buttonStyle(.borderedProminent)
                .disabled(authSession != nil)
                
                Button("Create Transaction") {
                    createTransaction()
                }
                .buttonStyle(.bordered)
                .disabled(authSession == nil)
                
                Button("Reset") {
                    resetSession()
                }
                .buttonStyle(.bordered)
                .disabled(authSession == nil)
            }
        }
        .padding()
    }
    
    private func initializeThreeDSSession() {
        statusMessage = "Initializing 3DS session..."
        
        // Create AuthenticationSession with demo credentials
        authSession = AuthenticationSession(
            publishableKey: "demo_publishable_key",
//            customBackendUrl: "https://demo.example.com",
//            customParams: ["demo": "true"]
        )
        
        do {
            // Create configuration with preferred provider
            let configuration = AuthenticationConfiguration(
                apiKey: "demo_api_key",
                preferredProvider: .netcetera
            )
            
            // Initialize the 3DS session
            try authSession?.initThreeDsSession(
                authIntentClientSecret: "demo_client_secret",
                configuration: configuration
            )
            
            statusMessage = "-- 3DS Session initialized successfully!\nProvider: Netcetera (if available)"
        } catch {
            statusMessage = "-- Failed to initialize 3DS session:\n\(error.localizedDescription)"
            authSession = nil
        }
    }
    
    private func createTransaction() {
        guard let authSession = authSession else {
            statusMessage = "-- No active session. Please initialize first."
            return
        }
        
        statusMessage = "Creating transaction..."
        
        do {
            let transaction = try authSession.createTransaction(
                messageVersion: "2.1.0",
                directoryServerId: "demo_directory_server",
                cardNetwork: "visa"
            )
            
            statusMessage = "-- Transaction created successfully!\nReady for authentication flow."
        } catch {
            statusMessage = "-- Failed to create transaction:\n\(error.localizedDescription)"
        }
    }
    
    private func resetSession() {
        authSession = nil
        statusMessage = "Session reset. Ready to test 3DS SDK"
    }
}

#Preview {
    ContentView()
}
