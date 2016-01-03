//
//  TDPassFindViewController.m
//  fillPaintMaster
//
//  Created by apple on 16/1/2.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "TDPassSetViewController.h"

@interface TDPassSetViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *txtField0;
@property (weak, nonatomic) IBOutlet UITextField *txtField1;
@property (weak, nonatomic) IBOutlet UIButton *actButton;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
- (IBAction)clickBack:(id)sender;


@end

@implementation TDPassSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}
-(void)initView{
    if(_passSetType==TDPassSetType_FINDPASS){
        [self.actButton setTitle:@"找回密码" forState:UIControlStateNormal];
        [self.txtField0 setPlaceholder:@"请输入账号或手机号"];
        [self.txtField1 setPlaceholder:@"输入新密码"];
        [self.bgImageView setImage:[UIImage imageNamed:@"loginbg"]];
        
    }else{
        [self.actButton setTitle:@"注册" forState:UIControlStateNormal];
        [self.txtField0 setPlaceholder:@"请输入密码"];
        [self.txtField1 setPlaceholder:@"输入确认密码"];
        
        [self.bgImageView setImage:[UIImage imageNamed:@"findpassbg"]];
        
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

- (IBAction)clickBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
