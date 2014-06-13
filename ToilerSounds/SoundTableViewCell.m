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
    self.name = [[UILabel alloc]initWithFrame:CGRectMake(12.0, 12.0, 252.0, 24.0)];
    [self.contentView addSubview:_name];
    
    self.recordedAt = [[UILabel alloc]initWithFrame:CGRectMake(12.0, 37.0, 238.0, 18.0)];
    [self.contentView addSubview:_recordedAt];
    
    self.playSound = [[UIButton alloc]initWithFrame:CGRectMake(200.0, 19.0, 30, 30)];
    [self.contentView addSubview:_playSound];
    
    self.sendSound = [[UIButton alloc]initWithFrame:CGRectMake(240.0, 19.0, 60, 30)];
    [self.contentView addSubview:_sendSound];
    
    self.dividerLineView = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 68.5, 320.0, 0.5)];
    [self.contentView addSubview:_dividerLineView];


}


-(void)layoutSubviews
{
    [super layoutSubviews];
    // Cell margin
    //self.contentView.frame = CGRectMake(10, 10, self.frame.size.width -20, self.frame.size.height -10);
    
    // Cell content background
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    //Cell background
    self.backgroundColor = kBackgroundColor;
    //Set Name Label
    self.name.font = [UIFont fontWithName:@"Helvetica" size:19.0];
    self.name.textColor = [UIColor blackColor];
    self.name.textAlignment = NSTextAlignmentLeft;
    self.name.numberOfLines = 1;
    
    //Set label for datestring
    self.recordedAt.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    self.recordedAt.textColor = [UIColor blackColor];
    self.recordedAt.textAlignment = NSTextAlignmentLeft;
    
    //Set playerButton icon
    [self.playSound setImage:[UIImage imageNamed:@"button-play"] forState:UIControlStateNormal];
    [self.playSound setImage:[UIImage imageNamed:@"button-play_pressing"] forState:UIControlStateHighlighted];
    [self.playSound setImage:[UIImage imageNamed:@"button-play_pressed"] forState:UIControlStateDisabled];
    
    //Set Button for sending
    [self.sendSound setTitle:@"Send" forState:UIControlStateNormal];
    [self.sendSound.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    [self.sendSound setTitleColor:[UIColor colorWithRed:179.0/255.0 green:73.0/255.0 blue:242.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.sendSound.backgroundColor = [UIColor whiteColor];
    self.sendSound.layer.cornerRadius = 3;
    self.sendSound.layer.borderColor = kNavigationColor2;
    self.sendSound.layer.borderWidth =1.0;
    
    // Divider line style
    self.dividerLineView.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.15f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
