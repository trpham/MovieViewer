//
//  AppDelegate.m
//  MovieViewer
//
//  Created by nathan on 6/24/17.
//  Copyright © 2017 Nathan Pham. All rights reserved.
//

#import "AppDelegate.h"
#import "MoviesViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController* nowPlayingNavigationController = (UINavigationController* )[storyboard instantiateViewControllerWithIdentifier:@"MoviesNavigationController"];
    nowPlayingNavigationController.tabBarItem.title = @"Now Playing";
    nowPlayingNavigationController.tabBarItem.image = [UIImage imageNamed:@"nowplaying"];
    MoviesViewController* nowPlayingViewController = (MoviesViewController *) nowPlayingNavigationController.topViewController;
    nowPlayingViewController.endpoint = @"now_playing";
    
    UINavigationController* topRatedNavigationController = (UINavigationController* )[storyboard instantiateViewControllerWithIdentifier:@"MoviesNavigationController"];
    topRatedNavigationController.tabBarItem.title = @"Top Rated";
    topRatedNavigationController.tabBarItem.image = [UIImage imageNamed:@"toprated"];
    MoviesViewController* topRatedViewController = (MoviesViewController *) topRatedNavigationController.topViewController;
    topRatedViewController.endpoint = @"top_rated";
    
    UINavigationController* upcomingNavigationController = (UINavigationController* )[storyboard instantiateViewControllerWithIdentifier:@"MoviesNavigationController"];
    upcomingNavigationController.tabBarItem.title = @"Upcoming";
    upcomingNavigationController.tabBarItem.image = [UIImage imageNamed:@"upcoming"];
    MoviesViewController* upcomingViewController = (MoviesViewController *) upcomingNavigationController.topViewController;
    upcomingViewController.endpoint = @"upcoming";
    
    UITabBarController* tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[nowPlayingNavigationController, topRatedNavigationController, upcomingNavigationController];
    
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
