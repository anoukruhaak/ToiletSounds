//
//  RecordSoundsViewController.m
//  ToilerSounds
//
//  Created by Anouk Ruhaak on 6/8/14.
//  Copyright (c) 2014 Djipsy. All rights reserved.
//

#import "RecordSoundsViewController.h"
#import "SWRevealViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Sound.h"
#import "SoundStore.h"
#import "MySoundsViewController.h"

@interface RecordSoundsViewController () <UIAlertViewDelegate, AVAudioRecorderDelegate>
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) AVAudioRecorder *soundRecorder;
@property (nonatomic, strong) AVAudioPlayer *soundPlayer;
@property (nonatomic, strong) Sound *mySound;
@property (nonatomic, strong) UIButton *saveButton;


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
    [self.recordButton addTarget:self action:@selector(recordButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.title = NSLocalizedString(@"Record", nil);
    
    //Cancel
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Not Now" style:UIBarButtonItemStylePlain target:self action:@selector(cancelRecording)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    //Save
    self.saveButton = [[UIButton alloc]initWithFrame:CGRectMake(320-80.0, 420, 60, 30)];
    self.saveButton.layer.cornerRadius = 4.0;
    [self.saveButton setTitle:@"Done" forState:UIControlStateNormal];
    self.saveButton.titleLabel.textColor = [UIColor blackColor];
    [self.saveButton addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveButton];
    
    //Start an audio session to get recording to work (ios weirdness)
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    
    [[SoundStore sharedStore]saveChanges];
}

#pragma mark - Helper
-(void)createRecorder
{
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"sound.caf"];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMedium],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    
    self.soundRecorder = [[AVAudioRecorder alloc]
                          initWithURL:soundFileURL
                          settings:recordSettings
                          error:&error];
    
    self.soundRecorder.delegate = self;
    
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
        
    } else {
        [self.soundRecorder prepareToRecord];
    }
    
}

#pragma mark - UIButton presses

-(void)saveButtonPressed
{
    //Create popup asking for a name.
    UIAlertView *nameAlert = [[UIAlertView alloc]initWithTitle:@"Save" message:@"Give your sound a name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    //Add a textfield
    nameAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    //set delegate
    nameAlert.delegate = self;
    
    [nameAlert show];
    
}

-(void)cancelRecording
{
    if (self.mySound) {
        [[SoundStore sharedStore]removeSound:self.mySound];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)recordButtonPressed
{
    if (self.soundRecorder.isRecording) {
        NSLog(@"Stop recording");
        
        //Stop recording
        [self.soundRecorder stop];
        
    }else{
        [self createRecorder];
        NSLog(@"%@", self.soundRecorder);
        [_soundRecorder recordForDuration:6.0];
        NSLog(@"started recording? : %i", self.soundRecorder.isRecording);
    }
}


#pragma mark - Text Field delegate

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

#pragma mark - AlertView delegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.mySound.soundName = [alertView textFieldAtIndex:0].text;
    
    if ([self.navigationController.parentViewController isMemberOfClass:[MySoundsViewController class]]) {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }else{
        //Create new nav:
        MySoundsViewController *soundVC = [MySoundsViewController new];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:soundVC];
        SWRevealViewController *rev = (SWRevealViewController *)self.navigationController.parentViewController;
        [rev pushFrontViewController:nav animated:NO];
    }

}

#pragma mark - audio recorder delegate
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (flag) {
        
        //Create the sound and store the audio
        self.mySound = [[SoundStore sharedStore]createNewSound];
        self.mySound.dateCreated = [NSDate new];
        self.mySound.soundData =[NSData dataWithContentsOfURL:self.soundRecorder.url];
        self.mySound.soundName = @"New Sound";


        //create player and play sound
        NSError *error;
        
        self.soundPlayer = [[AVAudioPlayer alloc]
                            initWithData:self.mySound.soundData error:&error];
        
        if (error)
        {
            NSLog(@"Error: %@",
                  [error localizedDescription]);
        }
        else{
            [self.soundPlayer play];
        }

    }else{
        NSLog(@"Error");
    }
}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.recordButton = nil;
}


@end
