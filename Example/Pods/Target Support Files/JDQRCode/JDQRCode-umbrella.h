#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "JDQRCode.h"
#import "JDQRCodeGenerateManager.h"
#import "JDQRCodeScanManager.h"
#import "JDQRCodeScanningView.h"
#import "JDQRCodeTool.h"

FOUNDATION_EXPORT double JDQRCodeVersionNumber;
FOUNDATION_EXPORT const unsigned char JDQRCodeVersionString[];

