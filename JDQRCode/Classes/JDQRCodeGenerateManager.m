//
//  JDQRCodeGenerateManager.m
//  qrCode
//
//  Created by plan on 2018/5/23.
//  Copyright © 2018年 plan. All rights reserved.
//

#import "JDQRCodeGenerateManager.h"

@implementation JDQRCodeGenerateManager

/**生成初始二维码*/
+ (CIImage *)generateQRCodeWithString:(NSString *)string{
    
    // 1.创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.初始化滤镜属性（滤镜可能保存上一次的属性）
    [filter setDefaults];
    // 3.字符串转换为NSData
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 4.设置滤镜inputMessage数据
    [filter setValue:stringData forKey:@"inputMessage"];
    // 5.通过滤镜输出图像
    CIImage *outputImage = [filter outputImage];
    
    return outputImage;
}
/**生成二维码*/
+ (UIImage *)generateQRCodeWithString:(NSString *)string imageWidth:(CGFloat)imageWidth{
    
    CIImage *outputImage = [self generateQRCodeWithString:string];
    // 6.当前生成的二维码很模糊，获取高清二维码图片
    UIImage *image = [self getErWeiMaImageFormCIImage:outputImage withSize:imageWidth];
    // 7.返回二维码图片
    return image;
}

/** 获取高清二维码图片*/
+ (UIImage *)getErWeiMaImageFormCIImage:(CIImage *)image withSize:(CGFloat)size{
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

/**生成彩色二维码*/
+ (UIImage *)generateColorQRCodeWithString:(NSString *)string mainColor:(CIColor *)mainColor backgroundColor:(CIColor *)backgroundColor{
    
    CIImage *outputImage = [self generateQRCodeWithString:string];
    
    // 6.图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(9, 9)];
    // 7.创建色彩过滤器
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    // 8.设置默认值
    [colorFilter setDefaults];
    // 9.kvc 复制
    [colorFilter setValue:outputImage forKey:@"inputImage"];
    // 10.设置二维码颜色
    [colorFilter setValue:mainColor forKey:@"inputColor0"];
    [colorFilter setValue:backgroundColor forKey:@"inputColor1"];
    // 11.输出图片
    CIImage *colorImage = [colorFilter outputImage];
    
    return [UIImage imageWithCIImage:colorImage];
}

/**生成带有logo的二维码*/
+ (UIImage *)generateLogoQRCodeWithString:(NSString *)string logoImageName:(NSString *)logoImageName logoScale:(CGFloat)logoScale{
    
    CIImage *outputImage = [self generateQRCodeWithString:string];
    // 6.图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    
    // 7.将CIImage类型转成UIImage类型
    UIImage *startImage = [UIImage imageWithCIImage:outputImage];
    
    // 8.添加logo
    // 8.1 开启绘图, 获取图形上下文
    UIGraphicsBeginImageContext(startImage.size);
    // 8.2 绘制二维码
    [startImage drawInRect:CGRectMake(0, 0, startImage.size.width, startImage.size.height)];
    // 8.3 计算logo frame
    UIImage *logoImage = [UIImage imageNamed:logoImageName];
    CGFloat logoW = startImage.size.width * logoScale;
    CGFloat logoH = startImage.size.height * logoScale;
    CGFloat logoX = (startImage.size.width - logoW) * 0.5;
    CGFloat logoY = (startImage.size.height - logoH) * 0.5;
    logoImage = [self image:logoImage withCornerRadius:25 bounds:CGRectMake(0, 0, logoW, logoH)];
    // 8.4 绘制logo白色圆角背景板
    UIImage *whiteImage = [self imageWithColor:[UIColor whiteColor] size:CGSizeMake(logoW+logoW/10, logoH+logoH/10)];
    whiteImage = [self image:whiteImage withCornerRadius:30 bounds:CGRectMake(0, 0, whiteImage.size.width, whiteImage.size.height)];
    [whiteImage drawInRect:CGRectMake((startImage.size.width-whiteImage.size.width)/2, (startImage.size.height-whiteImage.size.height)/2, whiteImage.size.width, whiteImage.size.height)];
    
    // 8.5 绘制logo
    [logoImage drawInRect:CGRectMake(logoX, logoY, logoW, logoH)];
    
    // 9.回去图片
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 10.关闭图像上下文
    UIGraphicsEndImageContext();
    
    return finalImage;
}

/**简单截屏生成图片*/
+ (UIImage *)makeScreenShotWithView:(UIView *)view{
    
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    //获取图片
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

/**使用贝塞尔曲线切割图片添加圆角*/
+ (UIImage *)image:(UIImage *)image withCornerRadius:(CGFloat)radius bounds:(CGRect)bounds{
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:radius] addClip];
    [image drawInRect:bounds];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    
    if(size.width == 0|| size.height == 0){
        size = CGSizeMake(10, 10);
    }
    // 描述圆形
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    // 矩形
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
