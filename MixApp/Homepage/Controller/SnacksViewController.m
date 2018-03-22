//
//  SnacksViewController.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/31.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "SnacksViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "CustomTableCell.h"

@interface SnacksViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>
//显示相册选择的图片
@property (nonatomic, strong)UIButton *pickPhotoBtn;
//显示拍照选择的图片
@property (nonatomic, strong)UIImageView *photoImageView;
@property (nonatomic, strong)UIImagePickerController *imagePickerController;

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation SnacksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"零食";
//    [self buildUI];
    
    UISearchBar *search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
//    self.navigationItem.titleView = search;
    [self.view addSubview:search];
    [self.view addSubview:self.tableView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDidClicked)];
    tapGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGesture];
}

- (void)tapGestureDidClicked {
    [self.view endEditing:YES];
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CustomTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CustomTableCell class])];
    }
    return _tableView;
}

#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CustomTableCell class])];
    [cell.textBtn addTarget:self action:@selector(textBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)textBtnDidClicked {
    NSLog(@"点击了");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%ld行cell被点击了",indexPath.row);
}

- (void)buildUI {
    [self.view addSubview:self.pickPhotoBtn];
    [self.view addSubview:self.photoImageView];
}

#pragma mark - 相应事件
- (void)pickPhotoBtnClick {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takeCameraPhoto];
    }];
    
    UIAlertAction *photoAlbum = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoAlbum];
    }];
    
    UIAlertAction *recordVideo = [UIAlertAction actionWithTitle:@"视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self recordVideo];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:takePhoto];
    [alertController addAction:photoAlbum];
    [alertController addAction:recordVideo];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
//录制视频
- (void)recordVideo {
    //有无权限打开摄像头
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS8) {
        //无权限 做一个友好的提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self setSystemPermission];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:setAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else {//调用相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            if (iOS8) {
                _imagePickerController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            //录制视频时长，默认10s
            _imagePickerController.videoMaximumDuration = 15;
            //相机类型（拍照、录像...）字符串需要做相应的类型转换
            _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
            //视频上传质量
            //UIImagePickerControllerQualityTypeHigh 高清
            //UIImagePickerControllerQualityTypeMedium  中等质量
            //UIImagePickerControllerQualityTypeLow    低质量
            //UIImagePickerControllerQualityType640x480
            _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
            //设置摄像头模式（拍照，录制视频）为录像模式
            _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            //    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        }else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

//关于编辑照片界面的英文，可以在info.plist设置Localized resources can be mixed 的值为YES就可以转换为你当前系统的语言。
//从摄像头获取图片
- (void)takeCameraPhoto {
    //有无权限打开摄像头
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS8) {
        //无权限 做一个友好的提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self setSystemPermission];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:setAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else {//调用相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            if (iOS8) {
                _imagePickerController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            //相机类型（拍照、录像...）字符串需要做相应的类型转换
            _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
            //设置摄像头模式（拍照，录制视频）为拍照模式
            _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        }else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}
//打开相册
- (void)takePhotoAlbum {
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

//去设置界面，开启相机访问权限
- (void)setSystemPermission {
    if (iOS8) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}
#pragma mark - 懒加载
- (UIButton *)pickPhotoBtn {
    if (!_pickPhotoBtn) {
        _pickPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _pickPhotoBtn.frame = CGRectMake(100, 100, 60, 60);
        [_pickPhotoBtn setImage:[UIImage imageNamed:@"AddPhotoLarger"] forState:UIControlStateNormal];
        [_pickPhotoBtn addTarget:self action:@selector(pickPhotoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pickPhotoBtn;
}

/**
 *   UIImagePickerControllerSourceTypePhotoLibrary,//来自图库
 *   UIImagePickerControllerSourceTypeCamera,      //来自相机
 *   UIImagePickerControllerSourceTypeSavedPhotosAlbum //来自相册
 **/

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        //设置选取的照片是否可编辑
        _imagePickerController.allowsEditing = YES;
        //设置相册呈现的样式
//        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//来自图库
        //照片的选取样式还有以下两种
        //UIImagePickerControllerSourceTypeCamera,调取摄像头
        //UIImagePickerControllerSourceTypeSavedPhotosAlbum 直接全部呈现系统相册
        //选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
        _imagePickerController.delegate = self;

    }
    return _imagePickerController;
}

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 300, 200, 200)];
    }
    return _photoImageView;
}

#pragma mark - 代理
//选择照片视频完成之后的代理
//适用获取所有的媒体资源，只需判断资源类型
//UIImagePickerControllerEditedImage 编辑过的图片 获取图片裁剪的图
//UIImagePickerControllerOriginalImage 照片的原图
//UIImagePickerControllerCropRect  获取图片裁剪后，剩下的图
//UIImagePickerControllerMediaURL  获取图片的url
//UIImagePickerControllerMediaMetadata  获取图片的metadata数据信息
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //info是所选照片的信息
    NSLog(@"info  %@",info);
    /*
     *  通过UIImagePickerControllerMediaType判断返回的是照片还是视频
     *
     */
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    /*
     *  如果返回的type等于kUTTypeImage,代表返回的是照片，并且需要判断当前相机使用的
     *  sourceType是拍照还是相册
     */
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage] && picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {//如果是相册图片
        UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];

        //上传图片
        
        [_pickPhotoBtn setImage:resultImage forState:UIControlStateNormal];

    }else if ([mediaType isEqualToString:(NSString *)kUTTypeImage] && picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];

        [_photoImageView setImage:resultImage];
        //压缩图片
        NSData *fileData = UIImageJPEGRepresentation(resultImage, 1.0);
        
        //保存图片至相册
        //如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
        UIImageWriteToSavedPhotosAlbum(resultImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie] && picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];
        //播放视频
        NSLog(@"选取的视频");
        NSData *videoData = [NSData dataWithContentsOfURL:url];
        //视频上传
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie] && picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];
        //播放视频
        
        //保存视频到相册 (异步线程)
        //UIVideoAtPathIsCompatibleWithSavedPhotosAlbum会返回布尔类型的值判断该路径下的视频能否保存到相册，视频需要先存储到沙盒文件在保存到相册，而照片是可以直接从代理完成的回调info字典里面获取到。
        NSString *urlStr = [url path];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }
        });
        NSData *videoData = [NSData dataWithContentsOfURL:url];
        //视频上传
    }
    
    //使用模态跳转回到软件界面
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 图片保存完毕的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *) error contextInfo:(void *)contextInf{
    
}

#pragma mark 视频保存完毕的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
        
    }
}


//点击取消按钮所执行的方法
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    //这是捕获点击右上角cancel按钮所触发的事件，如果我们需要在点击cancel按钮的时候做一些其他逻辑操作。就需要实现该代理方法，如果不做任何逻辑操作，就可以不实现
//}


@end
