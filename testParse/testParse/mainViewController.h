//
//  ViewController.h
//  testParse
//
//  Created by Jingkui Wang on 3/29/14.
//  Copyright (c) 2014 Jingkui Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mainViewController : UIViewController
- (IBAction)saveSecret:(id)sender;
- (IBAction)signOutUser:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *secretTextField;

@end
