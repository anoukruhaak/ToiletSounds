//
//  LoginViewController.m
//  ToilerSounds
//
//  Created by Anouk Ruhaak on 6/11/14.
//  Copyright (c) 2014 Djipsy. All rights reserved.
//

#import "LoginViewController.h"
#import "SWRevealViewController.h"
#import "RecordSoundsViewController.h"
#import "MySoundsViewController.h"

@interface LoginViewController () <UITextFieldDelegate>
{
    NSString *userPassword;
    NSString *userEmail;
}
@property (nonatomic, strong) UITextField *email;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UIButton *login;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:94.0/255.0 green:64.0/255.0 blue:194.0/255.0 alpha:0.7];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 300, 30)];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    titleLabel.text = @"Join ToiletSounds";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    self.email = [[UITextField alloc]initWithFrame:CGRectMake(20, 110, 280, 40)];
    self.email.layer.cornerRadius = 4.0;
    self.email.textAlignment = NSTextAlignmentCenter;
    self.email.delegate = self;
    self.email.tag = 1;
    self.email.backgroundColor = [UIColor whiteColor];
    self.email.placeholder = @" E-mail";
    [self.view addSubview:_email];
    
    self.password = [[UITextField alloc]initWithFrame:CGRectMake(20, 170, 280, 40)];
    self.password.secureTextEntry = YES;
    self.password.layer.cornerRadius = 4.0;
    self.password.textAlignment = NSTextAlignmentCenter;
    self.password.delegate = self;
    self.password.tag =2;
    self.password.backgroundColor = [UIColor whiteColor];
    self.password.placeholder = @" Password";
    [self.view addSubview:_password];
    
    self.login = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-80, 230, 60, 40)];
    [self.login setBackgroundColor:[UIColor blackColor]];
    [self.login setTitle:@"Login" forState:UIControlStateNormal];
    [self.login.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    [self.view addSubview: _login];
    self.login.layer.cornerRadius = 4.0;
    [self.login addTarget:self action:@selector(loginPressed) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)loginPressed
{
    UIAlertView *incompleteLogin;
    
    
    if (!userPassword || !userEmail) {
        incompleteLogin = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please provide email and password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [incompleteLogin show];
    }else if ((userEmail.length < 8) || (userPassword.length < 5))
    {
        incompleteLogin = [[UIAlertView alloc]initWithTitle:@"Error" message:@"1. Provide a valid e-mail \n2. Password should be at least 6 characters" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [incompleteLogin show];

    }else{
        //We're good to go! Save the values and continue
        [[NSUserDefaults standardUserDefaults]setValue:userPassword forKey:@"password"];
        [[NSUserDefaults standardUserDefaults]setValue:userEmail forKey:@"email"];
        [[NSUserDefaults standardUserDefaults]setValue:@"loggedIn" forKey: @"login_status"];
        
    
        MySoundsViewController *mySoundVC = [MySoundsViewController new];

        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:mySoundVC];
        
        [(SWRevealViewController*)self.parentViewController pushFrontViewController:frontNavigationController animated:NO];
    }
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}

-(void)resignKeyboard
{
    [[self view] endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSLog(@"GETS CALLED");
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [[self view] endEditing:YES];
    
    if (textField.tag ==1) {
        userEmail = textField.text;
    }else{
        userPassword = textField.text;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
