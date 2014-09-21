//
//  UIView+FormKit.m
//  OurMaps
//
//  Created by Jiangchuan Huang on 9/21/14.
//  Copyright (c) 2014 OurMaps. All rights reserved.
//


#import "UIView+FormKit.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface UIView (Private)

- (NSMutableArray *)fk_findTextFieldsAndStopAtFirst:(BOOL)stopAtFirst;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UIView (FormKit)


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)fk_findFirstResponder {
    if ([self isFirstResponder]) {
        return self;
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView fk_findFirstResponder];
        
        if (nil != firstResponder) {
            return firstResponder;
        }
    }
    
    return nil;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)fk_findFirstTextField {
    NSArray *fields = [self fk_findTextFieldsAndStopAtFirst:YES];
    if (fields.count == 1) {
        return [fields lastObject];
    }
    return nil;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)fk_findTextFields {
    return [self fk_findTextFieldsAndStopAtFirst:NO];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSMutableArray *)fk_findTextFieldsAndStopAtFirst:(BOOL)stopAtFirst {
    NSMutableArray *fields = [[NSMutableArray alloc] init];
    
    [self.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        if (YES == stopAtFirst && 1 == fields.count) {
            *stop = YES;
        }
        
        if ([subView isKindOfClass:[UITextField class]] || [subView isKindOfClass:[UITextView class]]) {
            [fields addObject:subView];
        } else {
            NSArray *fieldsFounded = [subView fk_findTextFieldsAndStopAtFirst:stopAtFirst];
            [fields addObjectsFromArray:fieldsFounded];
        }
    }];
    
    return fields;
}


@end
