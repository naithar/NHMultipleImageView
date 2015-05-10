//
//  MultiImageCell.m
//  NHMultipleImageView
//
//  Created by Naithar on 01.05.15.
//  Copyright (c) 2015 Naithar. All rights reserved.
//

#import "MultiImageCell.h"

@interface MultiImageCell ()<NHMultiImageViewDelegate>

@end

@implementation MultiImageCell

- (void)multiImageView:(NHMultiImageView *)view didSelectIndex:(NSInteger)index {
    NSLog(@"selected = %d", index);
}

- (void)awakeFromNib {
    // Initialization code

    [self.multiImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.multiImageView.cornerRadius = 10;
    self.multiImageView.backgroundColor = [UIColor whiteColor];
    self.multiImageView.contentInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    self.multiImageView.imageInsets = UIEdgeInsetsMake(0, 0, 5, 5);

    [self.multiImageView setImageArraySize:5];
//    self.multiImageView.maxImageCount = 3;
    [self.multiImageView addImage:[UIImage imageNamed:@"img2"] toIndex:0];

    [self.multiImageView addImage:[NSNull null] toIndex:1];
    self.multiImageView.delegate = self;
    self.multiImageView.selectionColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    //

    [self.multiImageView addImage:[UIImage imageNamed:@"img3.jpg"] toIndex:2];

    NSString *path = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:nil].firstObject;
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    [self.multiImageView addImage:image toIndex:3];

//    NSString *path = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:nil].firstObject;
    UIImage *image1 = [UIImage imageWithContentsOfFile:path];
    [self.multiImageView addImage:image1 toIndex:4];


    self.multiImageView.textContainerBorderWidth = 5;
    self.multiImageView.textFont = [UIFont boldSystemFontOfSize:20];


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 5), dispatch_get_main_queue(), ^{
        [self.multiImageView addImage:[UIImage imageNamed:@"img1"] toIndex:1];
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
