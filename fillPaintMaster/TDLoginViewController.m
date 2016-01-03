//
//  TDLoginViewController.m
//  fillPaintMaster
//
//  Created by apple on 16/1/2.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "TDLoginViewController.h"
#import "TDIdCodeViewController.h"
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
    
    
}
-(void)initView{
    [self.loginButton.layer setCornerRadius:5];
    
    [self.passwordTxtField setSecureTextEntry:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
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
    
}
- (IBAction)fogetPass:(id)sender {
    TDIdCodeViewController *tdIdCodeVC=[[TDIdCodeViewController alloc] init];
    [tdIdCodeVC setIdCodeType:TDIdCodeType_GETVCODE];
    [self presentViewController:tdIdCodeVC animated:YES completion:^{
        
    }];
}

- (IBAction)registerUser:(id)sender {
    TDIdCodeViewController *tdIdCodeVC=[[TDIdCodeViewController alloc] init];
    [tdIdCodeVC setIdCodeType:TDIdCodeType_REGISTER];
    [self presentViewController:tdIdCodeVC animated:YES completion:^{
        
    }];
}

- (IBAction)clickBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
