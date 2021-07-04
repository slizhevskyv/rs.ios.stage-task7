//
//  AppDelegate.m
//  rs.ios.stage-task7
//
//  Created by Vladislav Slizhevsky on 7/3/21.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // create UIWindow instance
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // instantiate root view controller instance
    ViewController *rootVC = [[ViewController alloc] init];
    
    // assign rootVC as root window controller
    window.rootViewController = rootVC;
    
    // assign window as a property of AppDelegate
    self.window = window;
    
    // make window key and visible
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
