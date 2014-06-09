//
//  RearViewController.m
//  ToilerSounds
//
//  Created by Anouk Ruhaak on 6/8/14.
//  Copyright (c) 2014 Djipsy. All rights reserved.
//

#import "RearViewController.h"
#import "SWRevealViewController.h"
#import "FrontViewController.h"
#import "RecordSoundsViewController.h"
#import "MySoundsViewController.h"
#import "PartySoundsViewController.h"

@interface RearViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *rearTableView;

@end

@implementation RearViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rearTableView = [[UITableView alloc]initWithFrame:self.view.frame];
    self.rearTableView.delegate = self;
    self.rearTableView.dataSource =self;
    self.rearTableView.userInteractionEnabled = YES;
    [self.view addSubview:_rearTableView];
    
	// We determine whether we have a grand parent SWRevealViewController, this means we are at least one level behind the hierarchy
    SWRevealViewController *parentRevealController = self.revealViewController;
    SWRevealViewController *grandParentRevealController = parentRevealController.revealViewController;
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:grandParentRevealController action:@selector(revealToggle:)];
    
    // if we have a reveal controller as a grand parent, this means we are are being added as a
    // child of a detail (child) reveal controller, so we add a gesture recognizer provided by our grand parent to our
    // navigation bar as well as a "reveal" button
    if ( grandParentRevealController )
    {
        // to present a title, we count the number of ancestor reveal controllers we have, this is of course
        // only a hack for demonstration purposes, on a real project you would have a model telling this.
        NSInteger level=0;
        UIViewController *controller = grandParentRevealController;
        while( nil != (controller = [controller revealViewController]) )
            level++;
        
        NSString *title = [NSString stringWithFormat:@"Detail Level %ld", (long)level];
        
        [self.navigationController.navigationBar addGestureRecognizer:grandParentRevealController.panGestureRecognizer];
        self.navigationItem.leftBarButtonItem = revealButtonItem;
        self.navigationItem.title = title;
    }
    
    // otherwise, we are in the top reveal controller, so we just add a title
    else
    {
        self.navigationItem.title = @"Toilet Sounds";
    }
    
}


#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
	
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
	}
	
	if (row == 0)
	{
		cell.textLabel.text = @"Record";
	}
	else if (row == 1)
	{
		cell.textLabel.text = @"My Sounds";
	}
	else if (row == 2)
	{
		cell.textLabel.text = @"Sound Stream";
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWRevealViewController *revealController = [self revealViewController];
    UIViewController *frontViewController = revealController.frontViewController;
    UINavigationController *frontNavigationController =nil;
    
    if ( [frontViewController isKindOfClass:[UINavigationController class]] )
        frontNavigationController = (id)frontViewController;
    
    NSInteger row = indexPath.row;
    
	// Here you'd implement some of your own logic... I simply take for granted that the first row (=0) corresponds to the "FrontViewController".
	if (row == 0)
	{
		// Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
        if ( ![frontNavigationController.topViewController isKindOfClass:[RecordSoundsViewController class]] )
        {
			RecordSoundsViewController *frontViewController = [[RecordSoundsViewController alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
			[revealController pushFrontViewController:navigationController animated:YES];
        }
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
            [revealController revealToggleAnimated:YES];
		}
	}
    
	// ... and the second row (=1) corresponds to the "MapViewController".
	else if (row == 1)
	{
		// Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
        if ( ![frontNavigationController.topViewController isKindOfClass:[MySoundsViewController class]] )
        {
			MySoundsViewController *mapViewController = [[MySoundsViewController alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
			[revealController pushFrontViewController:navigationController animated:YES];
		}
        
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
            [revealController revealToggleAnimated:YES];
		}
	}
	else if (row == 2)
	{
        // Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
        if ( ![frontNavigationController.topViewController isKindOfClass:[PartySoundsViewController class]] )
        {
			PartySoundsViewController *mapViewController = [[PartySoundsViewController alloc] init];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
			[revealController pushFrontViewController:navigationController animated:YES];
		}
        
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
            [revealController revealToggleAnimated:YES];
		}
	}
}

@end
