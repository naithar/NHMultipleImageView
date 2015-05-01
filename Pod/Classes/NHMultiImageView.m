//
//  NHMultiImageView.m
//  Pods
//
//  Created by Naithar on 01.05.15.
//
//

#import "NHMultiImageView.h"

@interface  NHMultiImageView ()

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSArray *pattern;
@end

@implementation NHMultiImageView

- (instancetype)init {
    self = [super init];

    if (self) {
        [self commonInit];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];

    if (self) {
        [self commonInit];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _contentInsets = UIEdgeInsetsZero;
    _imageInsets = UIEdgeInsetsZero;
    _imageArray = [[NSMutableArray alloc] initWithCapacity:10];

    _pattern = @[
                 @[@{
                     @"origin" : [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                     @"size" : [NSValue valueWithCGSize:CGSizeMake(1, 1)]
                    }], //1
                 @[@{
                       @"origin" : [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                       @"size" : [NSValue valueWithCGSize:CGSizeMake(0.5, 1)]
                       },
                   @{
                       @"origin" : [NSValue valueWithCGPoint:CGPointMake(0.5, 0)],
                       @"size" : [NSValue valueWithCGSize:CGSizeMake(0.5, 1)]
                       }], //2
                 @[@{
                       @"origin" : [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                       @"size" : [NSValue valueWithCGSize:CGSizeMake(0.5, 1)]
                       },
                   @{
                       @"origin" : [NSValue valueWithCGPoint:CGPointMake(0.5, 0)],
                       @"size" : [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)]
                       },
                   @{
                       @"origin" : [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)],
                       @"size" : [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)]
                       }], //3
                 @[@{
                       @"origin" : [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                       @"size" : [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)]
                       },
                   @{
                       @"origin" : [NSValue valueWithCGPoint:CGPointMake(0, 0.5)],
                       @"size" : [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)]
                       },
                   @{
                       @"origin" : [NSValue valueWithCGPoint:CGPointMake(0.5, 0)],
                       @"size" : [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)]
                       },
                   @{
                       @"origin" : [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)],
                       @"size" : [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)]
                       }], //4
                 @[@{
                       @"origin" : [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                       @"size" : [NSValue valueWithCGSize:CGSizeMake(0.5, 1)]
                       },
                   @{
                       @"origin" : [NSValue valueWithCGPoint:CGPointMake(0.5, 0)],
                       @"size" : [NSValue valueWithCGSize:CGSizeMake(0.5, 0.25)]
                       },
                   @{
                       @"origin" : [NSValue valueWithCGPoint:CGPointMake(0.5, 0.25)],
                       @"size" : [NSValue valueWithCGSize:CGSizeMake(0.5, 0.25)]
                       },
                   @{
                       @"origin" : [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)],
                       @"size" : [NSValue valueWithCGSize:CGSizeMake(0.5, 0.25)]
                       },
                   @{
                       @"origin" : [NSValue valueWithCGPoint:CGPointMake(0.5, 0.75)],
                       @"size" : [NSValue valueWithCGSize:CGSizeMake(0.5, 0.25)]
                       }], //5
                 @[@{
                       @"origin" : [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                       @"size" : [NSValue valueWithCGSize:CGSizeMake(0.5, 1)]
                       },
                   @{
                       @"origin" : [NSValue valueWithCGPoint:CGPointMake(0.5, 0)],
                       @"size" : [NSValue valueWithCGSize:CGSizeMake(0.5, 0.25)]
                       },
                   @{
                       @"origin" : [NSValue valueWithCGPoint:CGPointMake(0.5, 0.25)],
                       @"size" : [NSValue valueWithCGSize:CGSizeMake(0.5, 0.25)]
                       },
                   @{
                       @"origin" : [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)],
                       @"size" : [NSValue valueWithCGSize:CGSizeMake(0.5, 0.25)]
                       },
                   @{
                       @"origin" : [NSValue valueWithCGPoint:CGPointMake(0.5, 0.75)],
                       @"size" : [NSValue valueWithCGSize:CGSizeMake(0.25, 0.25)]
                       },
                   @{
                       @"origin" : [NSValue valueWithCGPoint:CGPointMake(0.75, 0.75)],
                       @"size" : [NSValue valueWithCGSize:CGSizeMake(0.25, 0.25)]
                       }], //6
                 ];

    self.opaque = YES;
    self.clipsToBounds = YES;

}

- (void)addImage:(UIImage *)image {
    [self.imageArray addObject:image];
    [self setNeedsDisplay];
}

