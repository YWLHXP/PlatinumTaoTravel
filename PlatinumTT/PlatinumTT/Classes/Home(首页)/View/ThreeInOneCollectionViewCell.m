//
//  ThreeInOneCollectionViewCell.m
//  PlatinumTT
//
//  Created by tarena on 16/7/14.
//  Copyright © 2016年 win. All rights reserved.
//

#import "ThreeInOneCollectionViewCell.h"

@implementation ThreeInOneCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc]init];
        self.imageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.imageView];
        
        self.tLabel = [[UILabel alloc]init];
        self.tLabel.textAlignment = NSTextAlignmentCenter;
        self.tLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.tLabel];
        
        self.dLabel = [[UILabel alloc]init];
        self.dLabel.textAlignment = NSTextAlignmentCenter;
        self.dLabel.textColor = [UIColor grayColor];
        self.dLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.dLabel];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    self.tLabel.frame = CGRectMake(0, 25, layoutAttributes.size.width, 18);
    self.dLabel.frame = CGRectMake(0, self.tLabel.frame.origin.y+18+5, layoutAttributes.size.width, 25);
    self.imageView.frame = CGRectMake(0, self.dLabel.frame.origin.y+25+5, layoutAttributes.size.width, 50);
}

@end
