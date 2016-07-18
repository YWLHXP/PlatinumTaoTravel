//
//  XPHotalScrollTableViewCell.m
//  PlatinumTT
//
//  Created by 罗惠 on 16/7/14.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPHotalScrollTableViewCell.h"

@implementation XPHotalScrollTableViewCell

- (void)awakeFromNib {

}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        [self addSubview:self.scrollView];
    }
    return self;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
