//
//  XFCircleLayer.h
//
//  Created by apple on 2020/3/12.
//  Copyright © 2020 Jixin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>



@interface XFCircleLayer : CAShapeLayer
@property (nonatomic, assign) CGFloat progress;

- (void)beginOpacityAnimationWithColor:(UIColor *)color;
- (void)endOpacityAnimation;
@end


