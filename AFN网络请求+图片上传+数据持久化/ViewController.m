//
//  ViewController.m
//  AFN网络请求+图片上传+数据持久化
//
//  Created by 启洋信息 on 16/6/28.
//  Copyright © 2016年 Oscar. All rights reserved.
//

#import "ViewController.h"
#import "OscarNetWorking.h"

@interface ViewController ()

@property (nonatomic, strong)NSArray *pictureArray;

@property (nonatomic, copy)NSString *imageName;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)firstButton:(id)sender {
    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
    menu.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
}
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"33333333333333");
    if(buttonIndex==0){
        [self snapImage];
        NSLog(@"111111111111");
    }else if(buttonIndex==1){
        [self pickImage];
        NSLog(@"222222222222");
    }
}
//拍照
- (void) snapImage{
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    ipc.sourceType=UIImagePickerControllerSourceTypeCamera;
    ipc.delegate=self;
    ipc.allowsEditing=NO;
    [self presentViewController:ipc animated:YES completion:nil];
    
}
//从相册里找
- (void) pickImage{
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    ipc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate=self;
    ipc.allowsEditing=NO;
    [self presentViewController:ipc animated:YES completion:nil];
}
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *) info{
    UIImage *img=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
        
    }
    UIImage *newImg=[self imageWithImageSimple:img scaledToSize:CGSizeMake(300, 300)];
    _pictureArray = @[newImg];
    _coverImage.image = newImg;
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UIImage *) imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize) newSize{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}
- (IBAction)secondButton:(id)sender {
    [self postLoadImage];
}

- (void)postLoadImage
{
    NSString *requestStr = @"http://222.161.203.138:8080/AndroidUploadFileWeb/FileImageUploadServlet";
    CGSize size = CGSizeMake(300, 300);
    [OscarNetWorking OscarUploadImgeRequestWithURL:requestStr Parameter:nil Images:_pictureArray Name:@"img" ImageType:JPGType FieldType:@"Content-Disposition" ImageSize:size ImageIdentifier:@"B00000000002_s" SuccessResult:^(id responseObject) {
        
    } FailureResult:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
