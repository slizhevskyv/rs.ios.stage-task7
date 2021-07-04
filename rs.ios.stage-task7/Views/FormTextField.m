//
//  FormTextField.m
//  rs.ios.stage-task7
//
//  Created by Vladislav Slizhevsky on 7/3/21.
//

#import "FormTextField.h"

@implementation FormTextField

-(CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 10, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 10, bounds.size.height);
}

@end
