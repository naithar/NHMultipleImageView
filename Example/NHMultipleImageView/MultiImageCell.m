//
//  MultiImageCell.m
//  NHMultipleImageView
//
//  Created by Naithar on 01.05.15.
//  Copyright (c) 2015 Naithar. All rights reserved.
//

#import "MultiImageCell.h"

@implementation MultiImageCell

- (void)awakeFromNib {
    // Initialization code

    [self.multiImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.multiImageView.imageCount = 1;
    self.multiImageView.contentInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    self.multiImageView.imageInsets = UIEdgeInsetsMake(0, 0, 5, 5);

    [self.multiImageView addImage:[UIImage imageNamed:@"img6"] toIndex:0];

    [self.multiImageView addImage:[NSNull null] toIndex:1];
    //
    [self.multiImageView addImage:[UIImage imageNamed:@"img6"] toIndex:2];
    [self.multiImageView addImage:[UIImage imageNamed:@"img6"] toIndex:3];
    [self.multiImageView addImage:[UIImage imageNamed:@"img6"] toIndex:4];
    [self.multiImageView addImage:[UIImage imageNamed:@"img6"] toIndex:5];
    [self.multiImageView addImage:[UIImage imageNamed:@"img6"] toIndex:6];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 5), dispatch_get_main_queue(), ^{
        [self.multiImageView addImage:[UIImage imageNamed:@"img2"] toIndex:1];
    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
