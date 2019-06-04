//
//  JDViewController.m
//  JDQRCode
//
//  Created by 13432414304@163.com on 05/31/2019.
//  Copyright (c) 2019 13432414304@163.com. All rights reserved.
//

#import "JDViewController.h"
#import "JDQRCode.h"

@interface JDViewController ()

@end

@implementation JDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    imageView.center = self.view.center;
//    [self.view addSubview:imageView];
    
//    imageView.image = [JDQRCodeGenerateManager generateQRCodeWithString:@"fsffd" imageWidth:200];
    
//    imageView.image = [JDQRCodeGenerateManager generateColorQRCodeWithString:@"fsdfadhadhasdjkfha" mainColor:[CIColor redColor] backgroundColor:[CIColor blueColor]];
    
//    imageView.image = [JDQRCodeGenerateManager generateLogoQRCodeWithString:@"fsfsdfdsfdsfs" logoImageName:@"WechatIMG61" logoScale:0.23];
    
    
    CGRect rect = CGRectMake((self.view.bounds.size.width-250)/2, (self.view.bounds.size.height-250)/2, 250, 250);

    JDQRCodeScanManager *manager = [JDQRCodeScanManager shareManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self scanRect:rect];

    // 扫描动画
    JDQRCodeScanningView *scanningView = [JDQRCodeScanningView initScanningViewWithViewFreme:self.view.bounds scanRect:rect];
    [self.view addSubview:scanningView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
