//
//  signInViewController.h
//  testParse
//
//  Created by Jingkui Wang on 3/29/14.
//  Copyright (c) 2014 Jingkui Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZGFormField.h"

@interface logInViewController : UIViewController <BZGFormFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *errorMessage;

@property (weak, nonatomic) IBOutlet BZGFormField *emailField;
@property (weak, nonatomic) IBOutlet BZGFormField *passwordField;
- (IBAction)logInButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end
