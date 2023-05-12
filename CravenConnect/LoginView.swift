//
//  LoginView.swift
//  Craven Connections
//
//  Created by Craven on 5/4/23.
//

import SwiftUI

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
