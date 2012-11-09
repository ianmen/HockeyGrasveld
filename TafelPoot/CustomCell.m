//
//  CustomCell.m
//  TafelPoot
//
//  Created by Jochem Rommens on 08-11-12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

@synthesize NameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
