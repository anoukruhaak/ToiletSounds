//
//  PartySoundsViewController.m
//  ToilerSounds
//
//  Created by Anouk Ruhaak on 6/8/14.
//  Copyright (c) 2014 Djipsy. All rights reserved.
//

#import "PartySoundsViewController.h"
#import "SWRevealViewController.h"

@interface PartySoundsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *partySoundsTable;

@end

@implementation PartySoundsViewController

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
    self.title = NSLocalizedString(@"Sound Stream", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *revealMenuButton = [[UIBarButtonItem alloc] initWithTitle:@"☰" style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealMenuButton;
    
    self.partySoundsTable = [[UITableView alloc]initWithFrame:self.view.frame];
    self.partySoundsTable.delegate = self;
    self.partySoundsTable.dataSource = self;
    [self.view addSubview: _partySoundsTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 5;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
	}
    
    cell.textLabel.text = @"Sound";
    cell.detailTextLabel.text =@"Created by: John Doe";
    
    return  cell;
    
    
}

@end
