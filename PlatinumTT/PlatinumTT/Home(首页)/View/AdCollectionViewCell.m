//
//  AdCollectionViewCell.m
//  PlatinumTT
//
//  Created by tarena on 16/7/13.
//  Copyright © 2016年 win. All rights reserved.
//

#import "AdCollectionViewCell.h"

@implementation AdCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    self.imageView.frame = CGRectMake(0, 0, layoutAttributes.size.width, layoutAttributes.size.height);
}

@end
