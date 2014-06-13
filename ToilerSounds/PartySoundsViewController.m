//
//  PartySoundsViewController.m
//  ToilerSounds
//
//  Created by Anouk Ruhaak on 6/8/14.
//  Copyright (c) 2014 Djipsy. All rights reserved.
//

#import "PartySoundsViewController.h"
#import "SWRevealViewController.h"
#import "RecordSoundsViewController.h"

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
    self.view.backgroundColor = kBackgroundColor;
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *revealMenuButton = [[UIBarButtonItem alloc] initWithTitle:@"☰" style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealMenuButton;
    
    UIBarButtonItem *recordMenuButton = [[UIBarButtonItem alloc]initWithTitle:@"Record" style:UIBarButtonItemStylePlain target:self action:@selector(pushRecordController)];
    self.navigationItem.rightBarButtonItem = recordMenuButton;
    
    self.partySoundsTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-40)];
    self.partySoundsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    cell.detailTextLabel.text =@"By Carl Carlson";
    
    return  cell;
    
    
}

-(void)requestSounds
{
    NSURL *baseUrl = [[NSURL alloc]initWithString:@"myUrl"];
    NSDictionary *sounds;
    
    NSURLSessionConfiguration *sessionConfig =
    [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // 1
    sessionConfig.allowsCellularAccess = YES;
    
    // 2
    [sessionConfig setHTTPAdditionalHeaders:
     @{@"Accept": @"application/json"}];
    
}

-(void)getSoundForUrl
{
    NSURL *audioUrl;
    
    // 1
    NSURLSessionConfiguration *sessionConfig =
    [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // 2
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:sessionConfig
                                  delegate:self
                             delegateQueue:nil];
    
    //3
    NSURLSessionDownloadTask *getAudioTask =
    [session downloadTaskWithURL:audioUrl
     
               completionHandler:^(NSURL *location,
                                   NSURLResponse *response,
                                   NSError *error) {
                   // 4
                   NSData *downloadedAudio =
                   [NSData dataWithContentsOfURL:location];
                   
                   //5
                   dispatch_async(dispatch_get_main_queue(), ^{
                       // do stuff with audio
                       
                   });
               }];
    
    // 6
    [getAudioTask resume];
}


-(void)pushRecordController
{
    //Move to the record view (adds an additional layer to the hamburger nav)
    RecordSoundsViewController *recordVC = [[RecordSoundsViewController alloc] init];
	[self.navigationController pushViewController:recordVC animated:YES];
}


-(void)dealloc
{
    self.partySoundsTable = nil;
}

@end
