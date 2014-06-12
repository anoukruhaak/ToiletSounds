//
//  MySoundsViewController.m
//  ToilerSounds
//
//  Created by Anouk Ruhaak on 6/8/14.
//  Copyright (c) 2014 Djipsy. All rights reserved.
//	dg2tHR

#import "MySoundsViewController.h"
#import "SWRevealViewController.h"
#import "RecordSoundsViewController.h"
#import "SoundTableViewCell.h"
#import "SoundStore.h"
#import "Sound.h"

@interface MySoundsViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *allSounds;
    NSDateFormatter *dateFormatter;
}
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
    
    UIBarButtonItem *recordMenuButton = [[UIBarButtonItem alloc]initWithTitle:@"Record" style:UIBarButtonItemStylePlain target:revealController action:@selector(rightRevealToggle:)];
    self.navigationItem.rightBarButtonItem = recordMenuButton;
    
    UIBarButtonItem *revealMenuButton = [[UIBarButtonItem alloc] initWithTitle:@"☰" style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealMenuButton;
    
    self.soundsTableView = [[UITableView alloc]initWithFrame:self.view.frame];
    self.soundsTableView.delegate = self;
    self.soundsTableView.dataSource = self;
    self.soundsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
    self.soundsTableView.backgroundColor =[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0];
    [self.view addSubview:_soundsTableView];
    
    dateFormatter= [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMMM d"];

}

-(void)viewWillAppear:(BOOL)animated
{
    allSounds = [[SoundStore sharedStore]allSounds];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return allSounds.count;
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
    
    Sound *sound = [allSounds objectAtIndex:[indexPath row]];
    cell.name.text = sound.soundName;
    
    NSMutableString *soundDate = [NSMutableString new];
    
    if (sound.dateCreated) {
        [soundDate appendString:[dateFormatter stringFromDate:sound.dateCreated]];
    }else{
        [soundDate appendString:@""];
    }
    cell.recordedAt.text = soundDate;
    
    return  cell;

    
}

-(void)record
{
    //Move to the record view (adds an additional layer to the hamburger nav)
    RecordSoundsViewController *recordVC = [RecordSoundsViewController new];
    [(SWRevealViewController *)self.parentViewController setRightViewController:recordVC];
    [(SWRevealViewController *)self.parentViewController.navigationController rightRevealToggleAnimated:NO];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Sound *sound = [allSounds objectAtIndex:[indexPath row]];
        [[SoundStore sharedStore]removeSound:sound];
        allSounds = [[SoundStore sharedStore]allSounds];
        [self.soundsTableView reloadData];
    }
}

-(void)dealloc
{
    self.soundsTableView = nil;
    
}
@end
