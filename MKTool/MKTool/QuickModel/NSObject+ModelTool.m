//
//  NSObject+ModelTool.m
//  
//
//  Created by kkmm on 2020/2/20.
//  Copyright © 2020 qiu . All rights reserved.
//

#import "NSObject+ModelTool.h"
#import "NSString+Exist.h"


@implementation NSObject (ModelTool)
NSString * modelStringFrom (NSDictionary *dic){
    return [NSObject modelStringFrom:dic];
}

+(NSString *)modelStringFrom:(NSDictionary *)dic{
#ifdef DEBUG
    if ([dic isKindOfClass:[NSArray class]]) {
        NSArray *tempArr = (NSArray *)[dic copy];
        dic = tempArr.firstObject;
    }
	NSMutableArray *resultArray = [NSMutableArray array];
	NSArray *keysArr = [dic allKeys];
	for (int i=0; i<keysArr.count; i++) {
        if ([[dic valueForKey:keysArr[i]] isKindOfClass:[NSString class]]) {
            [resultArray addObject:[NSString stringWithFormat:@"/** %@ */\n@property (nonatomic,strong) NSString *%@;",[dic valueForKey:keysArr[i]],keysArr[i]]];
        }else if ([[dic valueForKey:keysArr[i]] isKindOfClass:[NSDictionary class]]) {
            // 二次解析 chileModelStringFrom:
            [resultArray addObject:[NSString stringWithFormat:@"@property (nonatomic,strong) <++childName_%@++> *%@; \n // @interface <++childName_%@++> : NSObject\n %@ \n // @end \n ",keysArr[i],keysArr[i],keysArr[i],[NSObject subModelStringFrom:[dic valueForKey:keysArr[i]]]]];
        }else if ([[dic valueForKey:keysArr[i]] isKindOfClass:[NSArray class]]) {
            [resultArray addObject:[NSString stringWithFormat:@"/** %@ */\n@property (nonatomic,strong) NSArray *%@;",[dic valueForKey:keysArr[i]],keysArr[i]]];
        }else{
            NSString *typeStr = [NSObject fromTypeToString:[dic valueForKey:keysArr[i]]];
            if ([typeStr exist]) {
                [resultArray addObject:[NSString stringWithFormat:@" /** %@ */\n@property (nonatomic,assign) %@ %@;",[dic valueForKey:keysArr[i]],typeStr,keysArr[i]]];
            }else{
                //默认用NSString
                [resultArray addObject:[NSString stringWithFormat:@"/** %@ */\n@property (nonatomic,strong) NSString *%@;",[dic valueForKey:keysArr[i]],keysArr[i]]];
            }
        }
	}
    NSString *allStr = @"//====复制以下内容到对应model.h里，配合YYModel使用。注意检查系统冲突字段(id,description等)====\n\n";
    for (NSString *str in resultArray) {
      allStr = [allStr stringByAppendingFormat:@"\n%@\n",str];
    }
    allStr = [allStr stringByAppendingFormat:@"%@\n",@"\n\n//====复制以上内容到对应model.h里，配合YYModel使用。注意检查系统冲突字段(id,description等)===="];
    allStr = [allStr stringByReplacingOccurrencesOfString:@"<++" withString:@"<#"];
    allStr = [allStr stringByReplacingOccurrencesOfString:@"++>" withString:@"#>"];
    allStr = [allStr stringByReplacingOccurrencesOfString:@" /**  */" withString:@""];

    NSLog(@"%@",allStr);
	return allStr;
#else
    return @"仅debug模式可用";
#endif
}

