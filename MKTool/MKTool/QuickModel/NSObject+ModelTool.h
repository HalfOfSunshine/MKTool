//
//  NSObject+ModelTool.h
//
//  Created by kkmm on 2020/2/20.
//  Copyright © 2020 qiu . All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ModelTool)

NSString * modelStringFrom (NSDictionary *dic);


/// 一键生成 model 内容   将返回的String直接复制到.h中即可。
/// @param dic 需要解析的dic 一般传入请求下来的list数组中的第一个元素即可
+(NSString *)modelStringFrom:(NSDictionary *)dic;

/// 解析四种基本数据类型 (BOOL NSInteger CGFloat double) 返回值示例： @"BOOL"
/// @param data 字典里对应的key值
+(NSString*)fromTypeToString:(id)data;


/// 根据wiki上写的文档来解析，通用性不大
/// @param str wiki上复制下来的字段与数据
+(NSArray *)stringToModelDefine:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
