//
//  MyHabitsApp.swift
//  MyHabits
//
//  Created by Сергей Минеев on 5/14/24.
//

import SwiftUI

@main
struct MyHabitsApp: App {
    @State private var isActive = false

    var body: some Scene {
        WindowGroup {
            if isActive {
                MainTabBarControllerWrapper()
            } else {
                LaunchScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.isActive = true
                        }
                    }
            }
        }
    }
}

struct MainTabBarControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return MainTabBarController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
