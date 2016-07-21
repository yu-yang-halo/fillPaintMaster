//
//  PaintView1Controller.m
//  fillPaintMaster
//
//  Created by apple on 15/10/5.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import "PaintView1Controller.h"
#import "AJPhotoPickerViewController.h"
#import "ImageUtils.h"
#import <UIView+Toast.h>
#import "ElApiService.h"
#import "Constants.h"
#import "OrderSuccessViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface PaintView1Controller ()<AJPhotoPickerProtocol>{
    int type;
    
    NSArray *assets0;
    NSArray *assets1;
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UIButton *badCarPicBtn;
@property (weak, nonatomic) IBOutlet UIButton *accidentPicBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;

- (IBAction)uploadBadCarImage:(id)sender;
- (IBAction)uploadAccidentImage:(id)sender;
- (IBAction)orderCommit:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *container0;
@property (weak, nonatomic) IBOutlet UIView *container1;

@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;



@end

@implementation PaintView1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneCall:)];
    [_telephoneLabel setUserInteractionEnabled:YES];
    [_telephoneLabel addGestureRecognizer:tapGR];
    
    
}
-(void)phoneCall:(UIGestureRecognizer *)gr{
    UILabel *label=(UILabel *)gr.view;
    NSString *phone=label.text;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phone]]];

}
-(void)beginPhotoPicker{
    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
    //最大可选项
    picker.maximumNumberOfSelection = 4;
    //是否多选
    picker.multipleSelection = YES;
    //资源过滤
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    //是否显示空的相册
    picker.showEmptyGroups = NO;
    //委托（必须）
    picker.delegate = self;
    //可选过滤
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSLog(@"evaluatedObject %@",evaluatedObject);
        
        if([evaluatedObject isKindOfClass:[ALAsset class]]){
            ALAsset *asset=evaluatedObject;
            NSString *type=[asset valueForProperty:ALAssetPropertyType];
            if(type==ALAssetTypePhoto){
                return YES;
            }else{
                return NO;
            }
        }else{
            return YES;
        }
        
        
        
    }];
    
    [self.tdPaintVCDelegate presentViewController:picker animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)uploadBadCarImage:(id)sender {
    type=0;
    [self beginPhotoPicker];
}

- (IBAction)uploadAccidentImage:(id)sender {
    type=1;
    [self beginPhotoPicker];
}

- (IBAction)orderCommit:(id)sender {
    int carId=[[[NSUserDefaults standardUserDefaults] objectForKey:KEY_CAR_ID] intValue];
    int shopId=[[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SHOP_ID] intValue];
    
    if(carId<=0){
        [self.view makeToast:@"您还没有车牌号，请到设置中添加车牌号"];
        return;
    }
    
    
    if([assets0 count]>0){
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText=@"订单处理中";
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            TDMetaOrder *metaOrder=[[TDMetaOrder alloc] init];
            [metaOrder setType:TYPE_PAY_TOSHOP];
            [metaOrder setState:STATE_ORDER_UNFINISHED];
            
            [metaOrder setCarId:carId];
            [metaOrder setShopId:shopId];
            int metaOrderId=0;
            
            NSArray *retObjArr=[[ElApiService shareElApiService] createMetaOrder:metaOrder];
            BOOL todoSuccess=NO;
            if(retObjArr!=nil&&[retObjArr count]==2){
                metaOrderId=[retObjArr[0] intValue];
                for (ALAsset *asset in assets0) {
                   NSString *encodeImageString=[ImageUtils encodeToBase64String:[UIImage imageWithCGImage:asset.thumbnail] format:@"PNG"];
                   todoSuccess=[[ElApiService shareElApiService] createMetaOrderImg:metaOrderId imgName:encodeImageString];
                   if(!todoSuccess){
                        break;
                   }
                }
                if(todoSuccess){
                    for (ALAsset *asset in assets1) {
                        NSString *encodeImageString=[ImageUtils encodeToBase64String:[UIImage imageWithCGImage:asset.thumbnail] format:@"PNG"];
                        todoSuccess=[[ElApiService shareElApiService] createMetaOrderImg:metaOrderId imgName:encodeImageString];
                        if(!todoSuccess){
                            break;
                        }
                    }
                }
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(hud!=nil){
                    [hud hide:YES];
                }
                if(todoSuccess){
                    NSLog(@"success");
                }else{
                    NSLog(@"fail");
                }
                UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                OrderSuccessViewController *orderSucVC=[storyBoard instantiateViewControllerWithIdentifier:@"orderSucVC"];
                [orderSucVC setCarBeautyType:CarBeautyType_paint];
                [orderSucVC setResultOK:todoSuccess];
                
                
                
                [self.tdPaintVCDelegate.navigationController pushViewController:orderSucVC animated:YES];
                
            });
            
            
        });
        
        
    }else{
        [self.view makeToast:@"请选择图片"];
    }
  
    
}

-(void)addAsserts:(NSArray *)assets toView:(UIView *)view{
    
    NSArray *subViews=[view subviews];
    for (UIView *view in subViews) {
        [view removeFromSuperview];
    }
    CGFloat width=view.bounds.size.width/2;
    CGFloat height=view.bounds.size.height/2;
    int size=[assets count];
    for (int i=0;i<size;i++){
        ALAsset *asset=[assets objectAtIndex:i];
       
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectZero];
       
        int row=0;
        int col=0;
        
        if (size>=3) {
            row=i/2;
            col=i%2;
        }else if (size==1){
            row=0;
            col=0;
            height=view.bounds.size.height;
            width=view.bounds.size.width;
        }else if(size==2){
            row=0;
            col=i;
            height=view.bounds.size.height;
            width=view.bounds.size.width/2;
        }
        
        
        
        
        imageView.frame=CGRectMake(col*width,row*height,width,height);
        imageView.image=[UIImage imageWithCGImage:asset.thumbnail];
        [view addSubview:imageView];
    }
    
}

//选择完成
- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets{
    NSLog(@"完成%@",assets);
    if(type==0){
         [self addAsserts:assets toView:_container0];
         assets0=assets;
    }else{
         [self addAsserts:assets toView:_container1];
         assets1=assets;
    }
   
    [self.tdPaintVCDelegate dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//点击选中
- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAsset:(ALAsset*)asset{
    NSLog(@"点击选中%@",asset);
    
}

//取消选中
- (void)photoPicker:(AJPhotoPickerViewController *)picker didDeselectAsset:(ALAsset*)asset{
     NSLog(@"取消选中%@",asset);
    
}

//点击相机按钮相关操作
- (void)photoPickerTapCameraAction:(AJPhotoPickerViewController *)picker{
     NSLog(@"点击相机按钮相关操作");
    
}

//取消
- (void)photoPickerDidCancel:(AJPhotoPickerViewController *)picker{
     NSLog(@"取消");
    [self.tdPaintVCDelegate dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//超过最大选择项时
- (void)photoPickerDidMaximum:(AJPhotoPickerViewController *)picker{
    NSLog(@"超过最大选择项时");
}

//低于最低选择项时
- (void)photoPickerDidMinimum:(AJPhotoPickerViewController *)picker{
    NSLog(@"低于最低选择项时");
}

//选择过滤
- (void)photoPickerDidSelectionFilter:(AJPhotoPickerViewController *)picker{
    NSLog(@"选择过滤");
}

@end
