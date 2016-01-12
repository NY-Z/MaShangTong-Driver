//
//  DownloadManager.m
//  MaShangTong-Driver
//
//  Created by jeaner on 15/11/12.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "DownloadManager.h"
#import <AFNetworking.h>

@implementation DownloadManager

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
//    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    mgr.requestSerializer.timeoutInterval = 10.f;
//    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [mgr GET:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    
//    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    mgr.requestSerializer.timeoutInterval = 10.f;
//    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //    mgr.responseSerializer.acceptableContentTypes
    [mgr POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
