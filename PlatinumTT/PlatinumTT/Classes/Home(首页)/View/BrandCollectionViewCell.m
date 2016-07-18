//
//  BrandCollectionViewCell.m
//  PlatinumTT
//
//  Created by tarena on 16/7/15.
//  Copyright © 2016年 win. All rights reserved.
//

#import "BrandCollectionViewCell.h"

@implementation BrandCollectionViewCell

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
