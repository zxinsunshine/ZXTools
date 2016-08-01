//
//  ZXTools.m
//  test
//
//  Created by 周潇 on 16/6/9.
//  Copyright © 2016年 zx. All rights reserved.
//

#import "ZXTools.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@implementation ZXTools

# pragma mark - 图片操作

// 放缩
+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * resizeImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resizeImg;
}

// 拉伸
+ (UIImage *)stretchImage:(UIImage *)image toSize:(CGSize)size withEdge:(UIEdgeInsets)edgeInsets{
    
    UIGraphicsBeginImageContext(size);
    
    UIImage * img = [image resizableImageWithCapInsets:edgeInsets];
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * stretchImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return stretchImg;
}

// 剪裁
+ (UIImage *)clipImage:(UIImage *)image withSize:(CGSize)size toShape:(ZXShape)shape inRect:(CGRect)rect{
    
    
    
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 裁剪上下文
    
    if(shape == ZXShapeCircle){
        // 半径
        CGFloat r = rect.size.width*0.5 < rect.size.height*0.5 ? rect.size.width*0.5 : rect.size.height*0.5;
        
        CGContextAddArc(ctx, rect.origin.x + r, rect.origin.y + r, r, 0, 2*M_PI, 1);
        CGContextClip(ctx);
        
    }
    else if(shape == ZXShapeSquare){
        CGContextAddRect(ctx, rect);
        CGContextClip(ctx);
    }
    
    // 渲染
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * clipImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return clipImg;
}

