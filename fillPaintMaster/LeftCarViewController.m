//
//  LeftCarViewController.m
//  fillPaintMaster
//
//  Created by apple on 15/12/27.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import "LeftCarViewController.h"
#import "TDConstants.h"
@interface LeftCarViewController()

@property (weak, nonatomic) IBOutlet UIButton *c1Btn;

@property (weak, nonatomic) IBOutlet UIButton *d1Btn;
@property (weak, nonatomic) IBOutlet UIButton *e1Btn;

@property (weak, nonatomic) IBOutlet UIButton *f1Btn;
@property (weak, nonatomic) IBOutlet UIButton *j1Btn;


@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (weak, nonatomic) IBOutlet UILabel *label4;

@end

@implementation LeftCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initButton];
    
}
-(void)initButton{
    
    [self.c1Btn setTag:CAR_TYPE_C1];
    [self.d1Btn setTag:CAR_TYPE_D1];
    [self.e1Btn setTag:CAR_TYPE_E1];
    [self.f1Btn setTag:CAR_TYPE_F1];
    [self.j1Btn setTag:CAR_TYPE_J1];
    
    [self.c1Btn addTarget:self.viewDelegate action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.d1Btn addTarget:self.viewDelegate action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.e1Btn addTarget:self.viewDelegate action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.f1Btn addTarget:self.viewDelegate action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.j1Btn addTarget:self.viewDelegate action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    

    
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


- (IBAction)uu:(UIButton *)sender {
    if(sender.selected){
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
    }
}
@end
