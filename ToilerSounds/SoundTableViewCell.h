//
//  SoundTableViewCell.h
//  ToilerSounds
//
//  Created by Anouk Ruhaak on 6/9/14.
//  Copyright (c) 2014 Djipsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoundTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UIButton *sendSound;
@property (nonatomic, strong) UIButton *playSound;
@property (nonatomic, strong) UILabel *recordedAt;
@property (nonatomic, strong) UILabel *dividerLineView;
@end
