//
//  RCPOICell.m
//  travelus
//
//  Created by Hsueh Cheng Chen on 13/8/28.
//  Copyright (c) 2013年 Grant Chen. All rights reserved.
//

#import "RCPOICell.h"

@implementation RCPOICell

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
+ (RCPOICell *)cell {
    return [[[NSBundle mainBundle] loadNibNamed:@"RCPOICell" owner:self options:nil] objectAtIndex:0];
}
@end
