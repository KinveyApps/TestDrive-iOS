//
//  TestObject.h
//  Kinvey Quickstart
//
//  Created by Michael Katz on 11/12/12.
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>

@interface TestObject : NSObject <KCSPersistable>

@property (nonatomic, retain) NSString*  objectId;
@property (nonatomic, retain) NSString* name;

@end
