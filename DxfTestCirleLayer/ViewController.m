//
//  ViewController.m
//  DxfTestCirleLayer
//
//  Created by apple on 2020/3/27.
//  Copyright © 2020 demo. All rights reserved.
//

#import "ViewController.h"
#import "XFCircleLayer.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *xfImgDisplay;
@property (weak, nonatomic) IBOutlet UILabel *xfLabDisplay;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) NSTimer *xftimer;
@property (nonatomic, strong) UIButton *xfbuttonRecord;//开始
@property (nonatomic, strong) UIButton *xfbuttonPause;//暂停
@property (nonatomic, strong) UIButton *xfbuttonDelete;//删除
@property (nonatomic, strong) NSMutableArray<XFCircleLayer *> *videoList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.xfbuttonRecord.frame = CGRectMake(10, CGRectGetMaxY(self.xfImgDisplay.frame) + 10, 40, 30);
    [self.view addSubview:self.xfbuttonRecord];
    self.xfbuttonPause.frame = CGRectMake(CGRectGetMaxX(self.xfbuttonRecord.frame) + 10, CGRectGetMinY(self.xfbuttonRecord.frame), 40, 30);
    [self.view addSubview:self.xfbuttonPause];
    self.xfbuttonDelete.frame = CGRectMake(CGRectGetMaxX(self.xfbuttonPause.frame) + 10, CGRectGetMinY(self.xfbuttonPause.frame), 40, 30);
    [self.view addSubview:self.xfbuttonDelete];
    
}



#pragma mark - handle
- (void)handleDidClickRecord:(UIButton *)sender {
    if (self.xftimer) {
        [self.xftimer invalidate];
        self.xftimer = nil;
    }
    XFCircleLayer *layer = [[XFCircleLayer alloc] init];
    layer.frame = self.xfImgDisplay.bounds;
    layer.strokeColor = UIColor.darkGrayColor.CGColor;
    /* //只看最后一段
    if (self.videoList.lastObject) {
        [self.videoList.lastObject removeFromSuperlayer];
        [self.videoList removeLastObject];
    }
     */
    [self.xfImgDisplay.layer addSublayer:layer];
    [self.videoList addObject:layer];
    self.xftimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
}

- (void)handleDidClickPause:(UIButton *)sender {
    if (self.xftimer) {
        [self.xftimer invalidate];
        self.xftimer = nil;
    }
}

- (void)handleDidClickDelete:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.videoList.lastObject endOpacityAnimation];
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.videoList.lastObject endOpacityAnimation];
        [self.videoList.lastObject removeFromSuperlayer];
        [self.videoList removeLastObject];
        self.progress = self.videoList.lastObject.progress;
        self.xfLabDisplay.text = [NSString stringWithFormat:@"%.1f", self.progress];
    }];
    [alert addAction:cancel];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
    [self.videoList.lastObject beginOpacityAnimationWithColor:UIColor.redColor];
}

- (void)handleTimer {
    CGFloat next = self.progress + 0.01;
    self.progress = MIN(MAX(0, next), 1);
    self.xfLabDisplay.text = [NSString stringWithFormat:@"%.1f", self.progress];
    self.videoList.lastObject.progress = self.progress;
}



#pragma mark - gettsr & setter

- (UIButton *)xfbuttonRecord {
    if (!_xfbuttonRecord) {
        _xfbuttonRecord = [[UIButton alloc] init];
        _xfbuttonRecord.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [_xfbuttonRecord setTitle:@"开始" forState:UIControlStateNormal];
        [_xfbuttonRecord addTarget:self action:@selector(handleDidClickRecord:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xfbuttonRecord;
}

- (UIButton *)xfbuttonPause {
    if (!_xfbuttonPause) {
        _xfbuttonPause = [[UIButton alloc] init];
        _xfbuttonPause.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [_xfbuttonPause setTitle:@"暂停" forState:UIControlStateNormal];
        [_xfbuttonPause addTarget:self action:@selector(handleDidClickPause:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xfbuttonPause;
}

- (UIButton *)xfbuttonDelete {
    if (!_xfbuttonDelete) {
        _xfbuttonDelete = [[UIButton alloc] init];
        _xfbuttonDelete.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [_xfbuttonDelete setTitle:@"删除" forState:UIControlStateNormal];
        [_xfbuttonDelete addTarget:self action:@selector(handleDidClickDelete:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xfbuttonDelete;
}

- (NSMutableArray<XFCircleLayer *> *)videoList {
    if (!_videoList) {
        _videoList = [NSMutableArray array];
    }
    return _videoList;
}

@end
