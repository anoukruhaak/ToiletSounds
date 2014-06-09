//
//  Sound.h
//  ToilerSounds
//
//  Created by Anouk Ruhaak on 6/9/14.
//  Copyright (c) 2014 Djipsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Sound : NSManagedObject

@property (nonatomic, retain) NSString * soundName;
@property (nonatomic, retain) NSData * soundData;
@property (nonatomic, retain) NSDate * dateCreated;

@end
