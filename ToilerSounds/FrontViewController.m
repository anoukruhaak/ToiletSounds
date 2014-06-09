//
//  FrontViewController.m
//  ToilerSounds
//
//  Created by Anouk Ruhaak on 6/8/14.
//  Copyright (c) 2014 Djipsy. All rights reserved.
//

#import "FrontViewController.h"
#import "SWRevealViewController.h"
#import "FrontViewController.h"


@interface FrontViewController ()

@end

@implementation FrontViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = NSLocalizedString(@"Front View", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Do" style:UIBarButtonItemStylePlain target:revealController action:@selector(rightRevealToggle:)];
    
    self.navigationItem.rightBarButtonItem = rightRevealButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
