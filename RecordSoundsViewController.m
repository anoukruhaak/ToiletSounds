//
//  RecordSoundsViewController.m
//  ToilerSounds
//
//  Created by Anouk Ruhaak on 6/8/14.
//  Copyright (c) 2014 Djipsy. All rights reserved.
//

#import "RecordSoundsViewController.h"
#import "SWRevealViewController.h"

@interface RecordSoundsViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UITextField *soundName;

@end

@implementation RecordSoundsViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0];
    
    self.recordButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 -30, 420.0, 60, 60)];
    self.recordButton.backgroundColor = [UIColor redColor];
    self.recordButton.layer.cornerRadius = 30.0;
    self.recordButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.recordButton.layer.borderWidth = 14.0;
    [self.view addSubview:_recordButton];
    
    self.soundName = [[UITextField alloc]initWithFrame:CGRectMake(20, 120, 280, 55)];
    self.soundName.layer.cornerRadius = 4;
    self.soundName.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.soundName.layer.borderWidth = 2.0;
    self.soundName.backgroundColor = [UIColor whiteColor];
    self.soundName.placeholder = @"Name your sound";
    self.soundName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_soundName];
    
    
    self.title = NSLocalizedString(@"Record", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *revealMenuButton = [[UIBarButtonItem alloc] initWithTitle:@"☰" style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealMenuButton;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Text Field


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
    return YES;
}


@end
