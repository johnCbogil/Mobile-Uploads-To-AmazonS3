//
//  AmazonS3Client.m
//  CameraWithBucket
//
//  Created by Aditya Narayan on 12/10/14.
//  Copyright (c) 2014 John Bogil. All rights reserved.
//

#import "Amazon.h"
#import "ViewController.h"


@implementation Amazon

-(id)initWithAccessKey:(NSString*)accessKey secretKey:(NSString*)secretKey bucket:(NSString*)bucket delegate:(id)delegate{
    
    self.s3 = [[AmazonS3Client alloc] initWithAccessKey:MY_ACCESS_KEY_ID withSecretKey:MY_SECRET_KEY];
    self.delegate = delegate;
    
    return self;}


-(BOOL)deleteFromBucket:(NSString*)bucketName withKey:(NSString*)key{
 
    @try{
        
        [self.s3 deleteObjectWithKey:key withBucket:MY_BUCKET_NAME];
        return TRUE;
        
        
    }
    @catch(NSException *exception){
        NSLog(@"Cannot delete S3 Object %@", exception);
        return FALSE;
    }
}

    
    
#pragma mark - Download Methods
    -(NSData*)downloadFromBucket:(NSArray*)dataToDownload{
        
        @try {
            
            NSString *fileName = dataToDownload[1];
            self.viewController = dataToDownload[2];
            
            self.s3 = [[AmazonS3Client alloc] initWithAccessKey:MY_ACCESS_KEY_ID withSecretKey:MY_SECRET_KEY];
            
            S3GetObjectRequest *request = [[S3GetObjectRequest alloc]initWithKey:fileName withBucket:MY_BUCKET_NAME];
            S3GetObjectResponse *response = [self.s3 getObject:request];
            NSData *downloadData = [response body];
            
            if(downloadData){
                ViewController *vc =  (ViewController*)self.viewController;
                vc.imageView.image = [UIImage imageWithData:downloadData];
                
                [vc.spinner stopAnimating];
                vc.spinner.hidden = YES;
                
            }
            
            
            
            return downloadData;
            
        }
        
        @catch (NSException *exception) {
            
            NSLog(@"Cannot Load S3 object %@", exception);
            return nil;
        }
        
    }
    
    
    
    -(NSArray*)listFromBucket:(NSString*)bucketName{
        
        
        @try {
            S3ListObjectsRequest *req = [[S3ListObjectsRequest alloc] initWithName: bucketName ];
            S3ListObjectsResponse *resp = [self.s3 listObjects:req];
            NSArray* objectSummaries = resp.listObjectsResult.objectSummaries;
            return [[NSArray alloc] initWithArray: objectSummaries];
        }
        @catch (NSException *exception) {
            NSLog(@"Cannot list Amazon Client %@",exception);
            return [[NSArray alloc]init];
        }
        
    }
    
    
    
    
#pragma mark - Upload Methods
    -(void)uploadToServer:(NSArray*)dataToUpload{
        
        NSString *fileName = dataToUpload[0];
        NSData * imageData = dataToUpload[1];
        self.viewController = dataToUpload[2];
        
        
        self.s3 = [[AmazonS3Client alloc] initWithAccessKey:MY_ACCESS_KEY_ID withSecretKey:MY_SECRET_KEY];
        
        S3PutObjectRequest *request = [[S3PutObjectRequest alloc]initWithKey:fileName inBucket:MY_BUCKET_NAME];
        request.contentType = @"image/jpeg";
        request.data = imageData;
        request.delegate = self;
        [self.s3 putObject:request];
        
        
    }
    
    
    -(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response{
        
        // Comes in as UIViewController, so we need to caste it to viewController
        ViewController *vc =  (ViewController*)self.viewController;
        [vc.spinner stopAnimating];
        vc.spinner.hidden = YES;
        
        UIAlertView *uploadComplete = [[UIAlertView alloc]initWithTitle:@"Upload Complete" message:@"Your upload was completed successfully" delegate:nil cancelButtonTitle:@"cool" otherButtonTitles:nil];
        [uploadComplete show];
        
        [vc loadData];
        NSLog(@"reload tableview");
        
    }
    
    -(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error{
        
        ViewController *vc =  (ViewController*)self.viewController;
        
        [vc.spinner stopAnimating];
        vc.spinner.hidden = YES;
        
        
        NSLog(@"error");
    }
    
    
    -(void)request:(AmazonServiceRequest *)request didSendData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite{
        
        ViewController *vc =  (ViewController*)self.viewController;
        vc.progressView.progress = ((float)totalBytesWritten / totalBytesExpectedToWrite);
        
    }
    
    @end
