//
//  NSObject+Model.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/4/18.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "NSObject+Model.h"
#import "Status.h"

@implementation NSObject (Model)

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    //思路:遍历模型中所有属性-》使用运行时
    //0.创建对应的对象
    id objc = [[self alloc] init];
    
    //1.利用runtime给对象中的成员属性赋值
    // Ivar : runtime里面Ivar代表成员变量
    
    //count记录变量的数量
    unsigned int count = 0;
    //获取类中的所有成员属性
    Ivar *ivarList = class_copyIvarList([Status class], &count);
    
    for (int i = 0; i < count; i++) {
        //根据角标，从数组取出对应的成员属性
        Ivar ivar = ivarList[i];
        
        //获取成员属性名
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        NSLog(@"name  %@",name);
        
        Ivar keyName = ivarList[0];
        //修改属性变量的值
        object_setIvar(self, keyName, @"name");
        
        //处理成员属性名->字典中的key
        //从第一个角标开始截取
        NSString *key = [name substringFromIndex:1];
        
        //根据成员变量属性名去字典中查找对应的value
        id value = dict[key];
        
        //二级转换:如果字典中还有字典，也需要把对应的字典转换成模型
        //判断下value是否是字典
        if ([value isKindOfClass:[NSDictionary class]]) {
            //字典转模型
            //获取模型的类对象，调用modelWithDict
            //模型的类名已知，就是成员属性的类型
            //获取成员属性类型
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            //生成的是这种@"@\"User\""类型-》 @"User"  在OC字符串中 \" -> "，\是转义的意思，不占用字符
            //裁剪类型字符串
            NSRange range = [type rangeOfString:@"\""];
            type = [type substringFromIndex:range.location + range.length];
            range = [type rangeOfString:@"\""];
            
            //裁剪到哪个角标，不包括当前角标
            type = [type substringToIndex:range.location];
            
        }
        
    }
    return objc;
}

@end
