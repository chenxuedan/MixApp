//
//  CXDHttpOperation.h
//  ThermodynamicSystem
//
//  Created by 陈雪丹 on 16/4/22.
//  Copyright © 2016年 chenxuedan. All rights reserved.
//  基础网络请求

#import <Foundation/Foundation.h>

@interface CXDHttpOperation : NSObject

typedef void (^successBlock)(_Nullable id responseObject);
typedef void (^failureBlock)(NSError * _Nullable error);

//typedef void (^ArrayBlock)(NSMutableArray *resultArray);

/**
 *
 *post请求的简单封装
 *  @param URLString  请求网址
 *  @param parameters 请求要传的参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
+ (void)postRequestWithUrl:(NSString * _Nullable)URLString parameters:(nullable id)parameters success:(_Nullable successBlock)success failure:(nullable failureBlock)failure;
/**
 *  get请求的简单封装
 *
 *  @param URLString  请求网址
 *  @param parameters 请求要传的参数
 *  @param success    请求成功回调
 *  @param failure    请求失败的回调
 */
+ (void)getRequestWithURL:(NSString * _Nullable)URLString parameters:(nullable id)parameters success:(nullable successBlock)success failure:(nullable failureBlock)failure;

@end
