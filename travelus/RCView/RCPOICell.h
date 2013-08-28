//
//  RCPOICell.h
//  travelus
//
//  Created by Hsueh Cheng Chen on 13/8/28.
//  Copyright (c) 2013年 Grant Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCPOICell : UITableViewCell
+ (RCPOICell *)cell;
@property (nonatomic, strong)IBOutlet UILabel *titleLabel;
@property (nonatomic, strong)IBOutlet UILabel *distanceLabel;
@property (nonatomic, strong)IBOutlet UILabel *meterLabel;
@end
