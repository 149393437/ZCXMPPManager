//
//  ZCZBarViewController.m
//  ZbarDemo
//
//  Created by ZhangCheng on 14-4-18.
//  Copyright (c) 2014年 ZhangCheng. All rights reserved.
//

#import "ZCZBarViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface ZCZBarViewController ()

@end

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height


@implementation ZCZBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithBlock:(void(^)(NSString*,BOOL))a{
    if (self=[super init]) {
        self.ScanResult=a;
        
    }
    
    return self;
}
-(void)createView{
    
//qrcode_scan_bg_Green_iphone5@2x.png  qrcode_scan_bg_Green@2x.png
    UIImage*image= [UIImage imageNamed:@"qrcode_scan_bg_Green@2x.png"];
    float capWidth=image.size.width/2;
    float capHeight=image.size.height/2;
    
    image=[image stretchableImageWithLeftCapWidth:capWidth topCapHeight:capHeight];
    UIImageView* bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    //bgImageView.contentMode=UIViewContentModeTop;
    bgImageView.clipsToBounds=YES;
    bgImageView.image=image;
    bgImageView.userInteractionEnabled=YES;
    [self.view addSubview:bgImageView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, bgImageView.frame.size.height-140, WIDTH, 40)];
    label.text = @"将取景框对准二维码，即可自动扫描。";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 2;
    label.font=[UIFont systemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    [bgImageView addSubview:label];
    

    
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH-220)/2, 70, 220, 2)];
    _line.image = [UIImage imageNamed:@"qrcode_scan_light_green.png"];
    [bgImageView addSubview:_line];
   
    
  //下方相册
    UIImageView*scanImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, HEIGHT-100, WIDTH, 100)];
    scanImageView.image=[UIImage imageNamed:@"qrcode_scan_bar.png"];
    scanImageView.userInteractionEnabled=YES;
    [self.view addSubview:scanImageView];
    NSArray*unSelectImageNames=@[@"qrcode_scan_btn_photo_nor.png",@"qrcode_scan_btn_flash_nor.png",@"qrcode_scan_btn_myqrcode_nor.png"];
    NSArray*selectImageNames=@[@"qrcode_scan_btn_photo_down.png",@"qrcode_scan_btn_flash_down.png",@"qrcode_scan_btn_myqrcode_down.png"];
    
    for (int i=0; i<unSelectImageNames.count; i++) {
        UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:unSelectImageNames[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selectImageNames[i]] forState:UIControlStateHighlighted];
        button.frame=CGRectMake(WIDTH/3*i, 0, WIDTH/3, 100);
        [scanImageView addSubview:button];
        if (i==0) {
            [button addTarget:self action:@selector(pressPhotoLibraryButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i==1) {
            [button addTarget:self action:@selector(flashLightClick) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i==2) {
            button.hidden=YES;
        }
        
    }
    
    
    //假导航
    UIImageView*navImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    navImageView.image=[UIImage imageNamed:@"qrcode_scan_bar.png"];
    navImageView.userInteractionEnabled=YES;
    [self.view addSubview:navImageView];
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-32,20 , 64, 44)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.text=@"扫一扫";
    [navImageView addSubview:titleLabel];
    
  
    
    UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_pressed@2x.png"] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_nor.png"] forState:UIControlStateNormal];

    
    [button setFrame:CGRectMake(10,10, 48, 48)];
    [button addTarget:self action:@selector(pressCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

   timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

-(void)animation1
{

    [UIView animateWithDuration:2 animations:^{
        
         _line.frame = CGRectMake((WIDTH-220)/2, 70+HEIGHT-310, 220, 2);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:2 animations:^{
          _line.frame = CGRectMake((WIDTH-220)/2, 70, 220, 2);
        }];
    
    }];
    
}
//开启关闭闪光灯
-(void)flashLightClick{
 AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (device.torchMode==AVCaptureTorchModeOff) {
        //闪光灯开启
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];
        
    }else {
        //闪光灯关闭
        
        [device setTorchMode:AVCaptureTorchModeOff];
    }

}

