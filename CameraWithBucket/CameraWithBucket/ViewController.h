//
//  ViewController.h
//  CameraWithBucket
//
//  Created by Aditya Narayan on 12/10/14.
//  Copyright (c) 2014 John Bogil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Amazon.h"
#import "Constants.h"



@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UITextFieldDelegate>


@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) NSData *imageData;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) UIImage *chosenImage;
@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) Amazon *amazonClient;




@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (retain, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIProgressView *progressView;


- (IBAction)cameraButton:(id)sender;
- (IBAction)libraryButton:(id)sender;
- (IBAction)shareButton:(id)sender;
- (IBAction)editButton:(id)sender;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *editButton;


-(void)loadData;


@end

