//
//  ViewController.m
//  testParse
//
//  Created by Jingkui Wang on 3/29/14.
//  Copyright (c) 2014 Jingkui Wang. All rights reserved.
//

#import "mainViewController.h"
#import <Parse/Parse.h>

@interface mainViewController ()

@end

@implementation mainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.secretTextField.delegate = self;
	// Do any additional setup after loading the view, typically from a nib.
    
    
}
-(void)viewWillAppear:(BOOL)animated {
    [self.secretTextField setPlaceholder:@"Tell me your secret."];
    PFUser *user = [PFUser currentUser];
    if (user) {
        PFQuery *query = [PFQuery queryWithClassName:@"Secrets"];
        [query whereKey:@"user" equalTo:user];
        [query findObjectsInBackgroundWithBlock:^(NSArray *userPosts, NSError *error) {
            if (!error) {
                if ([userPosts count]) {
                    PFObject *post = userPosts[0];
                    [self.secretTextField setText: post[@"secret"]];
                }
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];

    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (IBAction)saveSecret:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        PFQuery *query = [PFQuery queryWithClassName:@"Secrets"];
        [query whereKey:@"user" equalTo:currentUser];
        [query findObjectsInBackgroundWithBlock:^(NSArray *userPosts, NSError *error) {
            if (!error) {
                if ([userPosts count]) {
                    PFObject *post = userPosts[0];
                    post[@"secret"] = [self.secretTextField text];
                    post[@"user"] = currentUser;
                    [post saveInBackground];
                } else{
                    PFObject *post = [PFObject objectWithClassName:@"Secrets"];
                    post[@"secret"] = [self.secretTextField text];
                    post[@"user"] = currentUser;
                    [post saveInBackground];
                }
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    } else {
        // show the signup or login screen
        [self performSegueWithIdentifier:@"logInSeague" sender:self];
    }
}

- (IBAction)signOutUser:(id)sender {
    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
    } else {
        // show the signup or login screen
        [self performSegueWithIdentifier:@"logInSeague" sender:self];
    }
}


@end