- (void)viewDidLoad
{
  
    //相机界面的定制在self.view上加载即可
    BOOL Custom= [UIImagePickerController
                  isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];//判断摄像头是否能用
    if (Custom) {
        [self initCapture];//启动摄像头
    }else{
        self.view.backgroundColor=[UIColor whiteColor];
    }
    [super viewDidLoad];
    [self createView];

    
    
}
#pragma mark 选择相册
- (void)pressPhotoLibraryButton:(UIButton *)button
{  if (timer) {
    [timer invalidate];
    timer=nil;
}
    _line.frame = CGRectMake((WIDTH-220)/2, 70, 220, 2);
    num = 0;
    upOrdown = NO;
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:^{
        self.isScanning = NO;
        [self.captureSession stopRunning];
    }];
}
#pragma mark 点击取消
- (void)pressCancelButton:(UIButton *)button
{
    self.isScanning = NO;
    [self.captureSession stopRunning];
    
    self.ScanResult(nil,NO);
    if (timer) {
        [timer invalidate];
        timer=nil;
    }
    _line.frame = CGRectMake((WIDTH-220)/2, 70, 220, 2);
    num = 0;
    upOrdown = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 开启相机
- (void)initCapture
{
    self.captureSession = [[AVCaptureSession alloc] init];
    
    AVCaptureDevice* inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    [self.captureSession addInput:captureInput];
    
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    
    
    if (IOS7) {
        AVCaptureMetadataOutput*_output=[[AVCaptureMetadataOutput alloc]init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
        [self.captureSession addOutput:_output];
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
        
        if (!self.captureVideoPreviewLayer) {
            self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        }
        // NSLog(@"prev %p %@", self.prevLayer, self.prevLayer);
        self.captureVideoPreviewLayer.frame = self.view.bounds;
        self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer addSublayer: self.captureVideoPreviewLayer];
        
        self.isScanning = YES;
        [self.captureSession startRunning];
        
        
    }else{
        [captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        
        NSString* key = (NSString *)kCVPixelBufferPixelFormatTypeKey;
        NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
        NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
        [captureOutput setVideoSettings:videoSettings];
        [self.captureSession addOutput:captureOutput];
        
        NSString* preset = 0;
        if (NSClassFromString(@"NSOrderedSet") && // Proxy for "is this iOS 5" ...
            [UIScreen mainScreen].scale > 1 &&
            [inputDevice
             supportsAVCaptureSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
                // NSLog(@"960");
                preset = AVCaptureSessionPresetiFrame960x540;
            }
        if (!preset) {
            // NSLog(@"MED");
            preset = AVCaptureSessionPresetMedium;
        }
        self.captureSession.sessionPreset = preset;
        
        if (!self.captureVideoPreviewLayer) {
            self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        }
        // NSLog(@"prev %p %@", self.prevLayer, self.prevLayer);
        self.captureVideoPreviewLayer.frame = self.view.bounds;
        self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer addSublayer: self.captureVideoPreviewLayer];
        
        self.isScanning = YES;
        [self.captureSession startRunning];
        
        
    }
    
    
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace)
    {
        NSLog(@"CGColorSpaceCreateDeviceRGB failure");
        return nil;
    }
    
    // Get the base address of the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // Get the data size for contiguous planes of the pixel buffer.
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    
    // Create a Quartz direct-access data provider that uses data we supply
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize,
                                                              NULL);
    // Create a bitmap image from data supplied by our data provider
    CGImageRef cgImage =
    CGImageCreate(width,
                  height,
                  8,
                  32,
                  bytesPerRow,
                  colorSpace,
                  kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little,
                  provider,
                  NULL,
                  true,
                  kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    // Create and return an image object representing the specified Quartz image
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    
    return image;
}

#pragma mark 对图像进行解码
- (void)decodeImage:(UIImage *)image
{
    
    self.isScanning = NO;
    ZBarSymbol *symbol = nil;
    
    ZBarReaderController* read = [ZBarReaderController new];
    
    read.readerDelegate = self;
    
    CGImageRef cgImageRef = image.CGImage;
    
    for(symbol in [read scanImage:cgImageRef])break;
    
    if (symbol!=nil) {
        if (timer) {
            [timer invalidate];
            timer=nil;
        }
        
        _line.frame = CGRectMake((WIDTH-220)/2, 70, 220, 2);
        num = 0;
        upOrdown = NO;
        self.ScanResult(symbol.data,YES);
        [self.captureSession stopRunning];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
        num = 0;
        upOrdown = NO;
        self.isScanning = YES;
        [self.captureSession startRunning];

    }
    
    
    
}
#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    
    [self decodeImage:image];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate//IOS7下触发
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    
    if (metadataObjects.count>0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        self.ScanResult(metadataObject.stringValue,YES);
    }
    
    [self.captureSession stopRunning];
    _line.frame = CGRectMake((WIDTH-220)/2, 70, 220, 2);
    num = 0;
    upOrdown = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}



#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (timer) {
        [timer invalidate];
        timer=nil;
    }
    _line.frame = CGRectMake((WIDTH-220)/2, 70, 220, 2);
    num = 0;
    upOrdown = NO;
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:^{[self decodeImage:image];}];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (timer) {
        [timer invalidate];
        timer=nil;
    }
    _line.frame = CGRectMake((WIDTH-220)/2, 70, 220, 2);
    num = 0;
    upOrdown = NO;
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        self.isScanning = YES;
        [self.captureSession startRunning];
    }];
}

#pragma mark - DecoderDelegate



+(NSString*)zhengze:(NSString*)str
{
    
    NSError *error;
    //http+:[^\\s]* 这是检测网址的正则表达式
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http+:[^\\s]*" options:0 error:&error];//筛选
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            //从urlString中截取数据
            NSString *result1 = [str substringWithRange:resultRange];
            NSLog(@"正则表达后的结果%@",result1);
            return result1;
            
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
