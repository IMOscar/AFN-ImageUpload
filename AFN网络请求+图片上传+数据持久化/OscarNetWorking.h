//
//  OscarNetWorking.h
//  AFN网络请求+图片上传+数据持久化
//
//  Created by 启洋信息 on 16/6/28.
//  Copyright © 2016年 Oscar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , MethodsType){
    POSTMethodsType = 0,
    GETMethodsType  = 1,
};
typedef NS_ENUM(NSInteger , ImageType){
    PNGType = 0,
    JPGType = 1,
};
typedef void(^successBlock)(id responseObject);
typedef void(^failureBlock)(NSError *error);
@interface OscarNetWorking : NSObject
/**
 *  网络请求
 *
 *  @param URL          数据接口
 *  @param paremeter    body
 *  @param methodsType  请求方式
 *  @param successBlock 成功回调
 *  @param failureBlock 失败回调
 */
+ (void)OscarNetworkRequestWithURL:(NSString *)URL
                         Parameter:(NSDictionary *)parameter
                       MethodsType:(MethodsType)methodsType
                     SuccessResult:(successBlock)successBlock
                     FailureResult:(failureBlock)failureBlock;


/**
 *  图片上传
 *
 *  @param URL           后台接口
 *  @param parameter     body
 *  @param images        图片数组
 *  @param name          后台参数字段
 *  @param imageType     图片类型
 *  @param fieldType     后台字段类型
 *  @param imageSize     图片尺寸
 *  @param successResult 成功回调
 *  @param failureResult 失败回调
 */
+ (void)OscarUploadImgeRequestWithURL:(NSString *)URL
                            Parameter:(NSDictionary *)parameter
                               Images:(NSArray *)images
                                 Name:(NSString *)name
                            ImageType:(ImageType)imageType
                            FieldType:(NSString *)fieldType
                            ImageSize:(CGSize)imageSize
                      ImageIdentifier:(NSString *)imageIdentifier
                        SuccessResult:(successBlock)successResult
                        FailureResult:(failureBlock)failureResult;


@end
