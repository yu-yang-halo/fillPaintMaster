//
//  TDIdCodeViewController.m
//  fillPaintMaster
//
//  Created by apple on 16/1/2.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "TDIdCodeViewController.h"
#import <UIView+Toast.h>
#import "ElApiService.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface TDIdCodeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

@property (weak, nonatomic) IBOutlet UITextField *passTxtField;
@property (weak, nonatomic) IBOutlet UITextField *repassTxtField;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)clickNext:(id)sender;

- (IBAction)clickBack:(id)sender;

@end

@implementation TDIdCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.phoneNumber.delegate=self;
    self.passTxtField.delegate=self;
    self.repassTxtField.delegate=self;
  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickNext:(id)sender {
    
    NSString *pass=self.passTxtField.text;
    NSString *repass=self.repassTxtField.text;
    NSString *phone=self.phoneNumber.text;
    if ([self isEmpty:pass]||[self isEmpty:repass]||[self isEmpty:phone]) {
        [self.view makeToast:@"数据不能为空"];
    }else if(phone.length!=11){
         [self.view makeToast:@"请输入手机号"];
    }else if(![pass isEqualToString:repass]){
        [self.view makeToast:@"两次输入密码不一致"];
    }else{
        dispatch_queue_t newQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.labelText = @"注册中...";

        dispatch_async(newQueue, ^{
           
           BOOL isSUC=[[ElApiService shareElApiService] createUser:phone password:pass email:@"" phone:phone shopId:-1];
            
            
           dispatch_async(dispatch_get_main_queue(), ^{
               [hud hide:YES];
               
               if (isSUC) {
                   [self.view makeToast:@"注册成功"];
                   [self dismissViewControllerAnimated:YES completion:^{
                       
                   }];
               }
               
           });
        });
    }
    

}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)isEmpty:(NSString *)str{
    if(str==nil){
        return YES;
    }
    return [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""];
}

- (IBAction)clickBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
