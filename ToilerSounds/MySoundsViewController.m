//
//  MySoundsViewController.m
//  ToilerSounds
//
//  Created by Anouk Ruhaak on 6/8/14.
//  Copyright (c) 2014 Djipsy. All rights reserved.
//	dg2tHR

#import "MySoundsViewController.h"
#import "SWRevealViewController.h"
#import "PartySoundsViewController.h"
#import "RecordSoundsViewController.h"
#import "SoundTableViewCell.h"
#import "SoundStore.h"
#import "Sound.h"

@interface MySoundsViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
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
    
    UIBarButtonItem *recordMenuButton = [[UIBarButtonItem alloc]initWithTitle:@"Record" style:UIBarButtonItemStylePlain target:self action:@selector(pushRecordController)];
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

	
	if (cell == nil)
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
    
    //Add target for play audio
    //Add target for send audio to server
    [cell.sendSound addTarget:self action:@selector(sendSound:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return  cell;

}

-(void)sendSound:(id)sender
{
    //Get the cell
    UIView *contentView = [sender superview];
    UIView *scrollView = [contentView superview];
    SoundTableViewCell *cell = (SoundTableViewCell *)[scrollView superview];
    
    //Get Sound
    Sound *sound = [allSounds objectAtIndex:[self.soundsTableView indexPathForCell:cell].row];
    NSLog(@"Sound:%@", sound.soundName);
    
    //Ask for party number (unless we have one that is less than 24h old
    NSDate *lastParty = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastParty"];
    NSDate *now = [NSDate new];
    
    
    if (!lastParty ) {
        //Create popup asking party number
        UIAlertView *nameAlert = [[UIAlertView alloc]initWithTitle:@"Party Code" message:@"Enter the code for your party" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        //Add a textfield
        nameAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
        
        //set delegate
        nameAlert.delegate = self;
        
        [nameAlert show];

        }else{
            
            [self acceptSendSound];
        }
    
    //Go to stream. TODO: this belongs in the callback from the downloadmanager

}

-(void)acceptSendSound
{
    //send
    //show buffer -> wait for replay
    [self moveToStreams];
    
}

-(void)moveToStreams
{
    PartySoundsViewController *partyVC = [PartySoundsViewController new];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:partyVC];
    SWRevealViewController *rev = (SWRevealViewController *)self.navigationController.parentViewController;
    [rev pushFrontViewController:nav animated:NO];
    
}


-(void)pushRecordController
{
    //Move to the record view (adds an additional layer to the hamburger nav)
    RecordSoundsViewController *recordVC = [[RecordSoundsViewController alloc] init];
	[self.navigationController pushViewController:recordVC animated:YES];
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

#pragma mark - AlertView delegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //Create a date for the party
    NSDate *updated = [NSDate new];
    NSString *partyid = [alertView textFieldAtIndex:0].text;
    [[NSUserDefaults standardUserDefaults]setObject:partyid forKey:@"party_id"];
    [[NSUserDefaults standardUserDefaults]setObject:updated forKey:@"lastParty"];
    NSLog(@"%@,%@", updated, partyid);
    
    //Now show the activityIndicator
        [self moveToStreams];
    
}

// TODO: if error (part_id), delete lastParty date and ask user to give id again.
// TODO: if success go to the stream

-(void)dealloc
{
    self.soundsTableView = nil;
    
}
@end
