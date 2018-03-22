//
//  CXDHttpOperation.m
//  ThermodynamicSystem
//
//  Created by 陈雪丹 on 16/4/22.
//  Copyright © 2016年 chenxuedan. All rights reserved.
//

#import "CXDHttpOperation.h"

@implementation CXDHttpOperation

+ (void)postRequestWithUrl:(NSString *)URLString parameters:(id)parameters success:(successBlock)success failure:(failureBlock)failure{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //1.1创建一个AFN管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的结果是json类型
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //1.2告诉manager只下载原始数据, 不要解析数据(一定要写)
    //AFN即可以下载网络数据, 又可以解析json数据,如果不写下面的  自动就解析json
    //由于做服务器的人返回json数据往往不规范, 凡是AFN又检查很严格,导致json解析往往失败
    //下面这句话的意思是 告诉AFN千万别解析, 只需要给我裸数据就可以
    //申明返回的结果是json类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (success) {
            success(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        NSLog(@"Error: %@",error.localizedDescription);
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getRequestWithURL:(NSString *)URLString parameters:(id)parameters success:(successBlock)success failure:(failureBlock)failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json", nil];
    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (success) {
            success(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
