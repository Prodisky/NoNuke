//
//  AppDelegate.m
//  NoNuke
//
//  Created by Paul Wu on 12/6/28.
//  Copyright (c) 2012年 Prodisky. All rights reserved.
//

#import "AppDelegate.h"
#import "ARViewController.h"

@interface AppDelegate () {
	ARViewController *viewController;
}
@end

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	
	viewController = [ARViewController new];
	
	[self.window addSubview:viewController.view];
	
	UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    AwesomeMenuItem *menuItem1 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed ContentImage:[UIImage imageNamed:@"Icon-1.png"] highlightedContentImage:nil];
	
    AwesomeMenuItem *menuItem2 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed ContentImage:[UIImage imageNamed:@"Icon-2.png"] highlightedContentImage:nil];
	
    AwesomeMenuItem *menuItem3 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed ContentImage:[UIImage imageNamed:@"Icon-3.png"] highlightedContentImage:nil];
	
    AwesomeMenuItem *menuItem4 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed ContentImage:[UIImage imageNamed:@"Icon-4.png"] highlightedContentImage:nil];
	
    AwesomeMenuItem *menuItemx = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed ContentImage:[UIImage imageNamed:@"Icon-x.png"] highlightedContentImage:nil];
    
    NSArray *menus = [NSArray arrayWithObjects:menuItem1, menuItem2, menuItem3, menuItem4, menuItemx, nil];
	
	AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.window.bounds menus:menus];
	
	menu.rotateAngle = -M_PI / 2 + M_PI / 2 / [menus count];
	menu.menuWholeAngle = M_PI;
	
	menu.startPoint = CGPointMake(160, [[UIScreen mainScreen] bounds].size.height - 30);
	
	menu.delegate = self;
	[self.window addSubview:menu];

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)AwesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx {
	switch (idx) {
		case 0:
			viewController.nukeStatus = NukeStatus1;
			break;
		case 1:
			viewController.nukeStatus = NukeStatus2;
			break;
		case 2:
			viewController.nukeStatus = NukeStatus3;
			break;
		case 3:
			viewController.nukeStatus = NukeStatus4;
			break;
		default:
			viewController.nukeStatus = NukeStatusNone;
			break;
	}
}
@end
