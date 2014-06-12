//
//  SoundStore.m
//  ToilerSounds
//
//  Created by Anouk Ruhaak on 6/9/14.
//  Copyright (c) 2014 Djipsy. All rights reserved.
//

#import "SoundStore.h"
#import "Sound.h"

@implementation SoundStore

+ (SoundStore *)sharedStore
{
    static SoundStore *sharedStore = nil;
    if(!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

- (id)init
{
    self = [super init];
    if(self) {
        
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        
        NSPersistentStoreCoordinator *psc =
        [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSLog(@"%@",[storeURL path]);
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            [NSException raise:@"Open failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        // Create the managed object context
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:psc];
        context.undoManager = [[NSUndoManager alloc]init];
        
        [self loadAllSounds];
        
        for (Sound *s in allSounds) {
            NSLog(@"Date created: %@, and name:%@", s.dateCreated, s.soundName);
        }
        
        
    }
    return self;
}

-(void)startUndoManager
{
    [context.undoManager beginUndoGrouping];
}

-(void)undoChanges
{
    [context.undoManager endUndoGrouping];
    [context.undoManager undoNestedGroup];
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    
    // Get one and only document directory from that list
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveChanges
{
    NSError *err = nil;
    BOOL successful = [context save:&err];
    if (!successful) {
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    return successful;
}

#pragma mark: Creating and Storing Sounds

- (void)removeSound:(Sound *)sound
{
    [context deleteObject:sound];
    [allSounds removeObject:sound];
    
    [[SoundStore sharedStore]saveChanges];
}

- (Sound *)createNewSound
{
    Sound *mySound = [NSEntityDescription insertNewObjectForEntityForName:@"Sound"
                                               inManagedObjectContext:context];
    
    mySound.soundName = [NSString stringWithFormat:@"My Sound %lu", (allSounds.count +1)];
    
    [allSounds insertObject:mySound atIndex:0];
    [[SoundStore sharedStore]saveChanges];
    
    return mySound;
}

#pragma mark - Loading sounds

-(NSArray *)allSounds
{
    if (!allSounds) {
        [self loadAllSounds];
    }
    
    return allSounds;
}

-(void)loadAllSounds
{
    if (!allSounds) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [[model entitiesByName]
                                  objectForKey:@"Sound"];
        
        [request setEntity:e];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateCreated"
                                                                       ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];

        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        allSounds = [[NSMutableArray alloc]initWithArray:result];
    }

}

@end
