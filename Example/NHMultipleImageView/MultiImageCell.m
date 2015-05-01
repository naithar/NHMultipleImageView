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
    self.multiImageView.cornerRadius = 10;
    self.multiImageView.contentInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    self.multiImageView.imageInsets = UIEdgeInsetsMake(0, 0, 5, 5);

    [self.multiImageView addImage:[UIImage imageNamed:@"img1"] toIndex:0];

    [self.multiImageView addImage:[NSNull null] toIndex:1];
    //
    [self.multiImageView addImage:[UIImage imageNamed:@"img2"] toIndex:2];
    [self.multiImageView addImage:[UIImage imageNamed:@"img1"] toIndex:3];
    [self.multiImageView addImage:[UIImage imageNamed:@"img2"] toIndex:4];
    [self.multiImageView addImage:[UIImage imageNamed:@"img1"] toIndex:5];
    [self.multiImageView addImage:[UIImage imageNamed:@"img2"] toIndex:6];
    [self.multiImageView addImage:[UIImage imageNamed:@"img2"] toIndex:7];
    [self.multiImageView addImage:[UIImage imageNamed:@"img2"] toIndex:8];
    [self.multiImageView addImage:[UIImage imageNamed:@"img2"] toIndex:9];
    [self.multiImageView addImage:[UIImage imageNamed:@"img2"] toIndex:10];
    [self.multiImageView addImage:[UIImage imageNamed:@"img2"] toIndex:11];
    [self.multiImageView addImage:[UIImage imageNamed:@"img2"] toIndex:12];


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 5), dispatch_get_main_queue(), ^{
        [self.multiImageView addImage:[UIImage imageNamed:@"img1"] toIndex:1];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 5), dispatch_get_main_queue(), ^{
//            self.multiImageView.backgroundColor = [UIColor redColor];
//            [self.multiImageView setNeedsDisplay];
//        });
    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    self.multiImageView.backgroundColor = nil;
    [super setSelected:selected animated:animated];
//self.multiImageView.backgroundColor = nil;
    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//    self.multiImageView.backgroundColor = nil;
    [super setHighlighted:highlighted animated:animated];
//    self.multiImageView.backgroundColor = nil;
}

@end
