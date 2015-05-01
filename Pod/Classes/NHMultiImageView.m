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
    _imageArray = [[NSMutableArray alloc] initWithCapacity:4];

    self.opaque = YES;
    self.clipsToBounds = YES;

}

- (void)addImage:(UIImage*)image
         toIndex:(NSInteger)index {
//    if (index > self.imageArray.count) {
//        return;
//    }

    [self.imageArray addObject:image];
}


- (void)drawRect:(CGRect)rect {

    [self.backgroundColor set];
    UIRectFill(rect);

    switch (self.imageArray.count) {
        case 1:
            [[self prepareImage:self.imageArray.firstObject forSize:rect.size useConrners:NO] drawInRect:rect];
            break;
        case 2: {
            CGRect rect1 = rect;
            rect1.size.width = rect1.size.width / 2 - 5;

            CGRect rect2 = rect1;
            rect2.origin.x = rect1.size.width + 10;

            [[self prepareImage:self.imageArray.firstObject forSize:rect1.size useConrners:YES] drawInRect:rect1];
            [[self prepareImage:self.imageArray[1] forSize:rect2.size useConrners:YES] drawInRect:rect2];
        } break;
        case 3: {
            CGRect rect1 = rect;
            rect1.size.width = rect1.size.width / 2 - 5;

            CGRect rect2 = rect1;
            rect2.origin.x = rect1.size.width + 10;
            rect2.size.height = rect2.size.height / 2 - 5;

            CGRect rect3 = rect2;
            rect3.origin.y = rect2.size.height + 10;
            rect3.size.height /= 2;

            [[self prepareImage:self.imageArray.firstObject forSize:rect1.size useConrners:YES] drawInRect:rect1];
            [[self prepareImage:self.imageArray[1] forSize:rect2.size useConrners:YES] drawInRect:rect2];
            [[self prepareImage:self.imageArray[2] forSize:rect3.size useConrners:YES] drawInRect:rect3];
        } break;
        default:
            break;
    }
}

- (UIImage*)prepareImage:(UIImage*)image forSize:(CGSize)size useConrners:(BOOL)conrners {


//            UIImage *resultImage = [[[self class] shakersCache] objectForKey:cacheKey];

//            if (resultImage == nil) {


                UIGraphicsBeginImageContextWithOptions(size, YES, 0);

                CGContextRef context = UIGraphicsGetCurrentContext();
        
                //        [[UIColor clearColor] set];
        
                CGContextClearRect(context, (CGRect) { .origin.x = 0, .origin.y = 0, .size = size });
                CGContextSetRGBFillColor(context, 0, 0, 0, 1);
        
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

//                        height /= value;
//                        y -= (height - size.height) / 2;
//
//                        width /= value2;
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

//                        width /= value;
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
