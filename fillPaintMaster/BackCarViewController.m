//
//  BackCarViewController.m
//  fillPaintMaster
//
//  Created by apple on 15/12/27.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import "BackCarViewController.h"
#import "TDConstants.h"
@interface BackCarViewController ()
@property (weak, nonatomic) IBOutlet UIButton *bBBtn;
@property (weak, nonatomic) IBOutlet UIButton *b2Btn;
@property (weak, nonatomic) IBOutlet UIButton *b1Btn;

@end

@implementation BackCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initButton];
}

-(void)initButton{
    
    [self.bBBtn setTag:CAR_TYPE_BB];
    [self.b1Btn setTag:CAR_TYPE_B1];
    [self.b2Btn setTag:CAR_TYPE_B2];
    
    [self.bBBtn addTarget:self.viewDelegate action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.b1Btn addTarget:self.viewDelegate action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.b2Btn addTarget:self.viewDelegate action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
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
