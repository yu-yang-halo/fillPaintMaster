//
//  TDCarInfoModel.m
//  fillPaintMaster
//
//  Created by apple on 16/1/10.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "TDCarInfoModel.h"


@interface TDCarInfoModel()<UITextFieldDelegate>
{
    TDCarInfoData *carInfo;
    UIView    *carInfoView;
}

@property (weak, nonatomic) IBOutlet UITextField *cphTxtField;//车牌号
@property (weak, nonatomic) IBOutlet UITextField *cxTxtField;//车型
@property (weak, nonatomic) IBOutlet UITextField *fdjTxtField;//发动机
@property (weak, nonatomic) IBOutlet UITextField *cjhTxtField;//车架号
@property (weak, nonatomic) IBOutlet UITextField *gcsjTxtField;//购车时间
@property (weak, nonatomic) IBOutlet UITextField *lcTxtField;//里程

@end
@implementation TDCarInfoModel

-(instancetype)init{
    self=[super init];
    if(self){
        carInfo=[[TDCarInfoData alloc] init];
        carInfoView=[[[NSBundle mainBundle] loadNibNamed:@"CarInfoView" owner:self options:nil] lastObject];
        [self initTextField];
    }
    return self;
}

-(void)initTextField{
    self.cphTxtField.delegate=self;
    [self.cphTxtField becomeFirstResponder];
    
    [self.cphTxtField setReturnKeyType:UIReturnKeyNext];
    
    self.cxTxtField.delegate=self;
    [self.cxTxtField setReturnKeyType:UIReturnKeyNext];
    
    self.fdjTxtField.delegate=self;
    [self.fdjTxtField setReturnKeyType:UIReturnKeyNext];
    
    self.cjhTxtField.delegate=self;
    [self.cjhTxtField setReturnKeyType:UIReturnKeyNext];
    
    self.gcsjTxtField.delegate=self;
    [self.gcsjTxtField setReturnKeyType:UIReturnKeyNext];
    
    self.lcTxtField.delegate=self;
     [self.lcTxtField setReturnKeyType:UIReturnKeyDone];
}

-(UIView *)carInfoView{
   return carInfoView;
}

-(TDCarInfoData *)carInfoData{
    [carInfo setCphTxt:_cphTxtField.text];
    [carInfo setCxTxt:_cxTxtField.text];
    [carInfo setFdjTxt:_fdjTxtField.text];
    [carInfo setCjhTxt:_cjhTxtField.text];
    [carInfo setGcsjTxt:_gcsjTxtField.text];
    [carInfo setLcTxt:_lcTxtField.text];
    return carInfo;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
 
    if (textField==_cphTxtField) {
         [_cxTxtField becomeFirstResponder];
    }else if(textField==_cxTxtField){
        [_fdjTxtField becomeFirstResponder];
    }else if(textField==_fdjTxtField){
        [_cjhTxtField becomeFirstResponder];
    }else if (textField==_cjhTxtField){
        [_gcsjTxtField becomeFirstResponder];
    }else if (textField==_gcsjTxtField){
        [_lcTxtField becomeFirstResponder];
    }else if(textField==_lcTxtField){
        [textField resignFirstResponder];
    }
    
    return YES;
}


@end



//*******************TDCarInfo*******

@implementation TDCarInfoData

@end