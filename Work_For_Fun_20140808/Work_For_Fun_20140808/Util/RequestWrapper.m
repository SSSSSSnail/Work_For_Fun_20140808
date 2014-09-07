//
//  RequestWrapper.m
//  UUAP
//
//  Created by Snail on 30/5/14.
//  Copyright (c) 2014 baidu. All rights reserved.
//

#import "RequestWrapper.h"

@implementation RequestWrapper

+ (AFHTTPRequestOperationManager *)requestWithURL:(NSString *)url
                                   withParameters:(NSDictionary *)parameters
                                          success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];

    requestManager.requestSerializer.timeoutInterval = 10.0f;
    requestManager.requestSerializer.HTTPShouldHandleCookies = YES;
    requestManager.responseSerializer = [AFJSONResponseSerializer serializer];

    NSMutableSet *acceptContentTypes = [NSMutableSet setWithSet:requestManager.responseSerializer.acceptableContentTypes];
    [acceptContentTypes addObject:@"text/plain"];
    [acceptContentTypes addObject:@"text/html"];
    [acceptContentTypes addObject:@"application/json"];
    requestManager.responseSerializer.acceptableContentTypes = acceptContentTypes;

    [requestManager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    return requestManager;
}

@end
