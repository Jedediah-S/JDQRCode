//
//  JDQRCodeScanManager.m
//  qrCode
//
//  Created by plan on 2018/5/23.
//  Copyright © 2018年 plan. All rights reserved.
//

#import "JDQRCodeScanManager.h"

// 屏幕宽度
#define screen_width [UIScreen mainScreen].bounds.size.width
// 屏幕高度
#define screen_height [UIScreen mainScreen].bounds.size.height

@interface JDQRCodeScanManager ()<AVCaptureMetadataOutputObjectsDelegate>


/** 捕捉会话 */
@property (nonatomic, weak) AVCaptureSession *session;
/** 预览图层 */
@property (nonatomic, weak) AVCaptureVideoPreviewLayer *previewLayer;
/** 输入设备 */
@property (nonatomic,weak) AVCaptureDeviceInput *input;
/** 输出设备 */
@property (nonatomic,weak) AVCaptureMetadataOutput *output;

@property (nonatomic,assign) CGFloat kCameraScale;
@end

@implementation JDQRCodeScanManager

static JDQRCodeScanManager *_instance;

/**扫描单列*/
+ (instancetype)shareManager{
    
    if(!_instance){
        _instance = [[JDQRCodeScanManager alloc] init];
        _instance.kCameraScale = 1.0;
    }
//    只创建一次
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _instance = [[PQRCodeScanManager alloc] init];
//    });
    return _instance;
}

- (void)setupSessionPreset:(NSString *)sessionPreset metadataObjectTypes:(NSArray *)metadataObjectTypes currentController:(UIViewController *)currentController scanRect:(CGRect)scanRect{
    
    CGFloat viewHeight = screen_height;
    CGFloat viewWidth = screen_width;
    // 坐标体系不同、转换坐标
    CGRect rectOfInterest = CGRectMake(scanRect.origin.y/viewHeight, scanRect.origin.x/viewWidth, scanRect.size.height/viewHeight, scanRect.size.width/viewWidth);
    
    // 1.创建捕捉会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetHigh;
    self.session = session;
    
    // 2.添加输入设备(从相机输入)
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [session addInput:input];
    self.input = input;
    
    // 3.添加输出数据接口
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 设置输出接口代理
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // 设置扫描限制区域
    output.rectOfInterest = rectOfInterest;
    [session addOutput:output];
    // 3.1 设置输入元数据的类型(类型是二维码数据) 注意，这里必须设置在addOutput后面，否则会报错
    [output setMetadataObjectTypes:metadataObjectTypes];
    self.output = output;
    
    // 4.添加扫描图层
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    // 保持纵横比；填充层边界
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = currentController.view.bounds;
    [currentController.view.layer insertSublayer:previewLayer atIndex:0];
    self.previewLayer = previewLayer;
    
    // 5.开始扫描
    [self startScanning];
}

/**识别图片中的二维码*/
- (NSString *)discernQrcodeWithImage:(UIImage *)image{
    
    if(image == nil) return @"图片不能为空";
    //1. 初始化扫描仪，设置设别类型和识别质量
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    //2. 扫描获取的特征组
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    
    if(features.count){
        //3. 获取扫描结果
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *scannedResult = feature.messageString;
        return scannedResult;
    }
    
    return @"未找到二维码";
}

- (void)startScanning{
    
    [self.session startRunning];
}

- (void)stopScanning{
    
    [self.session stopRunning];
}
- (void)remove{
    
    _instance = nil;
}
- (void)dealloc{
    
    NSLog(@"%s",__func__);
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate 扫描结果
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if([self.delegate respondsToSelector:@selector(qrCodeScanManagerDidOutputMetadataObjects:)]){
        [self.delegate qrCodeScanManagerDidOutputMetadataObjects:metadataObjects];
    }
    // 扫描到了数据
    if(metadataObjects.count){
        
        // 停止扫描
        [self stopScanning];
        
        AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
        NSLog(@"stringValue : %@",object.stringValue);
        
        
    }else{
        NSLog(@"没有扫描到数据");
    }
}

#pragma mark -  焦距
- (void)CameraScaleAction{
    
    self.kCameraScale+=0.5;
    
    if(self.kCameraScale>2.5)
        
         self.kCameraScale=1.0;
    
    //改变焦距   记住这里的输出链接类型要选中这个类型，否则屏幕会花的
    AVCaptureConnection *connect=[self.output connectionWithMediaType:AVMediaTypeVideo];
    
    [CATransaction begin];
    
    [CATransaction setAnimationDuration:0.2];
        
    //主要是改变相机图层的大小
    
    [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.kCameraScale, self.kCameraScale)];
    
    connect.videoScaleAndCropFactor= self.kCameraScale;
    
    [CATransaction commit];
    
    //超出的部分切掉,否则影响扫描效果
    
//    self.clipsToBounds=YES;
//
//    self.layer.masksToBounds=YES;
    
}

@end
