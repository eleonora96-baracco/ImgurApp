import SwiftUI

struct ErrorAlertView: View {
    @Binding var error: IdentifiableError?

    var body: some View {
        EmptyView()
            .alert(item: $error) { error in
                Alert(
                    title: Text("Error"),
                    message: Text(error.message),
                    dismissButton: .default(Text("OK"))
                )
            }
    }
}

