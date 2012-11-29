//
//  ViewController.m
//  Kinvey Quickstart
//
//  Created by Michael Katz on 11/12/12.
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import "ViewController.h"
#import "TestObject.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)save:(id)sender
{
    
    // Define an instance of our test object
    TestObject *testObject = [[TestObject alloc] init];
    
    // Assign it the unique ID of 12345 (If this value is nil, Kinvey will assign a unique ID)
    // but we'll be loading by id later, so we're keeping it simple for now
    testObject.objectId = @"12345";
    
    // This is the data we'll save
    testObject.name = @"My first data!";
    
    // Get a reference to a backend collection called "testObjects", which is filled with
    // instances of TestObject
    KCSCollection *testObjects = [KCSCollection collectionFromString:@"testObjects" ofClass:[TestObject class]];
    
    // Create a data store connected to the collection, in order to save and load TestObjects
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:testObjects options:nil];
    
    // Save our instance to the store
    [store saveObject:testObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        // Right now just pop-up an alert about what we got back from Kinvey during
        // the save.  Normally you would want to implement more code here
        if (errorOrNil == nil && objectsOrNil != nil) {
            //save is successful!
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save worked!"
                                                            message:[NSString stringWithFormat:@"Saved: '%@'",[objectsOrNil[0] name]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            
            [alert show];
            
        } else {
            //save failed
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save failed"
                                                            message:[errorOrNil localizedDescription]
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            
            [alert show];
            
        }
    } withProgressBlock:nil];
}

- (IBAction)load:(id)sender
{
    // Get a reference to a backend collection called "testObjects", which is filled with
    // instances of TestObject
    KCSCollection *testObjects = [KCSCollection collectionFromString:@"testObjects" ofClass:[TestObject class]];
    
    // Create a data store connected to the collection, in order to save and load TestObjects
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:testObjects options:nil];
    
    // This will load the saved 12345 item from the backend
    [store loadObjectWithID:@"12345" withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        // Right now just pop-up an alert about what we got back from Kinvey during
        // the load.  Normally you would want to implement more code here
        if (errorOrNil == nil && objectsOrNil != nil) {
            //save is successful!
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Load worked!"
                                                            message:[NSString stringWithFormat:@"Loaded: '%@'",[objectsOrNil[0] name]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            
            [alert show];
            
        } else {
            //save failed
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Load failed"
                                                            message:[errorOrNil localizedDescription]
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            
            [alert show];
            
        }

    } withProgressBlock:nil];
}
@end
