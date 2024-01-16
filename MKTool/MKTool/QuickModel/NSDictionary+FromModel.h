//
//  NSDictionary+FromModel.h
//  
//
//  Created by kkmm on 2020/4/16.
//  Copyright © 2020 qiu . All rights reserved.
//
//  来源：https://www.jianshu.com/p/8e340363ae8f

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (FromModel)
+ (NSDictionary *)dicFromObject:(NSObject *)object;
+ (NSDictionary *)dicWithObject:(id)object;
+ (NSArray *)arrayWithObject:(id)object;

@end

NS_ASSUME_NONNULL_END
