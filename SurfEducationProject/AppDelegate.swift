//
//  AppDelegate.swift
//  SurfSummerSchoolProject
//
//  Created by Павел Рыжков on 03.08.2022.
//
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tokenStorage: TokenStorage {
        BaseTokenStorage()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }

        startApplicationProccess()
        return true
    }

    func startApplicationProccess() {
        runLaunchScreen()

        if let tokenContainer = try? tokenStorage.getToken(), !tokenContainer.isExpired {
            //runMainFlow()

            let authVC = AuthViewController()
            let navigationController = UINavigationController(rootViewController: authVC)
            self.window?.rootViewController = navigationController

        } else {
            let tempCredentials = AuthRequestModel(phone: "+79876543219", password: "qwerty")
            AuthService()
                    .performLoginRequestAndSaveToken(credentials: tempCredentials) { [weak self] result in
                        switch result {
                        case .success:
                            self?.runMainFlow()
                        case .failure:
                            // TODO: - Handle error, if token was not received
                            break
                        }
                    }
        }
    }

    func runMainFlow() {
        DispatchQueue.main.async {
            self.window?.rootViewController = TabBarConfigurator().configure()
        }
    }

    func runLaunchScreen() {
        let launchScreenViewController = UIStoryboard(name: "LaunchScreen", bundle: .main)
                .instantiateInitialViewController()

        window?.rootViewController = lauchScreenViewController
    }

}


