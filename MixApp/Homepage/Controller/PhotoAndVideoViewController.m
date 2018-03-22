//
//  PhotoAndVideoViewController.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/4/1.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "PhotoAndVideoViewController.h"
#import <Photos/Photos.h>
#import "CXDAlbumModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CXDAssetModel.h"

@interface PhotoAndVideoViewController ()

@property (nonatomic, strong)UIImageView *photoImageView;

@end

@implementation PhotoAndVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.photoImageView];
}

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        _photoImageView.frame = CGRectMake(20, 100, 100, 100);
    }
    return _photoImageView;
}


- (void)getCameraRollAlbum {
    CXDAlbumModel *model;
    //是否按创建时间排序
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    //对照片排序，按修改时间升序
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:YES]];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",PHAssetMediaTypeImage];
    //所有智能相册  所有照片
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];

    for (PHAssetCollection *collection in smartAlbums) {
        if ([collection.localizedTitle isEqualToString:@"Camera Roll"] || [collection.localizedTitle isEqualToString:@"相机胶卷"] || [collection.localizedTitle isEqualToString:@"所有照片"] || [collection.localizedTitle isEqualToString:@"All Photos"]) {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            NSLog(@"fetchResult  %@",fetchResult);
            model = [self modelWithResult:fetchResult name:collection.localizedTitle];
            break;
        }
    }
}

- (void)getAllAlbums {
    NSMutableArray *albumArr = [NSMutableArray array];
    if (iOS8) {
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:YES]];
        PHAssetCollectionSubtype smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumVideos;
        if (iOS9) {
            smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumScreenshots | PHAssetCollectionSubtypeSmartAlbumSelfPortraits | PHAssetCollectionSubtypeSmartAlbumVideos ;
        }
        /*
         *PHAssetCollectionTypeSmartAlbum  对应的为系统相册里面的文件
         * PHAssetCollectionTypeAlbum  用户自定义的相册
         */
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:smartAlbumSubtype options:nil];
        for (PHAssetCollection *collection in smartAlbums) {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count < 1) continue;
            if ([collection.localizedTitle containsString:@"Deleted"] || [collection.localizedTitle isEqualToString:@"最近删除"]) continue;
            if ([collection.localizedTitle isEqualToString:@"Camera Roll"] || [collection.localizedTitle isEqualToString:@"相机胶卷"]) {
                [albumArr insertObject:[self modelWithResult:fetchResult name:collection.localizedTitle] atIndex:0];
            }else {
                [albumArr addObject:[self modelWithResult:fetchResult name:collection.localizedTitle]];
            }
        }
        
        PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular | PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
        for (PHAssetCollection *collection in albums) {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count < 1) continue;
            if ([collection.localizedTitle isEqualToString:@"My Photo Stream"] || [collection.localizedTitle isEqualToString:@"我的照片流"]) {
                [albumArr insertObject:[self modelWithResult:fetchResult name:collection.localizedTitle] atIndex:1];
            }else {
                [albumArr addObject:[self modelWithResult:fetchResult name:collection.localizedTitle]];
            }
        }
        
    }
}

- (void)getAssetFromFetchResult:(id)result {
    NSMutableArray *photoArray = [NSMutableArray array];
    if ([result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAsset *asset = (PHAsset *)obj;
            NSString *timeLength;
            if (asset.mediaType == PHAssetMediaTypeVideo) {
                timeLength = [NSString stringWithFormat:@"%0.0f",asset.duration];
            }else if (asset.mediaType == PHAssetMediaTypeAudio) {
                timeLength = @"";
            }else if (asset.mediaType == PHAssetMediaTypeImage) {
                timeLength = @"";
            }
            timeLength = [self getNewTimeFromDurationSecond:timeLength.integerValue];
            [photoArray addObject:[CXDAssetModel modelWithAsset:asset timeLength:timeLength]];
        }];
    }
}

