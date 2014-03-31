//
//  logInViewController.m
//  testParse
//
//  Created by Jingkui Wang on 3/30/14.
//  Copyright (c) 2014 Jingkui Wang. All rights reserved.
//

#import "logInViewController.h"
#import <Parse/Parse.h>

@implementation logInViewController

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
    
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}


- (IBAction)logInButton:(id)sender {
    NSString *userName = [ self.emailField.textField text];
    NSString *passWord = [ self.passwordField.textField text];
    [PFUser logInWithUsernameInBackground:userName password:passWord
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            [self.navigationController popViewControllerAnimated:YES];
                                        } else {
                                            // The login failed. Check error to see why.
                                            [self.errorMessage setText:@"check your password"];
                                            
                                        }
                                    }];

}
- (IBAction)signUpButton:(id)sender {
    [self performSegueWithIdentifier:@"signUpSeague" sender:self];
}

@end
