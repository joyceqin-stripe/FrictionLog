//
//  SceneDelegate.swift
//  FrictionLog
//
//  Created by Joyce Qin on 8/21/24.
//

import UIKit
import StripeCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = scene as? UIWindowScene else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // Create the root view controller
        let viewController = ViewController()
        let watchNav = UINavigationController(rootViewController: viewController)
        
        let shopViewController = ShopViewController() // Your initial view controller
        let shopNav = UINavigationController(rootViewController: shopViewController)
        
        let checkoutViewController = CheckoutViewController()
        let checkoutNav = UINavigationController(rootViewController: checkoutViewController)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [watchNav, shopNav, checkoutNav]
        tabBarController.tabBar.tintColor = Constants.focusColor // Change selected tab color
        tabBarController.tabBar.unselectedItemTintColor = Constants.blurColor
        // Set the shadow properties of the navigation bar
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: -8, width: tabBarController.tabBar.bounds.width, height: 1))
        
        tabBarController.tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBarController.tabBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        tabBarController.tabBar.layer.shadowOpacity = 0.5
        tabBarController.tabBar.layer.shadowRadius = 0.0
        tabBarController.tabBar.layer.shadowPath = shadowPath.cgPath
        
        
        // Configure tab bar items
        viewController.tabBarItem = UITabBarItem(title: "Watch", image: UIImage(systemName: "play.rectangle.fill"), tag: 0)
        shopViewController.tabBarItem = UITabBarItem(title: "Shop", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        checkoutViewController.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart.fill"), tag: 2)
        
        // Set the tab bar controller as the root view controller
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    // This method handles opening custom URL schemes (for example, "your-app://stripe-redirect")
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        let stripeHandled = StripeAPI.handleURLCallback(with: url)
        if (!stripeHandled) {
            // This was not a Stripe url – handle the URL normally as you would
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

