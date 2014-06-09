//
//  MySoundsViewController.m
//  ToilerSounds
//
//  Created by Anouk Ruhaak on 6/8/14.
//  Copyright (c) 2014 Djipsy. All rights reserved.
//

#import "MySoundsViewController.h"
#import "SWRevealViewController.h"
#import "SoundTableViewCell.h"

@interface MySoundsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *soundsTableView;

@end

@implementation MySoundsViewController

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
    self.title = NSLocalizedString(@"My Sounds", nil);
    self.view.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *revealMenuButton = [[UIBarButtonItem alloc] initWithTitle:@"☰" style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealMenuButton;
    
    self.soundsTableView = [[UITableView alloc]initWithFrame:self.view.frame];
    self.soundsTableView.delegate = self;
    self.soundsTableView.dataSource = self;
    self.soundsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
    self.soundsTableView.backgroundColor =[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0];
    [self.view addSubview:_soundsTableView];

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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	SoundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"soundCell"];

	
	if (nil == cell)
	{
		[tableView registerNib:[UINib nibWithNibName:@"SoundTableViewCell" bundle:nil]  forCellReuseIdentifier:@"soundCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"soundCell"];
        
	}
    
    cell.name.text = @"My Sound";
    cell.recordedAt.text =@"June 15";
    
    return  cell;

    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
