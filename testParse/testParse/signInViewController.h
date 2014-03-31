//
//  signInViewController.h
//  testParse
//
//  Created by Jingkui Wang on 3/29/14.
//  Copyright (c) 2014 Jingkui Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZGFormField.h"

@interface signInViewController : UIViewController <BZGFormFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *errorMessage;

- (IBAction)createAccount:(id)sender;
- (IBAction)dismiss:(id)sender;

@property (weak, nonatomic) IBOutlet BZGFormField *emailField;
@property (weak, nonatomic) IBOutlet BZGFormField *passwordField;
@property (weak, nonatomic) IBOutlet BZGFormField *passwordConfirmField;
@end
