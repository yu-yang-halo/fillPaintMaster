//
//  TDIdCodeViewController.m
//  fillPaintMaster
//
//  Created by apple on 16/1/2.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "TDIdCodeViewController.h"
#import "TDPassSetViewController.h"
@interface TDIdCodeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

@property (weak, nonatomic) IBOutlet UITextField *vcodeTxtField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)clickNext:(id)sender;

- (IBAction)clickBack:(id)sender;

@end

@implementation TDIdCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
}
-(void)initView{
    if(_idCodeType==TDIdCodeType_GETVCODE){
        [self.titleLabel setText:@"获取验证码"];
    }else{
        [self.titleLabel setText:@"注册页面"];
    }
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
    TDPassSetViewController *tdPassSetVC=[[TDPassSetViewController alloc] init];
    
    if(_idCodeType==TDIdCodeType_GETVCODE){
        [tdPassSetVC setPassSetType:TDPassSetType_FINDPASS];
    }else{
        [tdPassSetVC setPassSetType:TDPassSetType_REGISTER];
    }
    [self presentViewController:tdPassSetVC animated:YES completion:^{
        
    }];
}

- (IBAction)clickBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
