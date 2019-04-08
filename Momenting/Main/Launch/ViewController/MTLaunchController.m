//
//  MTLaunchController.m
//  Momenting
//
//  Created by xiaobai zhang on 2019/3/26.
//  Copyright © 2019 xiaobai zhang. All rights reserved.
//

#import "MTLaunchController.h"
#import "ViewController.h"
#import "FLBaseWebViewController.h"
#import "MTUserInfoDefault.h"


@interface MTLaunchController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textLabel;

@end

@implementation MTLaunchController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *text =  @"感谢您使用你的专属记事本\n\n"
    
    "我们依据最新法律规定更新了《用户协议》，请查阅。\n\n"
    
    "同时，为向您提供您所期待的服务，您同意我们根据《隐私政策》对您的个人信息进行采集、使用和共享。保护您的隐私对我们至关重要，我们将军收适用法律规定的要求对您的信息予以充分保护，并使您能够更好的行使个人权利。根据您的选择，本软件在使用过程中可能需要申请联网，定位等权限。\n\n"
    "请您务必审慎、仔细阅读《用户协议》和《隐私政策》相关条款，特别是免除或者限制责任的条款、法律适用和争议解决条款，您可以点击上述链接完整阅读隐私政策文本。\n\n";
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x999999], NSFontAttributeName: self.textLabel.font}];
    NSDictionary *protocAttributes = @{NSForegroundColorAttributeName: [UIColor redColor],
                                       NSFontAttributeName: self.textLabel.font};
    
    
    NSMutableAttributedString *lastAttributedString = [[NSMutableAttributedString alloc] initWithString:@"【特别提示】当您点击“同意”即表示您已充分阅读、理解并接受《用户协议》及《隐私政策》。\n\n\n\n" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x999999], NSFontAttributeName: self.textLabel.font}];
    
    NSRange range1 = [lastAttributedString.string rangeOfString:@"《用户协议》"];
    NSRange range2 = [lastAttributedString.string rangeOfString:@"《隐私政策》"];
    [lastAttributedString setAttributes:protocAttributes range:range1];
    [lastAttributedString setAttributes:protocAttributes range:range2];
    
    [lastAttributedString addAttribute:NSLinkAttributeName
                             value:@"protocol1://"
                                 range:[[lastAttributedString string] rangeOfString:@"《用户协议》"]];
    [lastAttributedString addAttribute:NSLinkAttributeName
                             value:@"protocol2://"
                                 range:[[lastAttributedString string] rangeOfString:@"《隐私政策》"]];
    
    [attributedString appendAttributedString:lastAttributedString];

    
    self.textLabel.attributedText = attributedString;
    self.textLabel.delegate = self;
    
    //http://note.youdao.com/noteshare?id=c806fba036b23c0750f9c59f8db1273b
    //http://note.youdao.com/noteshare?id=0dd1abb301bec7f8f77b2dbb4f9af0c6 用户协议
}

- (IBAction)notAgreeButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您需同意相关协议方可使用本软件" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alert show];
}


- (IBAction)agreeButtonClicked:(id)sender
{
    [MTUserInfoDefault saveAgreeSecretList];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {

    NSString *urlString = nil;
    NSString *title = nil;
    if ([[URL scheme] isEqualToString:@"protocol1"]) {
        title = @"用户协议";
        urlString = @"http://note.youdao.com/noteshare?id=0dd1abb301bec7f8f77b2dbb4f9af0c6";
    } else if ([[URL scheme] isEqualToString:@"protocol2"]) {
        title = @"隐私条款";
        urlString = @"http://note.youdao.com/noteshare?id=c806fba036b23c0750f9c59f8db1273b";
    }
    
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (urlString != nil) {
        
        FLBaseWebViewController *web = [[FLBaseWebViewController alloc] initWithUrl:urlString];
        web.isShowNavigation = YES;
        web.isDisMiss = YES;
        web.navigationTitle = title;
        [self presentViewController:web animated:YES completion:nil];
        return YES;
    }
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

@end
