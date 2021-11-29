import StreamChat
import StreamChatSwiftUI
import UIKit
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var streamChat: StreamChat?

    var chatClient: ChatClient = {
        var config = ChatClientConfig(apiKey: .init("8br4watad788"))
        config.applicationGroupIdentifier = "group.io.getstream.iOS.ChatDemoAppSwiftUI"

        let client = ChatClient(config: config)
        return client
    }()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                        [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        var colors = ColorPalette()
        let streamBlue = UIColor(red: 0, green: 108.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
        colors.tintColor = Color(streamBlue)

        var fonts = Fonts()
        fonts.footnoteBold = Font.footnote
        fonts.body = Font.title

        let images = Images()
        images.reactionLoveBig = UIImage(systemName: "heart.fill")!

        let appearance = Appearance(colors: colors, images: images, fonts: fonts)

        let channelNamer: ChatChannelNamer = { channel, currentUserId in
            "This is our custom name: \(channel.name ?? "no name")"
        }
        let utils = Utils(channelNamer: channelNamer)
        
        streamChat = StreamChat(chatClient: chatClient, appearance: appearance, utils: utils)

        connectUser()
        
        return true
    }
    
    private func connectUser() {
        let token = try! Token(rawValue: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibHVrZV9za3l3YWxrZXIifQ.kFSLHRB5X62t0Zlc7nwczWUfsQMwfkpylC6jCUZ6Mc0")
            
        chatClient.connectUser(
                userInfo: .init(id: "luke_skywalker",
                                name: "Luke Skywalker",
                                imageURL: URL(string: "https://vignette.wikia.nocookie.net/starwars/images/2/20/LukeTLJ.jpg")!),
                token: token
        ) { error in
            if let error = error {
                log.error("connecting the user failed \(error)")
                return
            }
        }
    }
}

class CustomViewFactory: ViewFactory {
    @Injected(\.chatClient) public var chatClient
    
    func makeMessageTextView(for message: ChatMessage,
                             isFirst: Bool,
                             availableWidth: CGFloat) -> some View {
        return CustomMessageTextView(message: message, isFirst: isFirst)
    }
}

struct CustomMessageTextView: View {
    @Injected(\.colors) var colors
    @Injected(\.fonts) var fonts
    
    var message: ChatMessage
    var isFirst: Bool
    
    public var body: some View {
        Text(message.text)
            .padding()
            .messageBubble(for: message, isFirst: isFirst)
            .foregroundColor(Color(colors.text))
            .font(fonts.bodyBold)
            .overlay(
                BottomRightView {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .offset(x: 1, y: -1)
                }
            )
    }
}
