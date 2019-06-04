//
//  PQRCodeGenerateManager.h
//  qrCode
//
//  Created by plan on 2018/5/23.
//  Copyright © 2018年 plan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDQRCodeGenerateManager : NSObject

/**生成二维码*/
+ (UIImage *)generateQRCodeWithString:(NSString *)string imageWidth:(CGFloat)imageWidth;

/**生成彩色二维码*/
+ (UIImage *)generateColorQRCodeWithString:(NSString *)string backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor;

/**生成一张带有logo的二维码*/
+ (UIImage *)generateLogoQRCodeWithString:(NSString *)string logoImageName:(NSString *)logoImageName logoScale:(CGFloat)logoScale;

/**简单截屏生成图片*/
+ (UIImage *)makeScreenShotWithView:(UIView *)view;

@end
