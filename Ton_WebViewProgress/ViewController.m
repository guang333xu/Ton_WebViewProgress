//
//  ViewController.m
//  Ton_WebViewProgress
//
//  Created by wang on 16/1/6.
//  Copyright © 2016年 王光旭. All rights reserved.
//

#import "ViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "Masonry.h"

#define kFILEPROTOCOL @"file://"

@interface ViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate, UISearchBarDelegate>
//@property (strong, nonatomic) UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NJKWebViewProgress *progressProxy;
@property (strong, nonatomic) NJKWebViewProgressView *progressView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBack;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForword;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.webView.backgroundColor = [UIColor whiteColor];
    //webView
//    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
//    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    
//    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
//    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).width.insets(padding);
//    }];
    
    //progress
    self.progressProxy = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = self.progressProxy;
    self.progressProxy.webViewProxyDelegate = self;
    self.progressProxy.progressDelegate = self;
    
    //progressView
    CGFloat progressBarHeight = 2.f;
    CGRect searchBarBounds = self.searchBar.frame;
    CGRect barFrame = CGRectMake(0, 20 + searchBarBounds.size.height - progressBarHeight, searchBarBounds.size.width, progressBarHeight);
    self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.progressView];
    
    self.goForword.enabled = NO;
    self.goBack.enabled = NO;
    
    [self loadBaidu];
}

#pragma mark 设置前进后退按钮状态
-(void)setBarButtonStatus{
    if (self.webView.canGoBack) {
        self.goBack.enabled = YES;
    }else{
        self.goBack.enabled = NO;
    }
    
    if (self.webView.canGoForward) {
        self.goForword.enabled = YES;
    }else{
        self.goForword.enabled = NO;
    }

}
- (IBAction)goBack:(UIBarButtonItem *)sender {
    [self.webView goBack];
}

- (IBAction)goForword:(UIBarButtonItem *)sender {
    [self.webView goForward];
}

- (IBAction)refreshWebView:(UIBarButtonItem *)sender {
    if (self.webView.isLoading){
        [self.webView stopLoading];
        [self.refreshButton setBackgroundImage:[UIImage imageNamed:@"playing_btn_play_h"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    else{
        [self.webView reload];
    }
    
    [self setBarButtonStatus];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.view endEditing:YES];
    [self.searchBar resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

-(void)loadBaidu{
//    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]];
//    [_webView loadRequest:req];
    
    NSString *localHTMLPageName = @"HtmlPage4";
    
    NSString *localHTMLPageFilePath = [[NSBundle mainBundle] pathForResource:localHTMLPageName ofType:@"html"];
    
    NSURL *localHTMLPageFileURL = [NSURL fileURLWithPath:localHTMLPageFilePath];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:localHTMLPageFileURL]];
    
}




#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
     [self.progressView setProgress:progress animated:YES];
}

#pragma mark 显示actionsheet
-(void)showSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitle{
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:title delegate:nil cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitle, nil];
    [actionSheet showInView:self.view];
}


#pragma mark - WebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    //显示网络请求加载
    [UIApplication sharedApplication].networkActivityIndicatorVisible=true;

    [self.refreshButton setBackgroundImage:[UIImage imageNamed:@"playing_btn_pause_h"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //隐藏网络请求加载图标
    [UIApplication sharedApplication].networkActivityIndicatorVisible=false;
    //设置按钮状态
    [self setBarButtonStatus];
    [self.searchBar resignFirstResponder];
    
  
        //加载js文件
        NSString *path=[[NSBundle mainBundle] pathForResource:@"MyJS.js" ofType:nil];
        NSString *jsStr=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        //加载js文件到页面
        [_webView stringByEvaluatingJavaScriptFromString:jsStr];

    if (self.refreshButton) {
        [self.refreshButton setBackgroundImage:[UIImage imageNamed:@"playing_btn_play_h"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    NSLog(@"error detail:%@",error.localizedDescription);
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:@"网络连接发生错误!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    [alert show];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    NSLog(@"%@", request.URL.absoluteString);
    
    
    if ([request.URL.scheme isEqual:@"kcactionsheet"]) {
        NSString *paramStr = request.URL.query;
        NSArray *params = [[paramStr stringByRemovingPercentEncoding] componentsSeparatedByString:@"&"];
        id otherButton = nil;
        if (params.count > 3) {
            otherButton = params[3];
        }
        [self showSheetWithTitle:params[0] cancelButtonTitle:params[1] destructiveButtonTitle:params[2] otherButtonTitles:otherButton];
        return false;
    }
    return true;

}
#pragma mark 浏览器请求
-(void)request:(NSString *)urlStr{
    //创建url
    NSURL *url;
    
    //如果file://开头的字符串则加载bundle中的文件
    if([urlStr hasPrefix:kFILEPROTOCOL]){
        //取得文件名
        NSRange range= [urlStr rangeOfString:kFILEPROTOCOL];
        NSString *fileName=[urlStr substringFromIndex:range.length];
        url=[[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
                
    }else if(urlStr.length>0){
        //如果是http请求则直接打开网站
        if ([urlStr hasPrefix:@"http"]) {
            url=[NSURL URLWithString:urlStr];
        }else{//如果不符合任何协议则进行搜索
            urlStr=[NSString stringWithFormat:@"http://m.bing.com/search?q=%@",urlStr];
        }
        urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//url编码
        url=[NSURL URLWithString:urlStr];
        
    }
    
    //创建请求
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    //加载请求页面
    [_webView loadRequest:request];
}

#pragma mark - SearchBar 代理方法
#pragma mark 点击搜索按钮或回车



-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (self.webView.loading) {
        [self.webView stopLoading];
    }
    [self request:searchBar.text];
    NSLog(@"%@", searchBar.text);

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