// 截图
+ (UIImage *)shotView:(UIView *)view{
    
    UIGraphicsBeginImageContext(view.bounds.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage * shotImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return shotImg;
}

// 保存图片到相册
+ (void)saveImage:(UIImage *)image{
    UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
}


# pragma mark - 文件夹路径获取

// 获取APP根目录路径
+ (NSString *)getAppPath{
    return NSHomeDirectory();
}

// 获取APP中Documents路径
+ (NSString *)getDocumentsPath{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

// 获取APP中tmp路径
+ (NSString *)getTmpPath{
    NSString * path = NSTemporaryDirectory();
    // 去掉最后一个斜杠
    return [path substringToIndex:path.length-1];
}

// 获取APP中Library路径
+ (NSString *)getLibraryPath{
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
}

// 获取APP中Preferrence路径
+ (NSString *)getPreferencesPath{
    NSString * LibraryPath = [self getLibraryPath];
    return [LibraryPath stringByAppendingPathComponent:@"Preferences"];
}

// 获取APP中Caches路径
+ (NSString *)getCachesPath{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
}



# pragma mark - 数据读写

// 存储plist
+ (BOOL)saveToPlistWithObject:(id)obj andName:(NSString *)fileName{
    
    NSString * filePath = [[self getDocumentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];

    return [obj writeToFile:filePath atomically:YES];

}

// 从plist中读取数组格式数据
+ (NSArray *)getArrayFromPlistOfName:(NSString *)fileName{
    
    NSString * filePath = [[self getDocumentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    
    return [NSArray arrayWithContentsOfFile:filePath];
}

// 从plist读取字典格式数据
+ (NSDictionary *)getDictionaryFromPlistOfName:(NSString *)fileName{
    
    NSString * filePath = [[self getDocumentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    
    return [NSDictionary dictionaryWithContentsOfFile:filePath];
}

// 存储JSON
+ (BOOL)saveToJsonWithObject:(id)obj andName:(NSString *)fileName{
 
    NSString * filePath = [[self getDocumentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",fileName]];
    NSData * data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:NULL];
    return [data writeToFile:filePath atomically:YES];

}

// 从JSON文件中读取数组格式的数据
+ (NSArray *)getArrayFromJsonOfName:(NSString *)fileName{
    
    NSString * filePath = [[self getDocumentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",fileName]];
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    
}

// 从JSON文件中读取字典格式数据
+ (NSDictionary *)getDictionaryFromJsonOfName:(NSString *)fileName{
    
    NSString * filePath = [[self getDocumentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",fileName]];
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
}


// 存储偏好
+ (BOOL)saveToPreferencesWithObject:(id)obj ofType:(ZXSaveType)type withKey:(NSString *)key{
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    
    id returnVal = nil;
    
    switch (type) {
        case ZXSaveTypeDictionary:
            
            [ud setObject:obj forKey:key];
            [ud synchronize]; // 解决iOS8不及时写入问题
            returnVal = [ud dictionaryForKey:key];
            return [obj isEqual:returnVal];
            
            break;
        case ZXSaveTypeArray:
            
            [ud setObject:obj forKey:key];
            [ud synchronize]; // 解决iOS8不及时写入问题
            returnVal = [ud arrayForKey:key];
            return [obj isEqual:returnVal];
            
            break;
        case ZXSaveTypeString:
            
            [ud setObject:obj forKey:key];
            [ud synchronize]; // 解决iOS8不及时写入问题
            returnVal = [ud stringForKey:key];
            return [obj isEqual:returnVal];

            break;
        case ZXSaveTypeData:
            
            [ud setObject:obj forKey:key];
            [ud synchronize]; // 解决iOS8不及时写入问题
            returnVal = [ud dataForKey:key];
            return [obj isEqual:returnVal];
            
            break;
        case ZXSaveTypeBOOl:
            
            [ud setBool:[obj boolValue] forKey:key];
            [ud synchronize]; // 解决iOS8不及时写入问题
            returnVal = @([ud boolForKey:key]);
            return [obj isEqual:returnVal];
            
            break;
        case ZXSaveTypeInteger:
            
            [ud setInteger:[obj integerValue] forKey:key];
            [ud synchronize]; // 解决iOS8不及时写入问题
            returnVal = @([ud integerForKey:key]);
            return [obj isEqual:returnVal];
            
            break;
        case ZXSaveTypeFloat:
            
            [ud setFloat:[obj floatValue] forKey:key];
            [ud synchronize]; // 解决iOS8不及时写入问题
            returnVal = @([ud floatForKey:key]);
            return [obj isEqual:returnVal];
            
            break;
        case ZXSaveTypeDouble:
            
            [ud setDouble:[obj doubleValue] forKey:key];
            [ud synchronize]; // 解决iOS8不及时写入问题
            returnVal = @([ud doubleForKey:key]);
            return [obj isEqual:returnVal];
            
            break;
        case ZXSaveTypeUrl:
            
            [ud setURL:obj forKey:key];
            [ud synchronize]; // 解决iOS8不及时写入问题
            returnVal = [ud URLForKey:key];
            return [obj isEqual:returnVal];
            
            break;
        default:
            return NO;
            break;
    }
    
    return NO;
}

// 读取数组格式偏好
+ (NSArray *)getArrayFromPreferencesWithKey:(NSString *)key{
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    
    return [ud arrayForKey:key];
    
}

// 读取字典格式偏好
+ (NSDictionary *)getDictionaryFromPreferencesWithKey:(NSString *)key{
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    
    return [ud dictionaryForKey:key];
    
}

// 读取字符串格式偏好
+ (NSString *)getStringFromPreferencesWithKey:(NSString *)key{
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    
    return [ud stringForKey:key];
}

// 读取Data格式偏好
+ (NSData *)getDataFromPreferencesWithKey:(NSString *)key{
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    
    return [ud dataForKey:key];
}

// 读取BOOL格式偏好
+ (BOOL)getBOOLFromPreferencesWithKey:(NSString *)key{
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    
    return [ud boolForKey:key];
}

// 读取整型偏好
+ (NSInteger)getIntegerFromPreferencesWithKey:(NSString *)key{
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    
    return [ud integerForKey:key];
    
}

// 读取偏好数组
+ (float)getFloatFromPreferencesWithKey:(NSString *)key{
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    
    return [ud floatForKey:key];
}

// 读取双浮点格式偏好
+ (double)getDoubleFromPreferencesWithKey:(NSString *)key{
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    
    return [ud doubleForKey:key];
}

// 读取URL格式偏好
+ (NSURL *)getURLFromPreferencesWithKey:(NSString *)key{
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    
    return [ud URLForKey:key];
}

// 归档
+ (BOOL)saveToArchiveWithObject:(id)obj andFileName:(NSString *)fileName{
    NSString * filePath = [[self getTmpPath] stringByAppendingPathComponent:
                           [NSString stringWithFormat:@"%@.data",fileName]];
    return [NSKeyedArchiver archiveRootObject:obj toFile:filePath];
}

// 解档
+ (id)getObjectFromArchiveWithFile:(NSString *)fileName{
    NSString * filePath = [[self getTmpPath] stringByAppendingPathComponent:
                           [NSString stringWithFormat:@"%@.data",fileName]];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}


# pragma mark - 网络请求

+ (BOOL)sendSocketMsg:(NSString *)msg withIP:(NSString *)ip andPort:(NSInteger)port{
    
    // 1. 创建代理
    // 参数一: 协议簇 默认为IPv4
    // 参数二: socket类型 默认为socket流
    // 参数三: 协议 默认为TCP
    // 返回: socket的标识
    int clientSocket = socket(AF_INET,SOCK_STREAM,IPPROTO_TCP);
    
    // 2. 连接服务器
    struct sockaddr_in addr; // 地址信息
    addr.sin_family = AF_INET; // 指定协议
    addr.sin_addr.s_addr = inet_addr(ip.UTF8String); // 指定IP
    addr.sin_port = htons(port); // 指定端口
    
    int rs = connect(clientSocket, (const struct sockaddr *)&addr, sizeof(addr)); // 连接结果
    if(rs != 0){ // 成功为0,不为0返回失败
        close(clientSocket);
        return NO;
    }
    
    // 3. 发送消息
    const char * msgStr = msg.UTF8String;
    // 参数一: socket标识
    // 参数二: 字符数组
    // 参数三: 字符数组个数
    // 参数四: 是否阻塞
    // 返回: 发送的字符数
    ssize_t sendCount = send(clientSocket, msgStr, strlen(msgStr), 0);
    
    close(clientSocket);
    
    // 判断发送的消息是否完整
    if(sendCount == strlen(msgStr)){
        return YES;
    }
    else{
        return NO;
    }
      
}

// 获取socket信息
+ (NSString *)getSocketMsgFromIP:(NSString *)ip andPort:(NSInteger)port{
    // 1. 创建代理
    // 参数一: 协议簇 默认为IPv4
    // 参数二: socket类型 默认为socket流
    // 参数三: 协议 默认为TCP
    // 返回: socket的标识
    int clientSocket = socket(AF_INET,SOCK_STREAM,IPPROTO_TCP);
    
    // 2. 连接服务器
    struct sockaddr_in addr; // 地址信息
    addr.sin_family = AF_INET; // 指定协议
    addr.sin_addr.s_addr = inet_addr(ip.UTF8String); // 指定IP
    addr.sin_port = htons(port); // 指定端口
    
    int rs = connect(clientSocket, (const struct sockaddr *)&addr, sizeof(addr)); // 连接结果
    if(rs != 0){ // 连接成功为0,不为0返回失败
        close(clientSocket);
        return nil;
    }
    
    // 3. 接收数据
    uint8_t buffer[1024];
    ssize_t recvCount = recv(clientSocket, buffer, sizeof(buffer), 0); // 接收数据数
    if(recvCount){
        // 把接收的二进制数据转化成字符串
        NSData * data = [NSData dataWithBytes:buffer length:recvCount];
        NSString * recvMsg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        close(clientSocket);
        NSLog(@"%@",recvMsg);
        return recvMsg;
    }
    
    close(clientSocket);
    return nil;
    
}



@end
