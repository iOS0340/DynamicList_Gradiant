//
//  DynamicList_GradiantApp.swift
//  DynamicList_Gradiant
//
//  Created by Bhavesh Patel on 16/07/24.
//

import SwiftUI

@main
struct DynamicList_GradiantApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}


extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}
