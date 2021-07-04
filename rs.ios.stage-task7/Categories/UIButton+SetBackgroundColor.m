//
//  UIButton+SetBackgroundColor.m
//  rs.ios.stage-task7
//
//  Created by Vladislav Slizhevsky on 7/3/21.
//

#import "UIButton+SetBackgroundColor.h"

@implementation UIButton (SetBackgroundColor)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, 1, 1));
    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setBackgroundImage:coloredImage forState:state];
}

@end
