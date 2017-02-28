//
//  ViewController.m
//  Kinvey Quickstart
//
//  Created by Michael Katz on 11/12/12.
//
//  Copyright 2012-2014 Kinvey, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "ViewController.h"
#import "Kinvey_Test_Drive-Swift.h"
@import Kinvey;

#define CREATE_NEW_ENTITY_ALERT_VIEW 100

@interface ViewController ()
@property (nonatomic, strong) NSArray* objects;
@end

@implementation ViewController

- (IBAction)add:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Create a New Entity"
                                                    message:@"Enter a title for the new entity"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Save", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = CREATE_NEW_ENTITY_ALERT_VIEW;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == CREATE_NEW_ENTITY_ALERT_VIEW) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            // Define an instance of our test object
            TestObject *testObject = [[TestObject alloc] init];
            
            // This is the data we'll save
            testObject.name = [[alertView textFieldAtIndex:0] text];
            
            // Create a data store connected to the collection, in order to save and load TestObjects
            KinveyDataStoreTestObject* store = [[KinveyDataStoreTestObject alloc] init];
            
            // Save our instance to the store
            [store save:testObject completionHandler:^(TestObject * _Nullable objectOrNil, NSError * _Nullable errorOrNil) {
                // Right now just pop-up an alert about what we got back from Kinvey during
                // the save.  Normally you would want to implement more code here
                if (errorOrNil == nil && objectOrNil != nil) {
                    //save is successful!
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save worked!"
                                                                    message:[NSString stringWithFormat:@"Saved: '%@'",[objectOrNil name]]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                    
                    [alert show];
                    
                    self.objects = [@[testObject] arrayByAddingObjectsFromArray:_objects];
                    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                } else {
                    //save failed
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save failed"
                                                                    message:[errorOrNil localizedDescription]
                                                                   delegate:self
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                    
                    [alert show];
                    
                }
            }];
        }
    }
}


- (IBAction)load:(id)sender
{
    // Create a data store connected to the collection, in order to save and load TestObjects
    KinveyDataStoreTestObject* store = [[KinveyDataStoreTestObject alloc] init];
    
    NSString* key = [NSString stringWithFormat:@"%@.%@", [KinveyConstants persistableMetadataKey], [KinveyConstants metadataLastModifiedTimeKey]];
    Query* query = [[Query alloc] initWithSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:key ascending:NO]]];
    
    // This will load the saved 12345 item from the backend
    [store find:query completionHandler:^(NSArray<TestObject *> * _Nullable objectsOrNil, NSError * _Nullable errorOrNil) {
        [sender endRefreshing];
        // Right now just pop-up an alert about what we got back from Kinvey during
        // the load.  Normally you would want to implement more code here
        if (errorOrNil == nil && objectsOrNil != nil) {
            //load is successful!
            _objects = objectsOrNil;
            [self.tableView reloadData];
        } else {
            //load failed
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Load failed"
                                                            message:[errorOrNil localizedDescription]
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            
            [alert show];
            
        }
    }];
}

#pragma mark - View Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    _objects = @[];
    [self.refreshControl addTarget:self
                            action:@selector(load:)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (![[KinveyClient sharedClient] activeUser]) {
        [User signUpWithCompletionHandler:^(User * _Nullable user, NSError * _Nullable errorOrNil) {
            if (errorOrNil != nil) {
                //load failed
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"User creation failed"
                                                                message:[errorOrNil localizedDescription]
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                
                [alert show];
            } else {
                [self load:nil];
            }
        }];
    } else {
        [self load:nil];
    }
}


#pragma mark - Table View Stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"aCell"];
    cell.textLabel.text = [_objects[indexPath.row] name];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TestObject* objToDelete = [_objects objectAtIndex:indexPath.row];
        NSMutableArray* newObjects  = [_objects mutableCopy];
        [newObjects removeObjectAtIndex:indexPath.row];
        self.objects = newObjects;
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // Create a data store connected to the collection, in order to save and load TestObjects
        KinveyDataStoreTestObject* store = [[KinveyDataStoreTestObject alloc] init];
        
        // Remove our instance from the store
        [store remove:objToDelete completionHandler:^(NSInteger count, NSError * _Nullable errorOrNil) {
            if (errorOrNil == nil) {
                //delete is successful!
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete successful!"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                
                [alert show];
            } else {
                //delete failed
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete failed"
                                                                message:[errorOrNil localizedDescription]
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                
                [alert show];
                
            }
        }];
    }
}
@end
