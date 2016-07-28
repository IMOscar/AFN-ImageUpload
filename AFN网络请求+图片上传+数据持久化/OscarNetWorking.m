//
//  OscarNetWorking.m
//  AFN网络请求+图片上传+数据持久化
//
//  Created by 启洋信息 on 16/6/28.
//  Copyright © 2016年 Oscar. All rights reserved.
//

#import "OscarNetWorking.h"
#import <AFNetworking.h>
#import <UIKit/UIKit.h>

@implementation OscarNetWorking

+ (void)OscarNetworkRequestWithURL:(NSString *)URL Parameter:(NSDictionary *)parameter MethodsType:(MethodsType)methodsType SuccessResult:(successBlock)successBlock FailureResult:(failureBlock)failureBlock
{
    NSString *encodingStr = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //stringByAddingPercentEscapesUsingEncoding
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         if (status == 0)
         {
             NSLog(@"没有网络");
         }
         else
         {
             AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
             // Request the corresponding format
             manager.requestSerializer = [AFJSONRequestSerializer serializer];
             manager.responseSerializer = [AFJSONResponseSerializer serializer];
             // Request type
             [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain",@"application/x-javascript", nil]];
             MethodsType type = methodsType;
             switch (type) {
                     // POST
                 case POSTMethodsType: {
                     {
                         [manager POST:encodingStr parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             successBlock(responseObject);
                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             failureBlock(error);
                         }];
                     }
                     break;
                 }
                     // GET
                 case GETMethodsType: {
                     {
                         [manager GET:encodingStr parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             successBlock(responseObject);
                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             failureBlock(error);
                         }];
                     }
                     break;
                 }
             }
         }
     }];
}

+ (void)OscarUploadImgeRequestWithURL:(NSString *)URL Parameter:(NSDictionary *)parameter Images:(NSArray *)images Name:(NSString *)name ImageType:(ImageType)imageType FieldType:(NSString *)fieldType ImageSize:(CGSize)imageSize ImageIdentifier:(NSString *)imageIdentifier SuccessResult:(successBlock)successResult FailureResult:(failureBlock)failureResult
{
    NSString *encodingStr = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         if (status == 0)
         {
             NSLog(@"网络错误");
         }
         else
         {
             AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
             [manager POST:encodingStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                 // Named for the timestamp
                 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                 formatter.dateFormat = @"yyyyMMddHHmmss";
                 NSString *str = [formatter stringFromDate:[NSDate date]];
                 // Respectively named after PNG and JPG
                 NSData *imageData;
                 // enum pic type
                 for (UIImage *image in images) {
                     ImageType type = imageType;
                     switch (type) {
                         case PNGType: {
                             imageData = UIImagePNGRepresentation([self imageWithImageSimple:image scaledToSize:imageSize]);
                             NSString *fileName = [NSString stringWithFormat:@"%@%@.png", str,imageIdentifier];
                             [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:fieldType];
                             break;
                         }
                         case JPGType: {
                             imageData = UIImageJPEGRepresentation([self imageWithImageSimple:image scaledToSize:imageSize], 1.0);
                             NSString *fileName = [NSString stringWithFormat:@"%@%@.jpg", str,imageIdentifier];
                             [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:fieldType];
                             break;
                         }
                     }
                 }
             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 //
                 successResult(responseObject);
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 //
                 failureResult(error);
             }];
         }
     }];
}
/**
 *  图片压缩
 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    NSLog(@"%f",newSize.height);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
    
}
@end
