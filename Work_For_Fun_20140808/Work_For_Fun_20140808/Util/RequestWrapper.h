//
//  RequestWrapper.h
//  UUAP
//
//  Created by Snail on 30/5/14.
//  Copyright (c) 2014 baidu. All rights reserved.
//

#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

@interface RequestWrapper : NSObject

+ (AFHTTPRequestOperationManager *)requestWithURL:(NSString *)url
                                   withParameters:(NSDictionary *)parameters
                                          success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
