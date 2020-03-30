//
//  XFCircleLayer.m
//
//  Created by apple on 2020/3/12.
//  Copyright © 2020 Jixin. All rights reserved.
//

#import "XFCircleLayer.h"


@interface XFCircleLayer ()
@property (nonatomic, assign) CGFloat beginProgress;
@property (nonatomic, strong) CABasicAnimation *opacityAni;
@property (nonatomic, assign) CGColorRef lastStrokeColor;
@end

@implementation XFCircleLayer
#pragma mark - setup
- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    self.needsDisplayOnBoundsChange = YES;
    [self setup];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [self init]) {
        self.frame = frame;
    }
    return self;
}

- (void)setup {
    self.lineWidth = 4;
    self.strokeColor = [UIColor colorWithWhite:0 alpha:0.4].CGColor;
    self.progress = 0;
    self.beginProgress = -1;
}

- (void)drawInContext:(CGContextRef)ctx {
    CGFloat radius = self.bounds.size.width / 2;
    CGFloat lineWidth = self.lineWidth;
    CGFloat zeroAngle = - M_PI_2;
    CGFloat startAngle = zeroAngle + MAX(self.beginProgress, 0) * M_PI * 2;
    CGFloat endAngle = zeroAngle + self.progress * M_PI * 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:(radius - lineWidth / 2) startAngle:startAngle endAngle:endAngle clockwise:YES];
    CGContextSetStrokeColorWithColor(ctx, self.strokeColor);
    CGContextSetLineWidth(ctx, lineWidth);//线条宽度
    CGContextAddPath(ctx, path.CGPath);
    CGContextStrokePath(ctx);
}

- (void)setProgress:(CGFloat)progress {
    CGFloat tmp = MAX(0, progress);
    tmp = MIN(1.0, progress);
    _progress = progress;
    if (_beginProgress == -1) {
        _beginProgress = _progress;
    }
    [self setNeedsDisplay];
}

- (CABasicAnimation *)opacityAni {
    if (!_opacityAni) {
        _opacityAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _opacityAni.fromValue = @1;
        _opacityAni.toValue = @0;
        _opacityAni.duration = 1;
        _opacityAni.repeatCount = CGFLOAT_MAX;
    }
    return _opacityAni;
}


#pragma mark - aciton
- (void)beginOpacityAnimationWithColor:(UIColor *)color {
    if (color) {
        self.lastStrokeColor = self.strokeColor;
        self.strokeColor = color.CGColor;
        [self setNeedsDisplay];
    }
    if (![self animationForKey:@"opacityAni"]) {
        [self addAnimation:self.opacityAni forKey:@"opacityAni"];
    }
}

- (void)endOpacityAnimation {
    if (self.lastStrokeColor) {
        self.strokeColor = self.lastStrokeColor;
        self.lastStrokeColor = nil;
        [self setNeedsDisplay];
    }
    if ([self animationForKey:@"opacityAni"]) {
        [self removeAnimationForKey:@"opacityAni"];
    }
}
@end
