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

+ (NSArray*)defaultPattern {
    static dispatch_once_t token;
    __strong static NSArray* instance = nil;
    dispatch_once(&token, ^{

    instance = @[
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

    });

    return instance;
}

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
    _imageArray = [[NSMutableArray alloc] init];
    _pattern = [[self class] defaultPattern];

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

- (CGRect)rectFromPattern:(NSDictionary*)pattern andContentRect:(CGRect)contentRect {
    CGPoint patternOrigin = [pattern[@"origin"] CGPointValue];
    CGSize patternSize = [pattern[@"size"] CGSizeValue];

    CGRect imageRect = CGRectMake(self.contentInsets.left + patternOrigin.x * contentRect.size.width + self.imageInsets.left,
                                  self.contentInsets.top + patternOrigin.y * contentRect.size.height + self.imageInsets.top,
                                  patternSize.width * contentRect.size.width - self.imageInsets.left - self.imageInsets.right,
                                  patternSize.height * contentRect.size.height - self.imageInsets.top - self.imageInsets.bottom);

    return imageRect;
}

- (void)drawImage:(UIImage*)image inRect:(CGRect)imageRect {
    if (!image
        || [image isKindOfClass:[NSNull class]]) {

        if (self.imageArray.count > 1) {
            //                    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:imageRect cornerRadius:5.0];

            //                    [[UIColor blueColor] setFill];
            //                    [path fill];

            [(self.imageBackgroundColor ?: [UIColor groupTableViewBackgroundColor])  setFill];

            //                    [path stroke];
            //                    UIRectFill(imageRect);

            [[UIBezierPath bezierPathWithRoundedRect:imageRect cornerRadius:self.cornerRadius] fill];
        }
        else {
            //                        path
            [(self.imageBackgroundColor ?: [UIColor groupTableViewBackgroundColor])  set];
            UIRectFill(imageRect);
        }

    }
    else {

        [[self prepareImage:image forSize:imageRect.size useConrners:self.imageArray.count > 1] drawInRect:imageRect];
    }
}

- (void)drawCountPlaceholderAtImageRect:(CGRect)imageRect {
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:imageRect cornerRadius:self.cornerRadius];

    //                    [[UIColor blueColor] setFill];
    //                    [path fill];

    [[UIColor redColor] setFill];

    //                    [path stroke];
    //                    UIRectFill(imageRect);

    [path fill];

    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;

    CGRect textRect = imageRect;
    CGFloat lineHeight = (self.textFont ?: [UIFont systemFontOfSize:17]).lineHeight;
    textRect.size.height = lineHeight;
    textRect.origin.y = textRect.origin.y + (imageRect.size.height - textRect.size.height) / 2;



    [[NSString stringWithFormat:@"+%ld", (long)(self.imageArray.count - 5)] drawInRect:textRect withAttributes:@{
                                                                                                                 NSFontAttributeName : self.textFont ?: [UIFont systemFontOfSize:17],
                                                                                                                 NSForegroundColorAttributeName: self.textColor ?: [UIColor blackColor],
                                                                                                                 NSParagraphStyleAttributeName : paragraphStyle
                                                                                                                 }];
}

- (void)drawRect:(CGRect)rect {
    [self.backgroundColor set];
    UIRectFill(rect);

    CGRect contentRect = UIEdgeInsetsInsetRect(rect, self.contentInsets);

    if (self.imageArray.count > 0 && self.imageArray.count <= 6) {
        NSArray *currentPattern = self.pattern[self.imageArray.count - 1];

        [currentPattern enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {



            CGRect imageRect = [self rectFromPattern:obj andContentRect:contentRect];

            [self drawImage:self.imageArray[idx] inRect:imageRect];

        }];
        
    }
    else if (self.imageArray.count > 6) {
        NSArray *currentPattern = self.pattern[5];

        [currentPattern enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {


            CGRect imageRect = [self rectFromPattern:obj andContentRect:contentRect];

            if (idx >= 5) {
                [self drawCountPlaceholderAtImageRect:imageRect];
            }
            else {
                [self drawImage:self.imageArray[idx] inRect:imageRect];
            }

        }];
    }

}

- (UIImage*)prepareImage:(UIImage*)image forSize:(CGSize)size useConrners:(BOOL)conrners {


//            UIImage *resultImage = [[[self class] shakersCache] objectForKey:cacheKey];

//            if (resultImage == nil) {


                UIGraphicsBeginImageContextWithOptions(size, NO, 0);

//                CGContextRef context = UIGraphicsGetCurrentContext();

                //        [[UIColor clearColor] set];
        
//                CGContextClearRect(context, (CGRect) { .origin.x = 0, .origin.y = 0, .size = size });

//    CGContextSetReg

//    if (conrners) {
//        [(self.imageBackgroundColor ?: [UIColor groupTableViewBackgroundColor]) setFill];
//        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, floor(size.width), floor(size.height))
//                                                        cornerRadius:self.cornerRadius];
//
//        [path fill];
////        [path addClip];
//    }
//    else {
//        [(self.backgroundColor ?: [UIColor whiteColor]) set];
//        UIRectFill((CGRect) { .origin.x = 0, .origin.y = 0, .size = size });
//                CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 1);
//    CGContextFillRect(context, (CGRect) { .origin.x = 0, .origin.y = 0, .size = size });
//    }

//    [self.backgroundColor set];
//    UIRectFill((CGRect) { .origin.x = 0, .origin.y = 0, .size = size });

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
        [(self.imageBackgroundColor ?: [UIColor groupTableViewBackgroundColor]) setFill];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, floor(size.width), floor(size.height))
                                                        cornerRadius:self.cornerRadius];

        path.lineWidth = 0;
        [path fill];
        [path addClip];
    }
    else {
        [(self.imageBackgroundColor ?: [UIColor groupTableViewBackgroundColor]) set];
        UIRectFill(CGRectMake(x, y, floor(width), floor(height)));
    }
                [image drawInRect:CGRectMake(x, y, floor(width), floor(height))];

                UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
        
//                [[[self class] shakersCache] setObject:resultImage forKey:cacheKey];

                UIGraphicsEndImageContext();
//            }

//    self

            return resultImage;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    [self willChangeValueForKey:@"cornerRadius"];
    _cornerRadius = cornerRadius;
    [self didChangeValueForKey:@"cornerRadius"];
    [self setNeedsDisplay];
}

- (void)setImageBackgroundColor:(UIColor *)imageBackgroundColor {
    [self willChangeValueForKey:@"imageBackgroundColor"];
    _imageBackgroundColor = imageBackgroundColor;
    [self didChangeValueForKey:@"imageBackgroundColor"];
    [self setNeedsDisplay];
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    [self willChangeValueForKey:@"contentInsets"];
    _contentInsets = contentInsets;
    [self didChangeValueForKey:@"contentInsets"];
    [self setNeedsDisplay];
}

- (void)setImageInsets:(UIEdgeInsets)imageInsets {
    [self willChangeValueForKey:@"imageInsets"];
    _imageInsets = imageInsets;
    [self didChangeValueForKey:@"imageInsets"];
    [self setNeedsDisplay];
}

- (void)setTextFont:(UIFont *)textFont {
    [self willChangeValueForKey:@"textFont"];
    _textFont = textFont;
    [self didChangeValueForKey:@"textFont"];
    if (self.imageArray.count > 6) {
        [self setNeedsDisplay];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    [self willChangeValueForKey:@"textColor"];
    _textColor = textColor;
    [self didChangeValueForKey:@"textColor"];
    if (self.imageArray.count > 6) {
        [self setNeedsDisplay];
    }
}
@end
