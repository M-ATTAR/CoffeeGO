//
//  SceneDelegate.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 08/12/2021.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let firebaseAuth = FirebaseAuthManager()
    let defaults = UserDefaults.standard

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        if let _ = Auth.auth().currentUser {
            if defaults.string(forKey: "role") == "admin" {
                window?.rootViewController = UIStoryboard(name: K.dashboardStoryboard, bundle: nil).instantiateViewController(withIdentifier: K.dashboardTabBarID) as! UITabBarController
            }
        } else {
            window?.rootViewController = UIStoryboard(name: K.mainStoryboard, bundle: .main).instantiateViewController(withIdentifier: K.rootNC) as! UINavigationController
        }
        
//        if Auth.auth().currentUser == nil {
//            
//        } else {
//        
//            window?.rootViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: K.verificationVCID) as! VerificationViewController
//        }
        
        
        window?.makeKeyAndVisible()
    }
    
    func setRootViewController(_ vc: UIViewController) {
        if let window = self.window {
            window.rootViewController = vc
            UIView.transition(with: window,
                              duration: 0.8,
                              options: .transitionFlipFromRight,
                              animations: nil)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

