//
//  AmazonS3Client.h
//  CameraWithBucket
//
//  Created by Aditya Narayan on 12/10/14.
//  Copyright (c) 2014 John Bogil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <awsruntime/awsruntime.h>
#import <AWSS3/AWSS3.h>


#define MY_ACCESS_KEY_ID @"123"
#define MY_SECRET_KEY @"123"
#define MY_BUCKET_NAME @"123"


@interface Amazon : NSObject <AmazonServiceRequestDelegate>


-(void)uploadToServer:(NSArray*)dataToUpload;
-(NSData*)downloadFromBucket:(NSArray*)dataToDownload;




@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) AmazonS3Client *s3;
@property (nonatomic, retain) id delegate;



-(id)initWithAccessKey:(NSString*)accessKey secretKey:(NSString*)secretKey bucket:(NSString*)bucket delegate:(id)delegate;

-(NSArray*)listFromBucket:(NSString*)bucketName;

-(BOOL)deleteFromBucket:(NSString*)bucketName withKey:(NSString*)key;




@end
