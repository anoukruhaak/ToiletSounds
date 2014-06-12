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

@interface RecordSoundsViewController () <UITextFieldDelegate, AVAudioRecorderDelegate>
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UITextField *soundName;
@property (nonatomic, strong) AVAudioRecorder *soundRecorder;
@property (nonatomic, strong) AVAudioPlayer *soundPlayer;
@property (nonatomic, strong) Sound *mySound;

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
    
    self.soundName = [[UITextField alloc]initWithFrame:CGRectMake(20, 120, 280, 55)];
    self.soundName.layer.cornerRadius = 4;
    self.soundName.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.soundName.layer.borderWidth = 2.0;
    self.soundName.backgroundColor = [UIColor whiteColor];
    self.soundName.placeholder = @"Name your sound";
    self.soundName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_soundName];
    self.soundName.enabled = NO;
    self.soundName.delegate = self;

    
    self.title = NSLocalizedString(@"Record", nil);
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Not Now" style:UIBarButtonItemStylePlain target:self action:@selector(cancelRecording)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
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

-(void)saveSound
{
    
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [[self view] endEditing:YES];

     self.mySound.soundName = textField.text;
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
        
        //now make it possible to edit the name
        self.soundName.enabled = YES;

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
    self.soundName = nil;
}


@end
