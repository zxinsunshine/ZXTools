//
//  ZXTools.h
//  test
//
//  Created by 周潇 on 16/6/9.
//  Copyright © 2016年 zx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    ZXShapeCircle,
    ZXShapeSquare
}ZXShape;

typedef enum {
    ZXSaveTypeDictionary,
    ZXSaveTypeArray,
    ZXSaveTypeString,
    ZXSaveTypeData,
    ZXSaveTypeBOOl,
    ZXSaveTypeInteger,
    ZXSaveTypeFloat,
    ZXSaveTypeDouble,
    ZXSaveTypeUrl
}ZXSaveType;

@interface ZXTools : NSObject

# pragma mark - 图片操作

// 放缩
+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size;

// 拉伸
+ (UIImage *)stretchImage:(UIImage *)image toSize:(CGSize)size withEdge:(UIEdgeInsets)edgeInsets;

// 剪裁
+ (UIImage *)clipImage:(UIImage *)image withSize:(CGSize)size toShape:(ZXShape)shape inRect:(CGRect)rect;

// 截图
+ (UIImage *)shotView:(UIView *)view;

// 保存图片到相册
+ (void)saveImage:(UIImage *)image;




# pragma mark - 文件夹路径获取

// 获取APP根目录路径
+ (NSString *)getAppPath;

// 获取APP中Documents路径
+ (NSString *)getDocumentsPath;

// 获取APP中tmp路径
+ (NSString *)getTmpPath;

// 获取APP中Library路径
+ (NSString *)getLibraryPath;

// 获取APP中Preferrence路径
+ (NSString *)getPreferencesPath;

// 获取APP中Caches路径
+ (NSString *)getCachesPath;



# pragma mark - 数据读写

// 存储plist
+ (BOOL)saveToPlistWithObject:(id)obj andName:(NSString *)fileName;

// 从plist中读取数组格式数据
+ (NSArray *)getArrayFromPlistOfName:(NSString *)fileName;

// 从plist读取字典格式数据
+ (NSDictionary *)getDictionaryFromPlistOfName:(NSString *)fileName;

// 存储JSON
+ (BOOL)saveToJsonWithObject:(id)obj andName:(NSString *)fileName;

// 从JSON文件中读取数组格式的数据
+ (NSArray *)getArrayFromJsonOfName:(NSString *)fileName;

// 从JSON文件中读取字典格式数据
+ (NSDictionary *)getDictionaryFromJsonOfName:(NSString *)fileName;

// 存储偏好
+ (BOOL)saveToPreferencesWithObject:(id)obj ofType:(ZXSaveType)type withKey:(NSString *)key;

// 读取数组格式偏好
+ (NSArray *)getArrayFromPreferencesWithKey:(NSString *)key;

// 读取字典格式偏好
+ (NSDictionary *)getDictionaryFromPreferencesWithKey:(NSString *)key;

// 读取字符串格式偏好
+ (NSString *)getStringFromPreferencesWithKey:(NSString *)key;

// 读取Data格式偏好
+ (NSData *)getDataFromPreferencesWithKey:(NSString *)key;

// 读取BOOL格式偏好
+ (BOOL)getBOOLFromPreferencesWithKey:(NSString *)key;

// 读取整型格式偏好
+ (NSInteger)getIntegerFromPreferencesWithKey:(NSString *)key;

// 读取数组格式偏好
+ (float)getFloatFromPreferencesWithKey:(NSString *)key;

// 读取双浮点格式偏好
+ (double)getDoubleFromPreferencesWithKey:(NSString *)key;

// 读取URL格式偏好
+ (NSURL *)getURLFromPreferencesWithKey:(NSString *)key;

// 归档,默认后缀为.data
+ (BOOL)saveToArchiveWithObject:(id)obj andFileName:(NSString *)fileName;

// 解档
+ (id)getObjectFromArchiveWithFile:(NSString *)fileName;


# pragma mark - 网络请求

// 发送socket信息
+ (BOOL)sendSocketMsg:(NSString *)msg withIP:(NSString *)ip andPort:(NSInteger)port;

// 获取socket信息
+ (NSString *)getSocketMsgFromIP:(NSString *)ip andPort:(NSInteger)port;






@end
