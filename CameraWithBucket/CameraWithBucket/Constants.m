//
//  Constants.m
//  CameraWithBucket
//
//  Created by Aditya Narayan on 12/16/14.
//  Copyright (c) 2014 John Bogil. All rights reserved.
//

#import "Constants.h"

@implementation Constants


+(NSString *)uploadBucket
{
    return [[NSString stringWithFormat:@"%@-%@", MY_BUCKET_NAME, MY_ACCESS_KEY_ID] lowercaseString];
}


@end
