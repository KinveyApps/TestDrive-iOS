//
//  TestObject.m
//  Kinvey Quickstart
//
//  Created by Michael Katz on 11/12/12.
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import "TestObject.h"

@implementation TestObject

- (NSDictionary *)hostToKinveyPropertyMapping
{
    return  @{ @"objectId" : KCSEntityKeyId, @"name" : @"name" };
}

@end
