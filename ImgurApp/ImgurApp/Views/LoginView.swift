import SwiftUI

struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var isShowingSafari = false
    
    var body: some View {
        VStack {
            Text("Imgur Login")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.darkGreen)
                .accessibilityIdentifier("LoginViewTitle")
            
            Button("Login with Imgur") {
                let authURL = authViewModel.startOAuthFlow()
                UIApplication.shared.open(authURL)
            }
            .padding()
            .background(.customGreen)
            .foregroundColor(.white)
            .cornerRadius(10)
            .accessibilityIdentifier("LoginButton")
            
            .onOpenURL { url in
                authViewModel.handleOAuthCallback(url: url)
            }
            .overlay(ErrorAlertView(error: $authViewModel.errorMessage))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.customWhite)
    }
}
