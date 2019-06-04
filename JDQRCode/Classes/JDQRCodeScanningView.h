//
//  JDQRCodeScanningView.h
//  qrCode
//
//  Created by plan on 2018/5/23.
//  Copyright © 2018年 plan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDQRCodeScanningView : UIView

@property (nonatomic,assign) CGFloat timerInterval;
+ (instancetype)initScanningViewWithViewFreme:(CGRect)viewFrame scanRect:(CGRect)scanRect;
- (void)startMoveScanningLine;
- (void)stopMoveScanningLine;

@end
