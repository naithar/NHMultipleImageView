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

@property (nonatomic, assign) CGRect selectedRect;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation NHMultiImageView

+ (NSCache*)sharedCache {
    static dispatch_once_t token;
    __strong static NSCache *instance = nil;
    dispatch_once(&token, ^{
        instance = [[NSCache alloc] init];
    });

    return instance;
}

+ (void)placeImage:(UIImage*)image inCacheForSize:(CGSize)size withCorners:(BOOL)corners withHash:(id)hash {
    [[self sharedCache] setObject:image
                           forKey:[NSString stringWithFormat:@"%@-%@-%@", hash, @(corners), NSStringFromCGSize(size)]];
}

+ (UIImage*)imageFromCacheForSize:(CGSize)size withCorners:(BOOL)corners withHash:(id)hash {

    UIImage *result = [[self sharedCache]
                       objectForKey:[NSString stringWithFormat:@"%@-%@-%@", hash, @(corners), NSStringFromCGSize(size)]];
    return result;
}

+ (NSArray*)createPatternFromJSON:(id)json {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];

    [json[@"pattern"] enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL *stop) {
        NSMutableArray *innerArray = [[NSMutableArray alloc] init];

        [obj enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            [innerArray addObject:@{
                                    @"origin" : [NSValue
                                                 valueWithCGPoint:CGPointMake(
                                                                              [obj[@"origin"][0] floatValue],
                                                                              [obj[@"origin"][1] floatValue])],
                                    @"size" : [NSValue
                                               valueWithCGPoint:CGPointMake(
                                                                            [obj[@"size"][0] floatValue],
                                                                            [obj[@"size"][1] floatValue])],
                                    }];
        }];

        [resultArray addObject:innerArray];
    }];

    return resultArray;
}

