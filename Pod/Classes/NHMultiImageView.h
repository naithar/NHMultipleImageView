//
//  NHMultiImageView.h
//  Pods
//
//  Created by Naithar on 01.05.15.
//
//

#import <UIKit/UIKit.h>

@interface NHMultiImageView : UIView

@property (nonatomic, assign) NSUInteger imageCount;
@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, assign) UIEdgeInsets imageInsets;
@property (nonatomic, strong) UIColor *imageBackgroundColor;

- (void)addImage:(UIImage *)image;
- (void)addImage:(UIImage*)image toIndex:(NSInteger)index;

@end
