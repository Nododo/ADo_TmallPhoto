//
//  Ado_CameraCell.m
//  ADo_TmallPhotoAlbum
//
//  Created by 杜 维欣 on 15/5/19.
//  Copyright (c) 2015年 ADo. All rights reserved.
//

#import "Ado_CameraCell.h"
#import <AVFoundation/AVFoundation.h>


@interface Ado_CameraCell ()
@property (nonatomic,strong)AVCaptureSession *captureSession;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *prevLayer;
@end
@implementation Ado_CameraCell
- (instancetype)initWithFrame:(CGRect)frame
{
    NSLog(@"Ado_CameraCell");
    if (self = [super initWithFrame:frame]) {
        if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput
                                                  deviceInputWithDevice:[AVCaptureDevice
                                                                         defaultDeviceWithMediaType:AVMediaTypeVideo]  error:nil];
            self.captureSession = [[AVCaptureSession alloc] init];
            [self.captureSession addInput:captureInput];
            [self.captureSession startRunning];
            self.prevLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.captureSession];
            self.prevLayer.frame = self.bounds;
            self.prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            [self.layer addSublayer: self.prevLayer];
        }else
        {
            self.backgroundColor = [UIColor cyanColor];
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NSString *str = @"没有摄像头,怎么有效果?";
    /**
     *  此方法已被弃用
     */
    [str drawAtPoint:CGPointMake(0, 0) withFont:[UIFont systemFontOfSize:14]];
}

@end