+ (NSArray*)defaultPattern {
    static dispatch_once_t token;
    __strong static NSArray* instance = nil;
    dispatch_once(&token, ^{

        NSString *bundlePath = [[NSBundle bundleForClass:[NHMultiImageView class]]
                                pathForResource:@"NHMultipleImageView"
                                ofType:@"bundle"];

        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];

        NSData *patternData = [NSData dataWithContentsOfFile:[bundle
                                                              pathForResource:@"NHMultiImagePattern"
                                                              ofType:@"json"]];

        id result = [NSJSONSerialization JSONObjectWithData:patternData
                                                    options:0
                                                      error:nil];

        instance = [self createPatternFromJSON:result];

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
    _selectedRect = CGRectNull;
    _selectedIndex = -1;

    self.multipleTouchEnabled = NO;
    self.userInteractionEnabled = YES;


    self.opaque = YES;
    self.clipsToBounds = YES;

}

- (BOOL)findSelectedRectWithTouches:(NSSet*)touches {
    __block BOOL returnValue = NO;
    CGPoint selectedPoint = [((UITouch*)touches.anyObject) locationInView:self];
    CGPoint previousSelectedPoint = [((UITouch*)touches.anyObject) previousLocationInView:self];

    if (CGPointEqualToPoint(selectedPoint, previousSelectedPoint)
        && !CGRectIsNull(self.selectedRect)) {
        return NO;
    }

    CGRect contentRect = UIEdgeInsetsInsetRect(self.bounds, self.contentInsets);

    NSInteger minCount;

    if (self.maxImageCount > 0) {
        minCount = MIN(self.maxImageCount, self.pattern.count);
    }
    else {
        minCount = self.pattern.count;
    }

    self.selectedIndex = -1;

    if (self.imageArray.count > 0
        && self.imageArray.count <= minCount) {
        NSArray *currentPattern = self.pattern[self.imageArray.count - 1];

        [currentPattern enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            CGRect imageRect = [self rectFromPattern:obj andContentRect:contentRect];

            if (CGRectContainsPoint(imageRect, selectedPoint)
                && (!CGRectEqualToRect(imageRect, self.selectedRect))) {
                self.selectedRect = imageRect;
                self.selectedIndex = idx;
                returnValue = YES;
                *stop = YES;
            }
        }];
    }
    else if (self.imageArray.count > minCount) {
        NSArray *currentPattern = self.pattern[minCount - 1];

        [currentPattern enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            CGRect imageRect = [self rectFromPattern:obj andContentRect:contentRect];

            if (CGRectContainsPoint(imageRect, selectedPoint)
                && (!CGRectEqualToRect(imageRect, self.selectedRect))) {
                self.selectedRect = imageRect;
                self.selectedIndex = idx;
                returnValue = YES;
                *stop = YES;
            }
        }];
    }

    return returnValue;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    if ([self findSelectedRectWithTouches:touches]) {
        [self setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    if ([self findSelectedRectWithTouches:touches]) {
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    __weak __typeof(self) weakSelf = self;
    if (self.selectedIndex != -1
        && [weakSelf.delegate respondsToSelector:@selector(multiImageView:didSelectIndex:)]) {
        [weakSelf.delegate multiImageView:weakSelf didSelectIndex:self.selectedIndex];
    }

    self.selectedIndex = -1;
    self.selectedRect = CGRectNull;
    [self setNeedsDisplay];


}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    self.selectedIndex = -1;
    self.selectedRect = CGRectNull;
    [self setNeedsDisplay];
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
    if (index >= self.imageArray.count) {
        return;
    }

    self.imageArray[index] = image;
    [self setNeedsDisplay];
}

- (void)addCenteredImage:(UIImage*)image toIndex:(NSInteger)index {
    if (index >= self.imageArray.count) {
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

- (void)clearImageArray {
    self.imageArray = [[NSMutableArray alloc] init];
    [self setNeedsDisplay];
}

- (NSInteger)currentCount {
    return self.imageArray.count;
}

- (CGRect)rectFromPattern:(NSDictionary*)pattern andContentRect:(CGRect)contentRect {
    CGPoint patternOrigin = [pattern[@"origin"] CGPointValue];
    CGSize patternSize = [pattern[@"size"] CGSizeValue];

    CGRect imageRect = CGRectMake(round(self.contentInsets.left + patternOrigin.x * contentRect.size.width),
                                  round(self.contentInsets.top + patternOrigin.y * contentRect.size.height),
                                  round(patternSize.width * contentRect.size.width - self.contentInsets.left),
                                  round(patternSize.height * contentRect.size.height - self.contentInsets.top));

    imageRect = UIEdgeInsetsInsetRect(imageRect,
                                      UIEdgeInsetsMake(imageRect.origin.y == self.contentInsets.top ? 0 : self.imageInsets.top,
                                                       imageRect.origin.x == self.contentInsets.left ? 0 : self.imageInsets.left,
                                                       CGRectGetMaxY(imageRect) >= contentRect.size.height ? 0 : self.imageInsets.bottom,
                                                       CGRectGetMaxX(imageRect) >= contentRect.size.width ? 0 : self.imageInsets.right));

    return imageRect;
}

- (void)drawImage:(id)image inRect:(CGRect)imageRect {
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

    if (!CGRectIsNull(self.selectedRect)) {

        if (self.imageArray.count > 1) {
            [[UIBezierPath bezierPathWithRoundedRect:self.selectedRect cornerRadius:self.cornerRadius] addClip];
        }
        CGContextRef context = UIGraphicsGetCurrentContext();
        [(self.selectionColor ?: [[UIColor blackColor] colorWithAlphaComponent:0.35]) setFill];
        CGContextFillRect(context, self.selectedRect);
    }

}

- (UIImage*)prepareImage:(id)imageData forSize:(CGSize)size useCornerRadius:(BOOL)corners {

    UIImage *image;
    UIViewContentMode mode = UIViewContentModeScaleToFill;

    if ([imageData isKindOfClass:[UIImage class]]) {
        image = imageData;
    }
    else if ([imageData isKindOfClass:[NSDictionary class]]) {
        image = imageData[@"image"];
        mode = [imageData[@"contentMode"] unsignedIntegerValue];
    }

    UIImage *resultImage = [[self class] imageFromCacheForSize:size withCorners:corners withHash:@([image hash])];

    if (!resultImage) {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);


    if (corners) {
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

        if (image.size.height) {
            CGFloat ratio = image.size.width / image.size.height;

            if (ratio) {
                if (ratio > 1.5) {
                    if (size.height * ratio > size.width) {
                        height = size.height;
                        width = height * ratio;
                    }
                    else {
                        width = size.width;
                        height = width / ratio;
                    }
                }
                else if (ratio < 0.5) {
                    if (size.height * ratio > size.width) {
                        height = size.height;
                        width = height / ratio;
                    }
                    else {
                        width = size.width;
                        height = width / ratio;
                    }
                }
                else {
                    if (size.height * ratio > size.width) {
                        height = size.height;
                        width = height * ratio;
                    }
                    else {
                        width = size.width;
                        height = width / ratio;
                    }
                }

                x = (size.width - width) / 2;
                y = (size.height - height) / 2;
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

    resultImage = UIGraphicsGetImageFromCurrentImageContext();

        [[self class] placeImage:resultImage inCacheForSize:size withCorners:corners withHash:@([image hash])];
    //                [[[self class] shakersCache] setObject:resultImage forKey:cacheKey];

    UIGraphicsEndImageContext();
    //            }

    }

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

    NSInteger minCount;

    if (self.maxImageCount > 0) {
        minCount = MIN(self.maxImageCount, self.pattern.count);
    }
    else {
        minCount = self.pattern.count;
    }

    if (self.imageArray.count > minCount) {
        [self setNeedsDisplay];
    }
}

- (void)setNeedsDisplayForTextContainer {
    NSInteger minCount;

    if (self.maxImageCount > 0) {
        minCount = MIN(self.maxImageCount, self.pattern.count);
    }
    else {
        minCount = self.pattern.count;
    }

    if (self.imageArray.count > minCount) {
        [self setNeedsDisplay];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    [self willChangeValueForKey:@"textColor"];
    _textColor = textColor;
    [self didChangeValueForKey:@"textColor"];
    [self setNeedsDisplayForTextContainer];
}

- (void)setTextContainerBorderColor:(UIColor *)textContainerBorderColor {
    [self willChangeValueForKey:@"textContainerBorderColor"];
    _textContainerBorderColor = textContainerBorderColor;
    [self didChangeValueForKey:@"textContainerBorderColor"];
    [self setNeedsDisplayForTextContainer];
}

- (void)setTextContainerBorderWidth:(CGFloat)textContainerBorderWidth {
    [self willChangeValueForKey:@"textContainerBorderWidth"];
    _textContainerBorderWidth = textContainerBorderWidth;
    [self didChangeValueForKey:@"textContainerBorderWidth"];
    [self setNeedsDisplayForTextContainer];
}

- (void)setTextContainerBackgroundColor:(UIColor *)textContainerBackgroundColor {
    [self willChangeValueForKey:@"textContainerBackgroundColor"];
    _textContainerBackgroundColor = textContainerBackgroundColor;
    [self didChangeValueForKey:@"textContainerBackgroundColor"];
    [self setNeedsDisplayForTextContainer];
}

- (void)setMaxImageCount:(NSUInteger)maxImageCount {
    if (_maxImageCount != maxImageCount) {
        [self willChangeValueForKey:@"maxImageCount"];
        _maxImageCount = maxImageCount;
        [self didChangeValueForKey:@"maxImageCount"];
        [self setNeedsDisplay];
    }
}

- (void)setSelectionColor:(UIColor *)selectionColor {
    if (_selectionColor != selectionColor) {
        [self willChangeValueForKey:@"selectionColor"];
        _selectionColor = selectionColor;
        [self didChangeValueForKey:@"selectionColor"];
        
        if (!CGRectIsNull(self.selectedRect)) {
            [self setNeedsDisplay];
        }
    }
}
@end
