//
//  SoundStore.h
//  ToilerSounds
//
//  Created by Anouk Ruhaak on 6/9/14.
//  Copyright (c) 2014 Djipsy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Sound;

@interface SoundStore : NSObject
{
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
    NSMutableArray *allSounds;
    
}

+ (SoundStore *)sharedStore;

- (NSString *)itemArchivePath;

- (BOOL)saveChanges;
- (Sound *)createNewSound;
- (NSArray *)allSounds;
- (void)removeSound:(Sound *)sound;


@end
