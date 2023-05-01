//
//  Copyright © 2021 Stream.io Inc. All rights reserved.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

class CustomMessageResolver: MessageTypeResolving {

    func hasCustomAttachment(message: ChatMessage) -> Bool {
        let messageComponents = message.text.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        return messageComponents.filter { component in
            isValidEmail(component)
        }
        .count > 0
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

}

struct CustomAttachmentView: View {

    @State var envelopeTapped = false

    let message: ChatMessage
    let width: CGFloat
    let isFirst: Bool

    var body: some View {
        HStack {
            Image(systemName: "envelope").onTapGesture {
                self.envelopeTapped = true
            }
            Text(message.text)
        }
        .padding()
        .alert(isPresented: $envelopeTapped) {
            Alert(
                title: Text("Tapped an envelope"),
                message: Text("Maybe show an email composer now?"),
                dismissButton: .cancel(Text("Ok"))
            )
        }
        .messageBubble(for: message, isFirst: isFirst)
    }
}
