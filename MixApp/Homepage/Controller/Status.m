//
//  Status.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/4/18.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "Status.h"

@implementation Status

/*
 
 字典转模型的方式一：KVC
 */
+ (instancetype)ststusWithDict:(NSDictionary *)dict {
    Status *status = [[Status alloc] init];
    [status setValuesForKeysWithDictionary:dict];
    return status;
}
/*
 KVC字典转模型弊端：必须保证，模型中的属性和字典中的key一一对应。
 如果不一致，就会调用[<Status 0x7fa74b545d60> setValue:forUndefinedKey:]
 报key找不到的错。
 分析:模型中的属性和字典的key不一一对应，系统就会调用setValue:forUndefinedKey:报错。
 解决:重写对象的setValue:forUndefinedKey:,把系统的方法覆盖，
 就能继续使用KVC，字典转模型了。
 
 */
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

/*
 
 字典转模型的方式二：Runtime
 思路：利用运行时，遍历模型中所有属性，根据模型的属性名，去字典中查找key，取出对应的值，给模型的属性赋值。
 步骤：提供一个NSObject分类，专门字典转模型，以后所有模型都可以通过这个分类转。
 
 */

- (void)runtimeMethod {
    //解析plist文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"status.plist" ofType:nil];
    NSDictionary *statusDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    //获取字典数组
    NSArray *dictArr = statusDict[@"statuses"];
    
    //自动生成模型的属性字符串
    [Status ststusWithDict:dictArr[0][@"user"]];
    
    
}



@end
