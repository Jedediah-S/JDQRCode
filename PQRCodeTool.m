//
//  PQRCodeTool.m
//  qrCode
//
//  Created by plan on 2018/5/28.
//  Copyright © 2018年 plan. All rights reserved.
//

#import "PQRCodeTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation PQRCodeTool

// 打开手电筒
+ (void)openFlashlight{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    if([device hasTorch]){
        BOOL locked = [device lockForConfiguration:&error];
        if(locked){
            device.torchMode = AVCaptureTorchModeOn;
            [device unlockForConfiguration];
        }
    }
}

// 关闭手电筒
+ (void)closeFlaselight{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if([device hasTorch]){
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
}
@end
