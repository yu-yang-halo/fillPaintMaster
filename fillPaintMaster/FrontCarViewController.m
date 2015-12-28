//
//  FrontCarViewController.m
//  fillPaintMaster
//
//  Created by apple on 15/12/27.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import "FrontCarViewController.h"
#import "TDConstants.h"
@interface FrontCarViewController ()
@property (weak, nonatomic) IBOutlet UIButton *aABtn;
@property (weak, nonatomic) IBOutlet UIButton *a1Btn;
@property (weak, nonatomic) IBOutlet UIButton *a2Btn;

@end

@implementation FrontCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initButton];
}
-(void)initButton{
    
    [self.aABtn setTag:CAR_TYPE_AA];
    [self.a1Btn setTag:CAR_TYPE_A1];
    [self.a2Btn setTag:CAR_TYPE_A2];
    
    [self.aABtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.a1Btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.a2Btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)clickButton:(UIButton *)sender {
    if(sender.selected){
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
    }
    switch (sender.tag) {
        case 0:
            /*
             逻辑处理
             */
            break;
            
        default:
            break;
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

@end
