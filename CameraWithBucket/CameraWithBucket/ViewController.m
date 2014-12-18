//
//  ViewController.m
//  CameraWithBucket
//
//  Created by Aditya Narayan on 12/10/14.
//  Copyright (c) 2014 John Bogil. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Create the imagePicker Controller
    self.imagePicker = [[UIImagePickerController alloc]init];
    [self.imagePicker setDelegate:self];
    
    self.spinner.hidden = YES;
    [self.textField setDelegate:self];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    self.amazonClient = [[Amazon alloc]initWithAccessKey:(MY_ACCESS_KEY_ID) secretKey:MY_SECRET_KEY bucket:MY_BUCKET_NAME delegate:self];
    
    [self loadData];
    
}



-(void)loadData{
    
    self.tableData = [self.amazonClient listFromBucket:MY_BUCKET_NAME];
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark TableView Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tableData count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    self.fileName = [[NSString alloc]initWithFormat:@"%@", [self.tableData objectAtIndex:indexPath.row]];
    cell.textLabel.text = self.fileName;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    
    Amazon *amazon = [[Amazon alloc]init];
    
    self.fileName = [NSString stringWithFormat:@"%@", [self.tableData objectAtIndex:indexPath.row]];
    
    
    NSArray *dataToDownload = [[NSArray alloc]initWithObjects:MY_BUCKET_NAME, self.fileName, self, nil];
    
    [amazon performSelectorInBackground:@selector(downloadFromBucket:) withObject:dataToDownload];
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    

    
    self.fileName = [NSString stringWithFormat:@"%@", [self.tableData objectAtIndex:indexPath.row]];
    
    [self.amazonClient deleteFromBucket:MY_BUCKET_NAME withKey:self.fileName];
    
    [self loadData];
        
    
    
}



#pragma mark - imagePicker Methods

-(void)imagePickerController:(UIImagePickerController*)imagePicker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    self.chosenImage = info[UIImagePickerControllerEditedImage];
    
    // Convert the image to NSData so that we can send it to the server
    self.imageData = UIImageJPEGRepresentation(self.chosenImage, 1.0);
    
    self.imageView.image = self.chosenImage;
    
    [imagePicker dismissViewControllerAnimated:YES completion:NULL];

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController*)picker{
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Buttons

- (IBAction)cameraButton:(id)sender {
    

    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera ]){
        
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        self.imagePicker.allowsEditing = YES;
        [self presentViewController:self.imagePicker animated:YES completion:NULL];
        
    }
    else{
        
        UIAlertView *noCameraAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There is no camera available" delegate:nil cancelButtonTitle:@"i guess" otherButtonTitles: nil];
        
        [noCameraAlert show];
    }
}

- (IBAction)libraryButton:(id)sender {
    
    [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    self.imagePicker.allowsEditing = YES;
    
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}

- (IBAction)shareButton:(id)sender {
    
    if ([self.textField.text isEqual:@""]) {
        
        UIAlertView *noText = [[UIAlertView alloc]initWithTitle:@"No title" message:@"Please enter a title for the photo and press share again" delegate:nil cancelButtonTitle:@"My bad" otherButtonTitles:nil];
        [noText show];
    }
    else{
        
        self.spinner.hidden = NO;
        [self.spinner startAnimating];
        
        Amazon *amazon = [[Amazon alloc]init];
        
        NSArray *dataToUpload = [[NSArray alloc]initWithObjects:self.textField.text, self.imageData, self, nil];
        
        [amazon performSelector:@selector(uploadToServer:) withObject:dataToUpload];
        
    }
}

- (IBAction)editButton:(id)sender {
    
    
    if([self.tableView isEditing]){
        [sender setTitle:@"Edit"];
    }
    else{
        [sender setTitle:@"Done"];
    }
    [self.tableView setEditing:![self.tableView isEditing]];
}



-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self.textField resignFirstResponder];
    return YES;
}

- (void)dealloc {
    [_textField release];
    [_spinner release];
    [_progressView release];
    [_editButton release];
    [super dealloc];
}
@end
