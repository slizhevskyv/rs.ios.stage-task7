//
//  SceneDelegate.m
//  rs.ios.stage-task7
//
//  Created by Vladislav Slizhevsky on 7/3/21.
//

#import "SceneDelegate.h"
#import "ViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions  API_AVAILABLE(ios(13.0)){
    // create UIWindow instance
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    
    // instantiate root view controller instance
    ViewController *rootVC = [[ViewController alloc] init];
    
    // assign rootVC as root window controller
    window.rootViewController = rootVC;
    
    // assign window as a property of AppDelegate
    self.window = window;
    
    // make window key and visible
    [self.window makeKeyAndVisible];
}

@end
