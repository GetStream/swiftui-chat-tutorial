//
//  SwiftUIChatDemoApp.swift
//  SwiftUIChatDemo
//
//  Created by Jeroen Leenarts on 26/11/2021.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

@main
struct SwiftUIChatDemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ChatChannelListView()
        }
    }
}