+(NSString *)subModelStringFrom:(NSDictionary *)dic{
    NSMutableArray *resultArray = [NSMutableArray array];
    NSArray *keysArr = [dic allKeys];
    for (int i=0; i<keysArr.count; i++) {
        if ([[dic valueForKey:keysArr[i]] isKindOfClass:[NSString class]]) {
            [resultArray addObject:[NSString stringWithFormat:@"/** %@ */\n@property (nonatomic,strong) NSString *%@;",[dic valueForKey:keysArr[i]],keysArr[i]]];
        }else if ([[dic valueForKey:keysArr[i]] isKindOfClass:[NSDictionary class]]) {
            // 二次解析 chileModelStringFrom:
            [resultArray addObject:[NSString stringWithFormat:@"@property (nonatomic,strong) <++childName_%@++> *%@; \n // @interface <++childName_%@++> : NSObject\n %@ \n // @end \n",keysArr[i],keysArr[i],keysArr[i],[NSObject subModelStringFrom:[dic valueForKey:keysArr[i]]]]];
        }else if ([[dic valueForKey:keysArr[i]] isKindOfClass:[NSArray class]]) {
            [resultArray addObject:[NSString stringWithFormat:@"/** %@ */\n@property (nonatomic,strong) NSArray *%@;",[dic valueForKey:keysArr[i]],keysArr[i]]];
        }else{
            NSString *typeStr = [NSObject fromTypeToString:[dic valueForKey:keysArr[i]]];
            if ([typeStr exist]) {
                [resultArray addObject:[NSString stringWithFormat:@"/** %@ */\n@property (nonatomic,assign) %@ %@;",[dic valueForKey:keysArr[i]],typeStr,keysArr[i]]];
            }
        }
    }
    NSString *allStr = @"// // 此处为子model \n  // // 嵌套.m处理参考NewUserRecommondListModel.m \n\n";
    for (NSString *str in resultArray) {
      allStr = [allStr stringByAppendingFormat:@"\n%@\n",str];
    }
    allStr = [allStr stringByReplacingOccurrencesOfString:@"\n" withString:@"\n // "];

    allStr = [allStr stringByReplacingOccurrencesOfString:@"<++" withString:@"<#"];
    allStr = [allStr stringByReplacingOccurrencesOfString:@"++>" withString:@"#>"];
    allStr = [allStr stringByReplacingOccurrencesOfString:@" /**  */" withString:@""];
    return allStr;
}
+(NSString*)fromTypeToString:(id)data{
	NSString *returnString;
	NSNumber *myNumber  = (NSNumber *)data;
	int minThreshold = [myNumber intValue];
	if ((int)minThreshold < 1 ){
		NSLog(@"Not a number");
	}else{
		if (strcmp([myNumber objCType], @encode(BOOL)) == 0) {
			returnString = @"BOOL";
			NSLog(@"this is a bool");
		} else if (strcmp([myNumber objCType], @encode(int)) == 0) {
			returnString = @"NSInteger";
			NSLog(@"this is an int");
		} else if (strcmp([myNumber objCType], @encode(float)) == 0) {
			returnString = @"CGFloat";
			NSLog(@"this is an float");
		}else if (strcmp([myNumber objCType], @encode(double)) == 0) {
		returnString = @"double";
		NSLog(@"this is an double");
		}
	}
	return returnString;
}

