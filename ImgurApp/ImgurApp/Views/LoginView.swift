import SwiftUI

struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Text("Imgur Login")
                .font(.largeTitle)
                .padding()

            Button("Login with Imgur") {
                let authURL = authViewModel.startOAuthFlow()
                UIApplication.shared.open(authURL)
            }
            .padding()
            .onOpenURL { url in
                authViewModel.handleOAuthCallback(url: url)
            }
            .overlay(ErrorAlertView(error: $authViewModel.errorMessage))
        }
    }
}
