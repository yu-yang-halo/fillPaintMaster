//
//  TopCarViewController.m
//  fillPaintMaster
//
//  Created by apple on 15/12/27.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import "TopCarViewController.h"
#import "TDConstants.h"
@interface TopCarViewController ()
@property (weak, nonatomic) IBOutlet UIButton *iIBtn;
@property (weak, nonatomic) IBOutlet UIButton *hHBtn;
@property (weak, nonatomic) IBOutlet UIButton *gGBtn;

@end

@implementation TopCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initButton];
}

-(void)initButton{
    [self.gGBtn setTag:CAR_TYPE_GG];
    [self.hHBtn setTag:CAR_TYPE_HH];
    [self.iIBtn setTag:CAR_TYPE_II];
    
    
    [self.gGBtn addTarget:self.viewDelegate action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.hHBtn addTarget:self.viewDelegate action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.iIBtn addTarget:self.viewDelegate action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
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