- (NSString *)getNewTimeFromDurationSecond:(NSInteger)duration {
    NSString *newTime;
    if (duration < 10) {
        newTime = [NSString stringWithFormat:@"0:0%zd",duration];
    }else if (duration < 60) {
        newTime = [NSString stringWithFormat:@"0:%zd",duration];
    }else {
        NSInteger min = duration / 60;
        NSInteger sec = duration - (min * 60);
        if (sec < 10) {
            newTime = [NSString stringWithFormat:@"%zd:0%zd",min,sec];
        }else {
            newTime = [NSString stringWithFormat:@"%zd:%zd",min,sec];
        }
    }
    return newTime;
}

- (CXDAlbumModel *)modelWithResult:(id)result name:(NSString *)name {
    CXDAlbumModel *model = [[CXDAlbumModel alloc] init];
    model.result = result;
    model.name = [self getNewAlbumName:name];
    if ([result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        model.count = fetchResult.count;
    }else if ([result isKindOfClass:[ALAssetsGroup class]]) {
        ALAssetsGroup *group = (ALAssetsGroup *)result;
        model.count = [group numberOfAssets];
    }
    return model;
}

- (NSString *)getNewAlbumName:(NSString *)name {
    if (iOS8) {
        NSString *newName;
        if ([name rangeOfString:@"Roll"].location != NSNotFound)         newName = @"相机胶卷";
        else if ([name rangeOfString:@"Stream"].location != NSNotFound)  newName = @"我的照片流";
        else if ([name rangeOfString:@"Added"].location != NSNotFound)   newName = @"最近添加";
        else if ([name rangeOfString:@"Selfies"].location != NSNotFound) newName = @"自拍";
        else if ([name rangeOfString:@"shots"].location != NSNotFound)   newName = @"截屏";
        else if ([name rangeOfString:@"Videos"].location != NSNotFound)  newName = @"视频";
        else if ([name rangeOfString:@"Panoramas"].location != NSNotFound)  newName = @"全景照片";
        else if ([name rangeOfString:@"Favorites"].location != NSNotFound)  newName = @"个人收藏";
        else newName = name;
        return newName;
    }else {
        return name;
    }
}

#pragma mark - 获取相册里的所有图片的PHAsset对象
- (NSArray *)getAllPhotosAssetInAblumCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending {
    
    //    for (NSInteger i = 0; i < smartAlbums.count; i++) {
    //        PHCollection *collection = smartAlbums[i];
    //        //遍历获取相册
    //        if ([collection isKindOfClass:[PHAssetCollection class]]) {
    //            if ([collection.localizedTitle isEqualToString:@"相机胶卷"]) {
    //                PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
    //                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    //                NSArray *assets;
    //                if (fetchResult.count > 0) {
    //                    //某个相册里面的所有PHAsset对象
    //                    assets = [self getAllPhotosAssetInAblumCollection:assetCollection ascending:YES];
    //                    NSLog(@"assets  %@",assets);
    //                    [arr addObjectsFromArray:assets];
    //                }
    //            }
    //        }
    //    }
    //返回相机胶卷内的所有照片

    //存放所有图片对象
    NSMutableArray *assets = [NSMutableArray array];
    //是否按创建时间排序
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",PHAssetMediaTypeImage];
    //获取所有图片对象
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    //遍历
    [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        [assets addObject:asset];
    }];
    return assets;
}

#pragma mark - 根据PHAsset获取图片信息
- (void)accessToImageAccordingToTheAsset:(PHAsset *)asset size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void(^)(UIImage *image,NSDictionary *info))completion {
    static PHImageRequestID requestID = -2;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat width = MIN([UIScreen mainScreen].bounds.size.width, 500);
    if (requestID >= 1 && size.width / width == scale) {
        [[PHCachingImageManager defaultManager] cancelImageRequest:requestID];
    }
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
//    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.resizeMode = resizeMode;
    requestID = [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(result,info);
        });
    }];
}


@end
