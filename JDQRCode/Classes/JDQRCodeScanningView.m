//
//  JDQRCodeScanningView.m
//  qrCode
//
//  Created by plan on 2018/5/23.
//  Copyright © 2018年 plan. All rights reserved.
//

#import "JDQRCodeScanningView.h"

@interface JDQRCodeScanningView ()

@property (nonatomic,assign) CGRect scanRect;
@property (nonatomic,strong) UIImageView *borderView;
@property (nonatomic,strong) UIImageView *scanningLine;

@end

@implementation JDQRCodeScanningView

+ (instancetype)initScanningViewWithViewFreme:(CGRect)viewFrame scanRect:(CGRect)scanRect{
    
    JDQRCodeScanningView *scanView = [[JDQRCodeScanningView alloc] initWithFrame:viewFrame];
    scanView.scanRect = scanRect;
    return scanView;
}

- (instancetype)initWithFrame:(CGRect)frame{

    if(self = [super initWithFrame:frame]){
        
        self.timerInterval = 0.01;
        
        // app启动或者app从后台进入前台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}
- (void)becomeActive{
    
    [self stopMoveScanningLine];
    [self startMoveScanningLine];
}

- (void)setScanRect:(CGRect)scanRect{
    
    _scanRect = scanRect;
    
    // 背景路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:0];
    
    // 镂空路径
    UIBezierPath *hollowOutPath = [UIBezierPath bezierPathWithRect:scanRect];
    [path appendPath:hollowOutPath];
    [path setUsesEvenOddFillRule:YES];
    
    // 镂空半透明遮罩层
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    // 设置路径
    fillLayer.path = path.CGPath;
    // 中间镂空的关键点 填充规则
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.6;
    [self.layer addSublayer:fillLayer];
    
    [self addSubview:self.borderView];
    [self.borderView addSubview:self.scanningLine];
    [self startMoveScanningLine];
}
- (void)startMoveScanningLine{
    
    CABasicAnimation *moveLineAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    moveLineAnimation.toValue = @(self.borderView.bounds.size.height-4);
    moveLineAnimation.duration = 2;
    moveLineAnimation.repeatCount = MAXFLOAT;
    [self.scanningLine.layer addAnimation:moveLineAnimation forKey:@"moveLineAnimation"];
}

- (void)stopMoveScanningLine{
    
    [self.scanningLine.layer removeAllAnimations];

}
- (void)dealloc{
    
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - getter
- (UIImageView *)borderView{
    
    if(!_borderView){
        
        _borderView = [[UIImageView alloc] initWithFrame:CGRectMake(self.scanRect.origin.x-2, self.scanRect.origin.y-2, self.scanRect.size.width+4, self.scanRect.size.height+4)];
        NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"border_scan_icon.png"];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        //第一个是左边不拉伸区域的宽度，第二个参数是上面不拉伸的高度。
        image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
        _borderView.image = image;
    }
    return _borderView;
}
- (UIImageView *)scanningLine{
    
    if(!_scanningLine){
        
        _scanningLine = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, self.borderView.bounds.size.width-4, 2)];
        NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"scan_line_image.png"];
        _scanningLine.image = [UIImage imageWithContentsOfFile:imagePath];
    }
    return _scanningLine;
}
@end
