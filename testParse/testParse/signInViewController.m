//
//  signInViewController.m
//  testParse
//
//  Created by Jingkui Wang on 3/29/14.
//  Copyright (c) 2014 Jingkui Wang. All rights reserved.
//

#import "signInViewController.h"
#import <Parse/Parse.h>
@implementation signInViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    self.emailField.textField.placeholder = @"Email";
    //email validation
    [self.emailField setTextValidationBlock:^BOOL(BZGFormField *field, NSString *text) {
        // from https://github.com/benmcredmond/DHValidation/blob/master/DHValidation.m
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailTest evaluateWithObject:text]) {
            field.alertView.title = @"Invalid email address";
            return NO;
        } else {
            return YES;
        }
    }];
    //Add online validation
    [self.emailField setAsyncTextValidationBlock:^BOOL(BZGFormField *field, NSString *text) {
        NSError *error;
        NSString *str = [NSString stringWithFormat:@"https://api.mailgun.net/v2/address/validate?address=%@&api_key=%@", [text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"pubkey-5ogiflzbnjrljiky49qxsiozqef5jxp7"];
        NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
        
        if (!responseData) {
            field.alertView.title = @"Cannot validate";
            return NO;
        }
        
        id json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        if (!json || error) {
            field.alertView.title = @"Cannot validate";
            return NO;
        }
        
        BOOL isValid = [json[@"is_valid"] boolValue];
        if (!isValid) {
            field.alertView.title = @"Invalid email address (online)";
        }
        
        return isValid;
    }];

    // password validation
    self.passwordField.textField.placeholder = @"Password";
    self.passwordField.textField.secureTextEntry = YES;
    [self.passwordField setTextValidationBlock:^BOOL(BZGFormField *field, NSString *text) {
        if (text.length < 8) {
            field.alertView.title = @"Password is too short";
            return NO;
        } else {
            return YES;
        }
    }];
    // password
    self.passwordConfirmField.textField.placeholder = @"Confirm Password";
    self.passwordConfirmField.textField.secureTextEntry = YES;
    [self.passwordConfirmField setTextValidationBlock:^BOOL(BZGFormField *field, NSString *text) {
        if (![text isEqualToString:self.passwordField.textField.text]) {
            field.alertView.title = @"Password confirm doesn't match";
            return NO;
        } else {
            return YES;
        }
    }];
    
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    self.passwordConfirmField.delegate = self;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (IBAction)createAccount:(id)sender {
    if ([self.emailField formFieldState] == BZGFormFieldStateInvalid ||
        [self.emailField formFieldState] == BZGFormFieldStateNone) {
        [self.errorMessage setText:@"Invaild Email"];
        return;
    }
    if ([self.passwordField formFieldState] == BZGFormFieldStateInvalid ||
        [self.passwordField formFieldState] == BZGFormFieldStateNone) {
        [self.errorMessage setText:@"Invaild password"];
        return;
    }
    NSString *password = [self.passwordField.textField text];
    NSString *passwordConfirm = [self.passwordField.textField text];

    if (![password isEqualToString:passwordConfirm] ||
        [self.passwordConfirmField formFieldState] == BZGFormFieldStateNone) {
        [self.errorMessage setText:@"Confirm your password"];
        return;
    }
    
    
    PFUser *user = [PFUser user];
    user.username = [self.emailField.textField text];
    user.password = [self.passwordField.textField text];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            // go back to the previous view
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            //NSString *errorString = [error userInfo][@"error"];
            [self.errorMessage setText:@"Username already taken"];
            // Show the errorString somewhere and let the user try again.
        }
    }];
}

- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
