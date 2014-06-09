//
//  SoundTableViewCell.m
//  ToilerSounds
//
//  Created by Anouk Ruhaak on 6/9/14.
//  Copyright (c) 2014 Djipsy. All rights reserved.
//

#import "SoundTableViewCell.h"

@implementation SoundTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ( !(self = [super initWithCoder:aDecoder]) ) return nil;
    
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.name = [[UILabel alloc]initWithFrame:CGRectMake(29.0, 12.0, 242.0, 24.0)];
    [self.contentView addSubview:_name];
    
    self.recordedAt = [[UILabel alloc]initWithFrame:CGRectMake(36.0, 37.0, 228.0, 18.0)];
    [self.contentView addSubview:_recordedAt];
    
    self.dividerLineView = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 66.0, 280.0, 0.5)];
    [self.contentView addSubview:_dividerLineView];
    
    self.playSound = [[UIButton alloc]initWithFrame:CGRectMake(10.0, 71.0, 30, 30)];
    [self.contentView addSubview:_playSound];
    
    self.sendSound = [[UIButton alloc]initWithFrame:CGRectMake(230.0, 71.0, 60, 30)];
    [self.contentView addSubview:_sendSound];

}


-(void)layoutSubviews
{
    [super layoutSubviews];
    // Cell margin
    self.contentView.frame = CGRectMake(10, 0, self.frame.size.width -20, self.frame.size.height -10);
    
    // Cell content background
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    //Cell background
    self.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0];
    
    //Set Name Label
    self.name.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    self.name.textColor = [UIColor blackColor];
    self.name.textAlignment = NSTextAlignmentCenter;
    self.name.numberOfLines = 1;
    
    //Set label for datestring
    self.recordedAt.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    self.recordedAt.textColor = [UIColor blackColor];
    self.recordedAt.textAlignment = NSTextAlignmentCenter;
    
    //Set playerButton icon
    [self.playSound setImage:[UIImage imageNamed:@"button-play"] forState:UIControlStateNormal];
    [self.playSound setImage:[UIImage imageNamed:@"button-play_pressing"] forState:UIControlStateHighlighted];
    [self.playSound setImage:[UIImage imageNamed:@"button-play_pressed"] forState:UIControlStateDisabled];
    
    //Set Button for sending
    [self.sendSound setTitle:@"Send" forState:UIControlStateNormal];
    [self.sendSound.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    self.sendSound.backgroundColor = [UIColor colorWithRed:94.0/255.0 green:64.0/255.0 blue:194.0/255.0 alpha:0.7];
    self.sendSound.layer.cornerRadius = 4;
    
    // Divider line style
    self.dividerLineView.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.15f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
