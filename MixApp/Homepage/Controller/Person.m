//
//  Person.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/4/18.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "Person.h"

@implementation Person

//void(*)()
//默认方法都有两个隐式参数
void eat(id self,SEL sel) {
    NSLog(@"%@ %@",self,NSStringFromSelector(sel));
}

//当一个对象调用未实现的方法,会调用这个方法处理，并且会把对应的方法列表传过来
//刚好可以用来判断，未实现的方法是不是我们想要动态添加的方法
//Dynamically provides an implementation for a given selector for an instance method
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(eat)) {
        //动态添加eat方法
        //第一个参数:给哪个类添加方法
        //第二个参数:添加方法的方法编号
        //第三个参数:添加方法的函数实现（函数地址）
        //第四个参数:函数的类型，(返回值+参数类型) v:void @:对象->self ：表示SEL->_cmd
        class_addMethod(self, @selector(eat), eat, "v@:");
    }
    return [super resolveInstanceMethod:sel];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _age = [aDecoder decodeIntegerForKey:@"age"];
        _sex = [aDecoder decodeObjectForKey:@"sex"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeInteger:_age forKey:@"age"];
    [aCoder encodeObject:_sex forKey:@"sex"];
}



@end