- (void)addImage:(UIImage*)image
         toIndex:(NSInteger)index {
    if (index > self.imageArray.count) {
        return;
    }

    self.imageArray[index] = image;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {

    [self.backgroundColor set];
    UIRectFill(rect);

    CGRect contentRect = UIEdgeInsetsInsetRect(rect, self.contentInsets);

    if (self.imageArray.count > 0 && self.imageArray.count <= 6) {
        NSArray *currentPattern = self.pattern[self.imageArray.count - 1];

        [currentPattern enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {

            if (!self.imageArray[idx]
                || [self.imageArray[idx] isKindOfClass:[NSNull class]]) {
                return;
            }
            CGPoint patternOrigin = [obj[@"origin"] CGPointValue];
            CGSize patternSize = [obj[@"size"] CGSizeValue];

            CGRect imageRect = CGRectMake(self.contentInsets.left + patternOrigin.x * contentRect.size.width + self.imageInsets.left,
                                          self.contentInsets.top + patternOrigin.y * contentRect.size.height + self.imageInsets.top,
                                          patternSize.width * contentRect.size.width - self.imageInsets.left - self.imageInsets.right,
                                          patternSize.height * contentRect.size.height - self.imageInsets.top - self.imageInsets.bottom);

            [[self prepareImage:self.imageArray[idx] forSize:imageRect.size useConrners:self.imageArray.count > 1] drawInRect:imageRect];
        }];
        
    }
    else if (self.imageArray.count > 6) {
        NSArray *currentPattern = self.pattern[5];

        [currentPattern enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            if (!self.imageArray[idx]
                || [self.imageArray[idx] isKindOfClass:[NSNull class]]) {
                return;
            }

            CGPoint patternOrigin = [obj[@"origin"] CGPointValue];
            CGSize patternSize = [obj[@"size"] CGSizeValue];

            CGRect imageRect = CGRectMake(self.contentInsets.left + patternOrigin.x * contentRect.size.width + self.imageInsets.left,
                                          self.contentInsets.top + patternOrigin.y * contentRect.size.height + self.imageInsets.top,
                                          patternSize.width * contentRect.size.width - self.imageInsets.left - self.imageInsets.right,
                                          patternSize.height * contentRect.size.height - self.imageInsets.top - self.imageInsets.bottom);
            if (idx == 5) {
                [[UIBezierPath bezierPathWithRoundedRect:imageRect
                                            cornerRadius:5.0] addClip];
                [[UIColor redColor] set];
                UIRectFill(imageRect);

                [[@(self.imageArray.count - 5) stringValue] drawInRect:imageRect withAttributes:@{
                                                                                                  NSFontAttributeName : [UIFont systemFontOfSize:12],
                                                                                                  NSForegroundColorAttributeName: [UIColor greenColor]
                                                                                                  }];
            }
            else {
            [[self prepareImage:self.imageArray[idx] forSize:imageRect.size useConrners:self.imageArray.count > 1] drawInRect:imageRect];
            }

        }];
    }

}

- (UIImage*)prepareImage:(UIImage*)image forSize:(CGSize)size useConrners:(BOOL)conrners {


//            UIImage *resultImage = [[[self class] shakersCache] objectForKey:cacheKey];

//            if (resultImage == nil) {


                UIGraphicsBeginImageContextWithOptions(size, YES, 0);

                CGContextRef context = UIGraphicsGetCurrentContext();
        
                //        [[UIColor clearColor] set];
        
                CGContextClearRect(context, (CGRect) { .origin.x = 0, .origin.y = 0, .size = size });
                CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 1);
        
                CGContextFillRect(context, (CGRect) { .origin.x = 0, .origin.y = 0, .size = size });
        
                CGFloat value = image.size.width / image.size.height;

//    CGFloat dif = fmin(((CGFloat)size.height / (CGFloat)image.size.height), ((CGFloat)size.width / (CGFloat)image.size.width));

    CGFloat height = size.height;
    CGFloat width = size.width;
                CGFloat x = 0;
                CGFloat y = 0;


                if (value < 1) {


                    CGFloat value2 = size.width / size.height;

                    if (value2 > 1) {

                        height /= value;
                        y -= (height - size.height) / 2;

                        height *= value2;
                        y -= height / 4;
                    }
                    else if (value2 < 1) {

//                                                height /= value;
                        //                        y -= (height - size.height) / 2;
                        //
//                                                width /= value;
                        //                        x -= width / 4;
                    }
                    else {
                        height /= value;
                        y -= (height - size.height) / 2;
                    }
                }
                else {


                    CGFloat value2 = size.width / size.height;

                    if (value2 > 1) {

//                        width *= value;
//                        x -= (width - size.width) / 2;

//                        height *= value2;
//                        y -= height / 4;
                    }
                    else if (value2 < 1) {

                        width *= value;
                        x -= (width - size.width) / 2;

                        width /= value2;
                        x -= width / 4;
                    }
                    else {
                        width *= value;
                        x -= (width - size.width) / 2;
                    }
                }

    



    if (conrners) {
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, floor(size.width), floor(size.height))
                                cornerRadius:5.0] addClip];
    }
                [image drawInRect:CGRectMake(x, y, floor(width), floor(height))];
        
                UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
        