//示例 wiki 中换行用,替换 得到如下str
//	NSString *str = @"name	string	勋章名,require_value	int	要求数量,require_days	int	限定天数,icon_url	string	灰色图标,color_icon_url	string	彩色图标,description	string	描述说明,city_id	string	城市id,group_id	int	分组id,sort_id	int	默认排序，列表输出的已排序,created_at	datetime	创建时间,updated_at	datetime	更新时间,awarded	bool	是否已获得 true 获得false 未获得,is_new	bool	是否新获得 true新获得 false 非新获得,online	bool	是否在线 true 在线 false 已下线,group_name	string	分组名称,wearing	bool	是否佩带 true 佩带 false未佩带,growing	bool	是否可升级，true可,false不可,action_id	int	动作类型 ActionType枚举,statistics_type	int	统计方式 StatisticsType枚举,button_name	string	菜单名字,button_display	bool	是否显示菜单,link_url	string	链接URL,link_display	bool	是否显示链接,value	int	已获得的累积值,source_id	string	来源 参考 SourceType,fid	long	版块或圈子id,auto_wearing	bool	是否自动佩带，也可以通过 growing == true && wearing==true，直接判定";
//解析 NSArray *Arr = [ModelTool stringToModelDefine:str];
//然后把Arr打印出来复制到自定义model中的.h 即可;
+(NSArray *)stringToModelDefine:(NSString *)str{
	NSMutableArray *aArr = [str componentsSeparatedByString:@","].mutableCopy;
	NSMutableArray *resultArr = [NSMutableArray new];
	for (int i=0; i<aArr.count; i++) {
        //正则表达式替换两个以上的空格为一个空格
        
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\s{2,}" options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray *arr = [regex matchesInString:aArr[i] options:NSMatchingReportCompletion range:NSMakeRange(0, [aArr[i] length])];
        arr = [[arr reverseObjectEnumerator] allObjects];
        for (NSTextCheckingResult *str in arr) {
            aArr[i] = [aArr[i] stringByReplacingCharactersInRange:[str range] withString:@" "];
        }

		NSMutableArray *subArr = [aArr[i]  componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].mutableCopy;

        
		NSString *resultStr;
		if (subArr.count>=2) {
			if ([subArr[2] isEqualToString:@"bool"]) {
				if (subArr.count>2) {
					resultStr = [NSString stringWithFormat:@"@property (nonatomic,assign) BOOL %@; // %@",subArr[0],subArr[1]];
				}else{
					resultStr = [NSString stringWithFormat:@"@property (nonatomic,assign) BOOL %@;",subArr[0]];
				}
			}else
			if ([subArr[2] hasPrefix:@"int"]) {
				if (subArr.count>2) {
					resultStr = [NSString stringWithFormat:@"@property (nonatomic,assign) NSInteger %@; // %@",subArr[0],subArr[1]];
				}else{
					resultStr = [NSString stringWithFormat:@"@property (nonatomic,assign) NSInteger %@;",subArr[0]];
				}
			}else
            if ([subArr[2] isEqualToString:@"string"]||[subArr[2] isEqualToString:@"datetime"]) {
                if ([subArr[1] hasSuffix:@"Dict"]) {
                    if (subArr.count>2) {
                        resultStr = [NSString stringWithFormat:@"@property (nonatomic,copy) NSDictionary *%@; // %@",subArr[0],subArr[1]];
                    }else{
                        resultStr = [NSString stringWithFormat:@"@property (nonatomic,copy) NSDictionary *%@;",subArr[0]];
                    }
                }else{
                    if (subArr.count>2) {
                        resultStr = [NSString stringWithFormat:@"@property (nonatomic,strong) NSString *%@; // %@",subArr[0],subArr[1]];
                    }else{
                        resultStr = [NSString stringWithFormat:@"@property (nonatomic,strong) NSString *%@;",subArr[0]];
                    }
                }
			}else
            if ([subArr[2] hasPrefix:@"array"]) {
                if (subArr.count>2) {
                    resultStr = [NSString stringWithFormat:@"@property (nonatomic,copy) NSArray *%@; // %@",subArr[0],subArr[1]];
                }else{
                    resultStr = [NSString stringWithFormat:@"@property (nonatomic,copy) NSArray *%@;",subArr[0]];
                }
            }
		}else{
			resultStr = [subArr componentsJoinedByString:@","];
		}
		if (resultStr) {
			[resultArr addObject:resultStr];
		}
	}
	return resultArr;
}


////model转化为字典
//+ (NSDictionary *)dicFromObject:(NSObject *)object {
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    unsigned int count;
//    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
//
//    for (int i = 0; i < count; i++) {
//        objc_property_t property = propertyList[i];
//        const char *cName = property_getName(property);
//        NSString *name = [NSString stringWithUTF8String:cName];
//        NSObject *value = [object valueForKey:name];//valueForKey返回的数字和字符串都是对象
//
//        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
//            //string , bool, int ,NSinteger
//            [dic setObject:value forKey:name];
//
//        } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
//            //字典或字典
//            [dic setObject:[self arrayOrDicWithObject:(NSArray*)value] forKey:name];
//
//        } else if (value == nil) {
//            //null
//            //[dic setObject:[NSNull null] forKey:name];//这行可以注释掉?????
//
//        } else {
//            //model
//            [dic setObject:[self dicFromObject:value] forKey:name];
//        }
//    }
//
//    return [dic copy];
//}
//
////将可能存在model数组转化为普通数组
//- (id)arrayOrDicWithObject:(id)origin {
//    if ([origin isKindOfClass:[NSArray class]]) {
//        //数组
//        NSMutableArray *array = [NSMutableArray array];
//        for (NSObject *object in origin) {
//            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
//                //string , bool, int ,NSinteger
//                [array addObject:object];
//
//            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
//                //数组或字典
//                [array addObject:[self arrayOrDicWithObject:(NSArray *)object]];
//
//            } else {
//                //model
//                [array addObject:[self dicFromObject:object]];
//            }
//        }
//
//        return [array copy];
//
//    } else if ([origin isKindOfClass:[NSDictionary class]]) {
//        //字典
//        NSDictionary *originDic = (NSDictionary *)origin;
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        for (NSString *key in originDic.allKeys) {
//            id object = [originDic objectForKey:key];
//
//            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
//                //string , bool, int ,NSinteger
//                [dic setObject:object forKey:key];
//
//            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
//                //数组或字典
//                [dic setObject:[self arrayOrDicWithObject:object] forKey:key];
//
//            } else {
//                //model
//                [dic setObject:[self dicFromObject:object] forKey:key];
//            }
//        }
//
//        return [dic copy];
//    }
//
//    return [NSNull null];
//}
@end
