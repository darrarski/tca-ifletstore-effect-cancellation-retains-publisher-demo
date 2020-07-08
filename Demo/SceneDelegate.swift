import ComposableArchitecture
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        let view = TimerView(store: .init(
            initialState: .init(),
            reducer: timerReducer,
            environment: TimerEnvironment(
                mainQueue: AnyScheduler(DispatchQueue.main)
            )
        ))
        window?.rootViewController = UIHostingController(rootView: view)
        window?.makeKeyAndVisible()
    }

}