//                [[[self class] shakersCache] setObject:resultImage forKey:cacheKey];

                UIGraphicsEndImageContext();
//            }

//    self

            return resultImage;
}

@end

//
//+ (UIImage*)avatarPlaceholderImage {
//    static dispatch_once_t token;
//    __strong static UIImage* instance = nil;
//    dispatch_once(&token, ^{
//        UIImage *image = [UIImage imageNamed:@"avatar.placeholder"];
//        UIGraphicsBeginImageContextWithOptions((CGSize) { .width = 35, .height = 35 }, NO, 0);
//
//        CGContextRef context = UIGraphicsGetCurrentContext();
//
//        //        [[UIColor clearColor] set];
//
//        CGContextClearRect(context, (CGRect) { .origin.x = 0, .origin.y = 0, .size.width = 35, .size.height = 35 });
//        CGContextSetRGBFillColor(context, 1, 1, 1, 0.25);
//
//        CGContextFillRect(context, (CGRect) { .origin.x = 0, .origin.y = 0, .size.width = 35, .size.height = 35 });
//
//        CGFloat value = image.size.width / image.size.height;
//
//        CGFloat height = 35;
//        CGFloat width = 35;
//        CGFloat x = 0;
//        CGFloat y = 0;
//
//        if (value < 1) {
//            height /= value;
//            y -= (height - 35) / 2;
//        }
//        else {
//            width *= value;
//            x -= (width - 35) / 2;
//        }
//
//
//        CGFloat radius = 17.5;
//
//        CGContextBeginPath(context);
//        CGContextAddArc(context, 17.5, 17.5, radius, 0, 10, 0);
//        CGContextClosePath(context);
//        CGContextClip(context);
//
//        [image drawInRect:CGRectMake(x, y, width, height)];
//
//        instance = UIGraphicsGetImageFromCurrentImageContext();
//
//        UIGraphicsEndImageContext();
//    });
//
//    return instance;
//}
//
//- (UIImage*)imageForShaker:(UIImage*)image cacheKey:(NSString*)cacheKey {
//
//    if (image == nil) {
//        return [[self class] avatarPlaceholderImage];
//    }
//
//    //    UIImage *avatarImage = image ?: [UIImage imageNamed:@"avatar.placeholder"];
//
//    UIImage *resultImage = [[[self class] shakersCache] objectForKey:cacheKey];
//
//    if (resultImage == nil) {
//        UIGraphicsBeginImageContextWithOptions((CGSize) { .width = 35, .height = 35 }, NO, 0);
//
//        CGContextRef context = UIGraphicsGetCurrentContext();
//
//        //        [[UIColor clearColor] set];
//
//        CGContextClearRect(context, (CGRect) { .origin.x = 0, .origin.y = 0, .size.width = 35, .size.height = 35 });
//        CGContextSetRGBFillColor(context, 1, 1, 1, 0.25);
//
//        CGContextFillRect(context, (CGRect) { .origin.x = 0, .origin.y = 0, .size.width = 35, .size.height = 35 });
//
//        CGFloat value = image.size.width / image.size.height;
//
//        CGFloat height = 35;
//        CGFloat width = 35;
//        CGFloat x = 0;
//        CGFloat y = 0;
//
//        if (value < 1) {
//            height /= value;
//            y -= (height - 35) / 2;
//        }
//        else {
//            width *= value;
//            x -= (width - 35) / 2;
//        }
//
//
//        CGFloat radius = 17.5;
//
//        CGContextBeginPath(context);
//        CGContextAddArc(context, 17.5, 17.5, radius, 0, 10, 0);
//        CGContextClosePath(context);
//        CGContextClip(context);
//
//        [image drawInRect:CGRectMake(x, y, width, height)];
//
//        resultImage = UIGraphicsGetImageFromCurrentImageContext();
//
//        [[[self class] shakersCache] setObject:resultImage forKey:cacheKey];
//
//        UIGraphicsEndImageContext();
//    }
//
//    return resultImage;
//}
//
//-(void)drawShakeImage:(UIImage*)image atIndex:(NSInteger)index forKey:(NSString*)cacheKey {
//
//    UIGraphicsBeginImageContextWithOptions(self.shakersImage.size, NO, 0);
//
//    [self.shakersImage drawAtPoint:CGPointMake(0, 0)];
//
//    [image drawAtPoint:CGPointMake(42.5*index, 0)];
//    
//    self.shakersImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    [[[self class] shakersCache] setObject:self.shakersImage forKey:cacheKey];
//    
//    UIGraphicsEndImageContext();
//}
