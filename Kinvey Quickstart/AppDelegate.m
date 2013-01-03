//
//  AppDelegate.m
//  Kinvey Quickstart
//
//  Created by Michael Katz on 11/12/12.
//  Copyright (c) 2012-2013 Kinvey. All rights reserved.
//

#import "AppDelegate.h"
#import <KinveyKit/KinveyKit.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    (void) [[KCSClient sharedClient] initializeKinveyServiceForAppKey:@"<#My App Key#>"
                                                        withAppSecret:@"<#My App Secret#>"
                                                         usingOptions:nil];
    return YES;
}

@end
