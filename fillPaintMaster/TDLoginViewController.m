//
//  TDLoginViewController.m
//  fillPaintMaster
//
//  Created by apple on 16/1/2.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "TDLoginViewController.h"
#import "TDIdCodeViewController.h"
#import <UIView+Toast.h>
#import "ElApiService.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "JPUSHService.h"
const NSString *KEY_USERNAME=@"KEY_USERNAME";
const NSString *KEY_PASSWORD=@"KEY_PASSWORD";

@interface TDLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTxtField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtField;
- (IBAction)clickLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)fogetPass:(id)sender;
- (IBAction)registerUser:(id)sender;
- (IBAction)clickBack:(id)sender;

@end

@implementation TDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.accountTxtField.delegate=self;
    self.passwordTxtField.delegate=self;
    [self.passwordTxtField setSecureTextEntry:YES];
    
    NSString *name=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERNAME];
    NSString *pass=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASSWORD];
    
    if(name!=nil&&pass!=nil){
        [self.accountTxtField setText:name];
        [self.passwordTxtField setText:pass];
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
#pragma mark textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickLogin:(id)sender {
    NSString *username=_accountTxtField.text;
    NSString *password=_passwordTxtField.text;
    if([username isEqualToString:@"" ]||[password isEqualToString:@""]){
        [self.view makeToast:@"用户名或密码不能为空"];
    }else{
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.labelText = @"登录中...";
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
          BOOL resultYN=[[ElApiService shareElApiService] appUserLogin:username password:password shopId:-1];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                if(resultYN){
                    
                    NSString *type=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_TYPE];
                    
                    NSSet *tags=[NSSet setWithObjects:type, nil];
                    [JPUSHService setTags:tags alias:username fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                        
                    }];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:username forKey:KEY_USERNAME];
                     [[NSUserDefaults standardUserDefaults] setObject:password forKey:KEY_PASSWORD];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                }else{
                    [self.view makeToast:@"用户名或密码错误"];
                }
            });
         
            
        });
    }
}


- (IBAction)registerUser:(id)sender {
    TDIdCodeViewController *tdIdCodeVC=[[TDIdCodeViewController alloc] init];

    [self presentViewController:tdIdCodeVC animated:YES completion:^{
        
    }];
}

- (IBAction)clickBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
