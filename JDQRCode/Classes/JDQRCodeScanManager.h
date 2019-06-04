//
//  JDQRCodeScanManager.h
//  qrCode
//
//  Created by plan on 2018/5/23.
//  Copyright © 2018年 plan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class JDQRCodeScanManager;

@protocol PQRCodeScanManagerDelegate <NSObject>

@required
/** 二维码扫描获取数据的回调方法 (metadataObjects: 扫描二维码数据信息) */
- (void)qrCodeScanManagerDidOutputMetadataObjects:(NSArray *)metadataObjects;

@end
@interface JDQRCodeScanManager : NSObject

@property (nonatomic,weak) id<PQRCodeScanManagerDelegate>  delegate;

/**扫描单列*/
+ (instancetype)shareManager;
/**
 *  创建扫描二维码会话对象以及会话采集数据类型和扫码支持的编码格式的设置，必须实现的方法
 *
 *  @param sessionPreset          会话采集数据类型
 *  @param metadataObjectTypes    扫码支持的编码格式
 *  @param currentController      SGQRCodeScanManager 所在控制器
 *  @param scanRect               限制扫描区域
 */
- (void)setupSessionPreset:(NSString *)sessionPreset metadataObjectTypes:(NSArray *)metadataObjectTypes currentController:(UIViewController *)currentController scanRect:(CGRect)scanRect;

/**识别图片中的二维码*/
- (NSString *)discernQrcodeWithImage:(UIImage *)image;
- (void)startScanning;
- (void)stopScanning;
- (void)remove;
- (void)CameraScaleAction;
@end
