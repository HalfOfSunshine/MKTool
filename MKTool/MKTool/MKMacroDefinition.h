//
//  MKMacroDefinition.h
//  MKTool
//
//  Created by 麻明康 on 2024/1/16.
//

#ifndef MKMacroDefinition_h
#define MKMacroDefinition_h
#define MK_APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
//程序版本号
#define MK_APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//获取APP build版本
#define MK_APP_BUILD ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])

//屏幕的宽度
#define MK_ScreenSize [UIScreen mainScreen].bounds.size

//weakify & strongify
#define MK_weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__attribute__((objc_ownership(weak))) __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#define MK_strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__attribute__((objc_ownership(strong))) __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")


#endif /* MKMacroDefinition_h */
