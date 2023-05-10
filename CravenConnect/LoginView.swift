//
//  LoginView.swift
//  Craven Connections
//
//  Created by Craven on 5/4/23.
//

import SwiftUI
import Firebase

let authUI = FUIAuth.defaultAuthUI()
let providers: [FUIAuthProvider] = [
    FUIEmailAuth(),
    FUIGoogleAuth(),
    FUIFacebookAuth(),
    FUITwitterAuth(),
    FUIOAuth.appleAuthProvider(),
]
authUI?.providers = providers

let authViewController = authUI!.authViewController()
present(authViewController, animated: true, completion: nil)

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            Spacer()
            
            Button(action: {
                self.isAuthenticated = true
            }) {
                Text("Login with Apple")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 60)
                    .background(Color.brandPrimary)
                    .cornerRadius(30)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}
