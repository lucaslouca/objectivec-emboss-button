//
//  EmbossButton.m
//  ButtonTest
//
//  Created by Lucas Louca on 25/12/13.
//  Copyright (c) 2013 Lucas Louca. All rights reserved.
//

#import "EmbossButton.h"

@implementation EmbossButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self setNeedsDisplay];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    float buttonCornerRadius = 100.0;
    float buttonBackStrokeWidth = 1.0;
    UIColor *buttonShadowColor = [UIColor blackColor];
    float buttonStrokeWidth = 1.0;
    float buttonInset = 9.0;
    
    if (self.state == UIControlStateHighlighted) {
        buttonInset = 10.0;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /* Draw the back of the button */
    // Add a light stroke
    UIBezierPath *stroke = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:buttonCornerRadius];
    CGContextAddPath(context, stroke.CGPath);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:39.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1.0].CGColor);
    CGContextSetLineWidth(context, buttonBackStrokeWidth);
    CGContextStrokePath(context);
    
    // Make the button back gradient
    CGRect buttonBackRect = CGRectInset(self.bounds, buttonBackStrokeWidth, buttonBackStrokeWidth);
    UIBezierPath *buttonBackClipPath = [UIBezierPath bezierPathWithRoundedRect:buttonBackRect cornerRadius:buttonCornerRadius];
    CGGradientRef buttonBackGradient;
    CGColorSpaceRef myColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 18/255.0, 18/255.0, 18/255.0, 1.0,  // Start color
                              58/255.0, 58/255.0, 58/255.0, 1.0 }; // End color
    
    myColorspace = CGColorSpaceCreateDeviceRGB();
    buttonBackGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, num_locations);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(buttonBackRect), CGRectGetMinY(buttonBackRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(buttonBackRect), CGRectGetMaxY(buttonBackRect));
    CGContextSaveGState(context);
    CGContextAddPath(context, buttonBackClipPath.CGPath);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, buttonBackGradient, startPoint, endPoint, 0);
    CGGradientRelease(buttonBackGradient);
    CGColorSpaceRelease(myColorspace);
    CGContextRestoreGState(context);
    
    
    /* Draw the button */
    // Drop shadow
    CGRect buttonShadowRect = CGRectInset(self.bounds, buttonInset, buttonInset);
    UIBezierPath *buttonShadowClipPath = [UIBezierPath bezierPathWithRoundedRect:buttonShadowRect cornerRadius:buttonCornerRadius];
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 2.0, buttonShadowColor.CGColor);
    CGContextAddPath(context, buttonShadowClipPath.CGPath);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    
    
    // Draw the gradient Button stroke
    CGRect buttonStrokeRect = CGRectInset(self.bounds, buttonInset, buttonInset);
    UIBezierPath *buttonStrokeClipPath = [UIBezierPath bezierPathWithRoundedRect:buttonStrokeRect cornerRadius:buttonCornerRadius];
    CGGradientRef buttonStrokeGradient;
    CGColorSpaceRef buttonStrokeColorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat buttonStrokeGradientLocations[2] = { 0.0, 1.0 };
    CGFloat buttonStrokeGradientComponents[8] = { 84/255.0, 84/255.0, 84/255.0, 1.0,  // Start color
        0/255.0, 0/255.0, 0/255.0, 1.0 }; // End color
    
    buttonStrokeGradient = CGGradientCreateWithColorComponents(buttonStrokeColorspace, buttonStrokeGradientComponents, buttonStrokeGradientLocations, 2);
    CGPoint buttonStrokeGradientStartPoint = CGPointMake(CGRectGetMidX(buttonStrokeRect), CGRectGetMinY(buttonStrokeRect));
    CGPoint buttonStrokeGradientEndPoint = CGPointMake(CGRectGetMidX(buttonStrokeRect), CGRectGetMaxY(buttonStrokeRect));
    CGContextSaveGState(context);
    CGContextAddPath(context, buttonStrokeClipPath.CGPath);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, buttonStrokeGradient, buttonStrokeGradientStartPoint, buttonStrokeGradientEndPoint, 0);
    CGGradientRelease(buttonStrokeGradient);
    CGColorSpaceRelease(buttonStrokeColorspace);
    CGContextRestoreGState(context);

    
    // Draw the actual button
    CGRect buttonRect = CGRectInset(self.bounds, buttonInset + buttonStrokeWidth, buttonInset + buttonStrokeWidth);
    UIBezierPath *buttonClipPath = [UIBezierPath bezierPathWithRoundedRect:buttonRect cornerRadius:buttonCornerRadius];
    CGGradientRef buttonGradient;
    CGColorSpaceRef buttonColorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat buttonGradientLocations[2] = { 0.0, 1.0 };

    if (self.state == UIControlStateHighlighted) {
        CGFloat buttonGradientComponentsHighlighted[8] = { 50/255.0, 50/255.0, 50/255.0, 1.0,  // Start color highlighted
            40/255.0, 40/255.0, 40/255.0, 1.0 }; // End color highlighted
         buttonGradient = CGGradientCreateWithColorComponents(buttonColorspace, buttonGradientComponentsHighlighted, buttonGradientLocations, 2);
    } else {
        CGFloat buttonGradientComponents[8] = { 54/255.0, 54/255.0, 54/255.0, 1.0,  // Start color
            42/255.0, 42/255.0, 42/255.0, 1.0 }; // End color
        buttonGradient = CGGradientCreateWithColorComponents(buttonColorspace, buttonGradientComponents, buttonGradientLocations, 2);
    }
    
    
    CGPoint buttonGradientStartPoint = CGPointMake(CGRectGetMidX(buttonRect), CGRectGetMinY(buttonRect));
    CGPoint buttonGradientEndPoint = CGPointMake(CGRectGetMidX(buttonRect), CGRectGetMaxY(buttonRect));
    CGContextSaveGState(context);
    CGContextAddPath(context, buttonClipPath.CGPath);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, buttonGradient, buttonGradientStartPoint, buttonGradientEndPoint, 0);
    CGGradientRelease(buttonGradient);
    CGColorSpaceRelease(buttonColorspace);
    CGContextRestoreGState(context); 
}


@end
