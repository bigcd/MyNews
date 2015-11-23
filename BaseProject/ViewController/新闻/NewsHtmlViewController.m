//
//  NewsHtmlViewController.m
//  BaseProject
//
//  Created by apple-jd03 on 15/11/20.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "NewsHtmlViewController.h"
#import "NewsDetailModel.h"
#import "NewsDetailNetManager.h"
#import "NewsViewModel.h"
#import "NewsReplyViewController.h"
@interface NewsHtmlViewController ()<UIWebViewDelegate>
@property (nonatomic, strong)UIWebView * webView;
@property (nonatomic, strong)NewsDetailDataModel * detailModel;
@property (nonatomic, strong)NSString * replyCount;
@end

@implementation NewsHtmlViewController
- (id)initWithURL:(NSString *)url replyCount:(NSString *)reply{
    if (self = [super init]) {
        self.url = url;
        self.replyCount = reply;
    }
    return self;
}

//http://3g.163.com/ntes/15/1120/21/B8T6A8KN00963VRO.html
//http://c.m.163.com/nc/article/54GI0096|82574/full.html
- (UIWebView *)webView {
    if(_webView == nil) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        [self.view addSubview:self.webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        NSString *path = [NSString stringWithFormat:@"http://c.3g.163.com/nc/article/%@/full.html",self.url];
        [NewsDetailNetManager GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
            self.detailModel = [NewsDetailDataModel detailWithDict:responseObj[self.url]];
            [self showInWebView];
        }];
        UIButton *replyCountBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 84, 45)];
        [replyCountBtn bk_addEventHandler:^(id sender) {
            NewsReplyViewController *vc = [NewsReplyViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        } forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"%@",self.replyCount);
        if ((NSInteger)(self.replyCount) <100) {
            replyCountBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }else{
            replyCountBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
        replyCountBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [replyCountBtn.titleLabel sizeToFit];
        NSString *replyCount = [NSString stringWithFormat:@" %@",self.replyCount];
        [replyCountBtn setTitle:replyCount forState:UIControlStateNormal];
        [replyCountBtn setBackgroundImage:[UIImage imageNamed:@"contentview_commentbacky"] forState:UIControlStateNormal];
        [replyCountBtn setBackgroundImage:[UIImage imageNamed:@"contentview_commentbacky_selected"] forState:UIControlStateSelected];
        UIBarButtonItem *memuseItem = [[UIBarButtonItem alloc]initWithCustomView:replyCountBtn];
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -15;
        self.navigationItem.rightBarButtonItems = @[spaceItem,memuseItem];
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:kBGForAllVC];
    [Factory addBackItemToVCHasColor:self];//改变返回按钮的外观

    [self.webView reload];
    
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showProgress];//旋转提示
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideProgress];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [self hideProgress];
}
#pragma mark - ******************** 拼接html语言
- (void)showInWebView
{
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    //对HTML进行约束
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"CDDetails.css" withExtension:nil]];
    [html appendString:@"</head>"];
    
    [html appendString:@"<body>"];
    //加载HTML的内容
    [html appendString:[self touchBody]];

    [html appendString:@"</body>"];
    
    [html appendString:@"</html>"];
    [self.webView loadHTMLString:html baseURL:nil];
}

- (NSString *)touchBody
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div class=\"title\">%@</div>",self.detailModel.title];
    [body appendFormat:@"<div class=\"time\">%@</div>",self.detailModel.ptime];
    if (self.detailModel.body != nil) {
        [body appendString:self.detailModel.body];
    }
    // 遍历img
    for (NewsDetailDataImgModel *detailImgModel in self.detailModel.img) {
        NSMutableString *imgHtml = [NSMutableString string];
        
        // 设置img的div
        [imgHtml appendString:@"<div class=\"img-parent\">"];
        
        // 数组存放被切割的像素
        NSArray *pixel = [detailImgModel.pixel componentsSeparatedByString:@"*"];
        CGFloat width = [[pixel firstObject]floatValue];
        CGFloat height = [[pixel lastObject]floatValue];
        // 判断是否超过最大宽度
        CGFloat maxWidth = kWindowW * 0.96;
        if (width > maxWidth) {
            height = maxWidth / width * height;
            width = maxWidth;
        }
        
        NSString *onload = @"this.onclick = function() {"
        "  window.location.href = 'sx:src=' +this.src;"
        "};";
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\">",onload,width,height,detailImgModel.src];
        // 结束标记
        [imgHtml appendString:@"</div>"];
        // 替换标记
        [body replaceOccurrencesOfString:detailImgModel.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    return body;
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
