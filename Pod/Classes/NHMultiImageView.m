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
    _textContainerBorderWidth = 0;

    self.opaque = YES;
    self.clipsToBounds = YES;

}

- (void)changePatternTo:(NSArray*)pattern {
    self.pattern = pattern;
    [self setNeedsDisplay];
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

- (void)addCenteredImage:(UIImage*)image toIndex:(NSInteger)index {
    if (index > self.imageArray.count) {
        return;
    }

    self.imageArray[index] = @{
                               @"image" : image,
                               @"contentMode" : @(UIViewContentModeCenter)
                               };
    [self setNeedsDisplay];
}

- (void)setImageArraySize:(NSUInteger)size {
    self.imageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < size; i++) {
        [self.imageArray addObject:[NSNull null]];
    }
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

            [(self.imageBackgroundColor ?: [UIColor groupTableViewBackgroundColor])  setFill];


            [[UIBezierPath bezierPathWithRoundedRect:imageRect cornerRadius:self.cornerRadius] fill];
        }
        else {
            [(self.imageBackgroundColor ?: [UIColor groupTableViewBackgroundColor])  set];
            UIRectFill(imageRect);
        }

    }
    else {

        [[self prepareImage:image
                    forSize:imageRect.size
                useCornerRadius:self.imageArray.count > 1] drawInRect:imageRect];
    }
}

- (void)drawCountPlaceholderAtImageRect:(CGRect)imageRect {

    CGRect placeholderRect = UIEdgeInsetsInsetRect(imageRect, UIEdgeInsetsMake(
                                                                               self.textContainerBorderWidth /2,
                                                                               self.textContainerBorderWidth /2,
                                                                               self.textContainerBorderWidth /2,
                                                                               self.textContainerBorderWidth /2));

    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:placeholderRect cornerRadius:self.cornerRadius];

    //                    [[UIColor blueColor] setFill];
    //                    [path fill];

        path.lineWidth = self.textContainerBorderWidth;
    [(self.textContainerBorderColor ?: [UIColor blackColor]) setStroke];
    [(self.textContainerBackgroundColor ?: [UIColor groupTableViewBackgroundColor]) setFill];

                        [path stroke];
    //                    UIRectFill(imageRect);


    [path fill];

    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;

    CGRect textRect = placeholderRect;
    CGFloat lineHeight = (self.textFont ?: [UIFont systemFontOfSize:17]).lineHeight;
    textRect.size.height = lineHeight;
    textRect.origin.y = textRect.origin.y + (placeholderRect.size.height - textRect.size.height) / 2;

    NSInteger minCount;

    if (self.maxImageCount > 0) {
        minCount = MIN(self.maxImageCount, self.pattern.count);
    }
    else {
        minCount = self.pattern.count;
    }

    [[NSString stringWithFormat:@"+%ld", (long)(self.imageArray.count - (minCount - 1))] drawInRect:textRect withAttributes:@{
                                                                                                                 NSFontAttributeName : self.textFont ?: [UIFont systemFontOfSize:17],
                                                                                                                 NSForegroundColorAttributeName: self.textColor ?: [UIColor blackColor],
                                                                                                                 NSParagraphStyleAttributeName : paragraphStyle
                                                                                                                 }];
}

- (void)drawRect:(CGRect)rect {
    [self.backgroundColor set];
    UIRectFill(rect);

    CGRect contentRect = UIEdgeInsetsInsetRect(rect, self.contentInsets);

    NSInteger minCount;

    if (self.maxImageCount > 0) {
        minCount = MIN(self.maxImageCount, self.pattern.count);
    }
    else {
        minCount = self.pattern.count;
    }

    if (self.imageArray.count > 0
        && self.imageArray.count <= minCount) {
        NSArray *currentPattern = self.pattern[self.imageArray.count - 1];

        [currentPattern enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {



            CGRect imageRect = [self rectFromPattern:obj andContentRect:contentRect];

            [self drawImage:self.imageArray[idx] inRect:imageRect];

        }];
    }
    else if (self.imageArray.count > minCount) {
        NSArray *currentPattern = self.pattern[minCount - 1];

        [currentPattern enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {


            CGRect imageRect = [self rectFromPattern:obj andContentRect:contentRect];

            if (idx >= minCount - 1) {
                [self drawCountPlaceholderAtImageRect:imageRect];
            }
            else {
                [self drawImage:self.imageArray[idx] inRect:imageRect];
            }

        }];
    }

}

- (UIImage*)prepareImage:(id)imageData forSize:(CGSize)size useCornerRadius:(BOOL)conrners {

    UIImage *image;
    UIViewContentMode mode = UIViewContentModeScaleToFill;

    if ([imageData isKindOfClass:[UIImage class]]) {
        image = imageData;
    }
    else if ([imageData isKindOfClass:[NSDictionary class]]) {
        image = imageData[@"image"];
        mode = [imageData[@"contentMode"] unsignedIntegerValue];
    }

    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGFloat value = image.size.width / image.size.height;

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
        UIRectFill(CGRectMake(0, 0, floor(size.width), floor(size.height)));
    }


    CGFloat height = size.height;
    CGFloat width = size.width;
                CGFloat x = 0;
                CGFloat y = 0;


    if (mode != UIViewContentModeCenter) {

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
    }
    else {
        x = (size.width - image.size.width) / 2;
        y = (size.height - image.size.height) / 2;
        width = image.size.width;
        height = image.size.height;
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

- (void)setTextContainerBorderColor:(UIColor *)textContainerBorderColor {
    [self willChangeValueForKey:@"textContainerBorderColor"];
    _textContainerBorderColor = textContainerBorderColor;
    [self didChangeValueForKey:@"textContainerBorderColor"];
    [self setNeedsDisplay];
}

- (void)setTextContainerBorderWidth:(CGFloat)textContainerBorderWidth {
    [self willChangeValueForKey:@"textContainerBorderWidth"];
    _textContainerBorderWidth = textContainerBorderWidth;
    [self didChangeValueForKey:@"textContainerBorderWidth"];
    [self setNeedsDisplay];
}

- (void)setTextContainerBackgroundColor:(UIColor *)textContainerBackgroundColor {
    [self willChangeValueForKey:@"textContainerBackgroundColor"];
    _textContainerBackgroundColor = textContainerBackgroundColor;
    [self didChangeValueForKey:@"textContainerBackgroundColor"];
    [self setNeedsDisplay];
}

- (void)setMaxImageCount:(NSUInteger)maxImageCount {
    if (_maxImageCount != maxImageCount) {
        [self willChangeValueForKey:@"maxImageCount"];
        _maxImageCount = maxImageCount;
        [self didChangeValueForKey:@"maxImageCount"];
        [self setNeedsDisplay];
    }
}
@end
