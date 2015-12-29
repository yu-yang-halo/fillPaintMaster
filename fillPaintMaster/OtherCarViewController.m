//
//  OtherCarViewController.m
//  fillPaintMaster
//
//  Created by apple on 15/12/27.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import "OtherCarViewController.h"
#import "TDButtonView.h"
#import "TDConstants.h"
@interface OtherCarViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation OtherCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float w=self.containerView.frame.size.width;
    float h=self.containerView.frame.size.height;
    float space=(w-100*3)/4.0;
    
    
    for(int i=0;i<3;i++){
        TDButtonView *tdBtnView=[[TDButtonView alloc] initWithFrame:CGRectMake(space*(i+1)+100*i, (h-90)/2, 100, 90)];
        [tdBtnView setTag:i];
        switch(i){
            case 0:{
                
                [tdBtnView.textLabel setText:@"K1-左前反光镜"];
                [tdBtnView.imageView setImage:[UIImage imageNamed:@"k1"]];
                [tdBtnView.numbersLabel setText:@"0"];
                [tdBtnView setTag:CAR_TYPE_K1];
                break;
            }
                case 1:
            {
                [tdBtnView.textLabel setText:@"Q-门把手"];
                [tdBtnView.imageView setImage:[UIImage imageNamed:@"qQ"]];
                [tdBtnView.numbersLabel setText:@"0"];
                [tdBtnView setTag:CAR_TYPE_qQ];
                
                break;
            }
                case 2:
            {
                [tdBtnView.textLabel setText:@"K2-右前反光镜"];
                [tdBtnView.imageView setImage:[UIImage imageNamed:@"k2"]];
                [tdBtnView.numbersLabel setText:@"0"];
                [tdBtnView setTag:CAR_TYPE_K2];
                
                break;
            }
        }
        
       
        UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self.viewDelegate action:@selector(clickView:)];
        [tapGestureRecognizer setNumberOfTapsRequired:1];
        
        [tdBtnView addGestureRecognizer:tapGestureRecognizer];

        
        [self.containerView addSubview:tdBtnView];
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
