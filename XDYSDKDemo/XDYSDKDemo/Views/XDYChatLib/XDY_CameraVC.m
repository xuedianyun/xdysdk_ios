//
//  XDY_CameraVC.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/7/23.
//  Copyright © 2017年 liyanyan. All rights reserved.
//


#import "XDY_CameraVC.h"

@interface XDY_CameraVC ()<UIImagePickerControllerDelegate , UINavigationControllerDelegate>{
    UIImagePickerController   *  _cameraVC;
}

@end

@implementation XDY_CameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData{
    _cameraVC = [[UIImagePickerController alloc]init];
    _cameraVC.delegate = self;
    _cameraVC.allowsEditing = YES;
    _cameraVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    _cameraVC.view.frame = [UIScreen mainScreen].bounds;
    
    [self.view addSubview:_cameraVC.view];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    __weak  typeof(self)  sf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if(image != nil){
            if(_delegate && [_delegate respondsToSelector:@selector(XDYCameraVC:didSelectedPhoto:)]){
                [_delegate XDYCameraVC:sf didSelectedPhoto:image];
            }
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage  * image = info[@"UIImagePickerControllerOriginalImage"];
    __weak  typeof(self)  sf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if(image != nil){
            if(_delegate && [_delegate respondsToSelector:@selector(XDYCameraVC:didSelectedPhoto:)]){
                [_delegate XDYCameraVC:sf didSelectedPhoto:image];
            }
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if (_delegate && [_delegate respondsToSelector:@selector(XDYCameraCancel)]) {
        [_delegate XDYCameraCancel];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
