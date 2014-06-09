//
//  SoundRecorder.m
//  ToilerSounds
//
//  Created by Anouk Ruhaak on 6/9/14.
//  Copyright (c) 2014 Djipsy. All rights reserved.
//

#import "SoundRecorderPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface SoundRecorderPlayer () <AVAudioPlayerDelegate, AVAudioRecorderDelegate>
{
    AVAudioRecorder *soundRecorder;
    AVAudioPlayer *soundPlayer;
}

@end

@implementation SoundRecorderPlayer

-(id)init
{
    self =[super init];
    
    if (self) {
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
        
        soundRecorder = [[AVAudioRecorder alloc]
                           initWithURL:soundFileURL
                           settings:recordSettings
                           error:&error];
        
        if (error)
        {
            NSLog(@"error: %@", [error localizedDescription]);
            
        } else {
            [soundRecorder prepareToRecord];
        }

    }
    
    return self;
}

-(void)startRecording
{
    [soundRecorder record];
}

-(void)stopRecording
{
    if (soundRecorder.recording)
    {
        [soundRecorder stop];
    } else if (soundPlayer.playing) {
        [soundPlayer stop];
    }

}

-(void)playAudio
{
    if (!soundRecorder.recording)
    {
         NSError *error;
        
        if (soundPlayer){
        
        soundPlayer = [[AVAudioPlayer alloc]
                       initWithContentsOfURL:soundRecorder.url
                       error:&error];
        
        soundPlayer.delegate = self;
        }
        if (error){
            NSLog(@"Error: %@",
                  [error localizedDescription]);
        }
        else{
            [soundPlayer play];
        }
    }
}

@end
