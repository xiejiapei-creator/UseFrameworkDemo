//
//  zhPopupViewController+Custom.m
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/9.
//

#import "zhPopupViewController+Custom.h"

#define titleKey @"title"
#define imgNameKey @"imageName"

@implementation zhPopupViewController (Custom)

// 切换城市的提示
- (CustomAlertView *)switchCitiesAlert
{
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"提示" message:@"切换城市失败，是否重试？" constantWidth:280];
    return alertView;
}

// 询问喜好的Toast
- (CustomAlertView *)favouriteToastStyle
{
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"同学你好\n告诉我们你的喜好吧" message:@"我们会通过你的喜好为你推荐作品" constantWidth:250];
    alertView.titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:72/255.0 blue:83/255.0 alpha:1.0];
    alertView.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    alertView.messageLabel.textColor = [UIColor blackColor];
    return alertView;
}

// 创建火箭视图
- (OverflyView *)overflyView
{
    // 设置标题属性
    NSMutableAttributedString *attributedTitle = [self setupAttributedTitle:@"通知" subTitle:@"一大波福利即将到来~"];
    
    // 设置内容属性
    NSMutableAttributedString *attributedMessage = [self setupAttributedMessage:@"如果你有一个气球，而你在它的表面画上许多黑点。然后你愈吹它，那些黑点就分得愈开。这就是宇宙间各银河系所发生的现象。我们说宇宙在扩张。"];
    
    // 为使对称透明区域视觉上更加美观，需要设置顶部图片透明区域所占比，无透明区域设置为0即可
    // highlyRatio = 图片透明区域高度 / 图片高度
    CGFloat transparentHeight = 450; // 已知透明区域高度
    UIImage *fireImage = [UIImage imageNamed:@"fire_arrow"];
    OverflyView *overflyView = [[OverflyView alloc] initWithFlyImage:fireImage highlyRatio:(transparentHeight / fireImage.size.height) attributedTitle:attributedTitle attributedMessage:attributedMessage constantWidth:260];
    overflyView.layer.cornerRadius = 4;
    overflyView.messageEdgeInsets = UIEdgeInsetsMake(5, 22, 10, 22);
    overflyView.titleLabel.backgroundColor = [UIColor whiteColor];
    overflyView.titleLabel.textAlignment = NSTextAlignmentCenter;
    overflyView.splitLine.hidden = YES;
    
    return overflyView;
}

// 设置标题属性
- (NSMutableAttributedString *)setupAttributedTitle:(NSString *)title subTitle:(NSString *)subTitle
{
    NSString *titleText = [NSString stringWithFormat:@"%@\n%@", title, subTitle];
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:titleText];
    [attributedTitle addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:[titleText rangeOfString:title]];
    [attributedTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:[titleText rangeOfString:title]];
    [attributedTitle addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:236 / 255.0f green:78 / 255.0f blue:39 / 255.0f alpha:1.0f] range:[titleText rangeOfString:subTitle]];
    [attributedTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:[titleText rangeOfString:subTitle]];
    
    // 字距调整
    [attributedTitle addAttribute:NSKernAttributeName value:@1.5 range:[titleText rangeOfString:subTitle]];
    // 行距调整
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    [attributedTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleText length])];
    
    return attributedTitle;
}

// 设置内容属性
- (NSMutableAttributedString *)setupAttributedMessage:(NSString *)message
{
    NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:message];
    [attributedMessage addAttribute:NSKernAttributeName value:@1.1 range:NSMakeRange(0, [message length])];
    NSMutableParagraphStyle *messageParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    [messageParagraphStyle setLineSpacing:7];
    [attributedMessage addAttribute:NSParagraphStyleAttributeName value:messageParagraphStyle range:NSMakeRange(0, [message length])];
    [attributedMessage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, [message length])];
    [attributedMessage addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:49 / 255.0f green:49 / 255.0f blue:39 / 255.0f alpha:1.0f] range:NSMakeRange(0, [message length])];
    
    return attributedMessage;
}

// 创建窗帘视图
- (CurtainView *)curtainView
{
    CurtainView *curtainView = [[CurtainView alloc] init];
    curtainView.width = ScreenWidth;
    curtainView.height = 300 + SafeAreaInsetsTop;
    
    // 提供按钮的图片和标题
    [curtainView.closeButton setImage:[UIImage imageNamed:@"qzone_close"] forState:UIControlStateNormal];
    NSArray *imageNames = @[@"github", @"paypal", @"pinterest", @"spotify", @"tumblr", @"twitter", @"whatsapp", @"yelp"];
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:imageNames.count];
    for (NSString *imageName in imageNames)
    {
        UIImage *image = [UIImage imageNamed:[@"social-" stringByAppendingString:imageName]];
        [models addObject:[ImageButtonModel modelWithTitle:imageName image:image]];
    }
    curtainView.models = models;
    
    return curtainView;
}

// 创建侧边栏视图
- (SidebarView *)sidebarView
{
    SidebarView *sidebarView = [SidebarView new];
    sidebarView.size = CGSizeMake(ScreenWidth - 90, ScreenHeight);
    sidebarView.backgroundColor = [UIColor colorWithRed:24/255.0 green:28/255.0 blue:45/255.0 alpha:0.9];
    sidebarView.models = @[@"我的故事", @"消息中心", @"我的收藏", @"近期阅读", @"离线阅读"];
    return sidebarView;
}

// 创建全屏视图
- (FullView *)fullView
{
    FullView *fullView = [[FullView alloc] initWithFrame:self.view.window.bounds];
    NSArray *array = @[@"文字", @"照片视频", @"头条文章", @"红包", @"直播", @"点评", @"好友圈", @"更多", @"音乐", @"商品", @"签到", @"秒拍", @"头条文章", @"红包", @"直播", @"点评"];
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:array.count];
    for (NSString *string in array)
    {
        ImageButtonModel *item = [ImageButtonModel new];
        item.icon = [UIImage imageNamed:[NSString stringWithFormat:@"sina_%@", string]];
        item.text = string;
        [models addObject:item];
    }
    fullView.models = models;
    return fullView;
}

// 创建分享视图
- (WallView *)wallView
{
    CGRect rect = CGRectMake(100, 100, ScreenWidth, 300);
    WallView *wallView = [[WallView alloc] initWithFrame:rect];
    wallView.wallHeaderLabel.text = @"此网页由 http.qq.com 提供";
    wallView.wallFooterLabel.text = @"取消";
    wallView.models = [self wallModels];
    wallView.size = [wallView sizeThatFits:CGSizeMake(ScreenWidth, CGFLOAT_MAX)];
    [wallView addCornerRadius:10 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    return wallView;
}

- (NSArray *)wallModels
{
    
    NSArray *arr1 = @[@{titleKey   : @"发送给朋友",
                        imgNameKey : @"sheet_Share"},
                      
                      @{titleKey   : @"分享到朋友圈",
                        imgNameKey : @"sheet_Moments"},
                      
                      @{titleKey   : @"收藏",
                        imgNameKey : @"sheet_Collection"},
                      
                      @{titleKey   : @"分享到\n手机QQ",
                        imgNameKey : @"sheet_qq"},
                      
                      @{titleKey   : @"分享到\nQQ空间",
                        imgNameKey : @"sheet_qzone"},
                      
                      @{titleKey   : @"在QQ浏览器\n中打开",
                        imgNameKey : @"sheet_qqbrowser"}];
    
    NSArray *arr2 = @[@{titleKey   : @"查看公众号",
                        imgNameKey : @"sheet_qqbrowser"},
                      
                      @{titleKey   : @"复制链接",
                        imgNameKey : @"sheet_qzone"},
                      
                      @{titleKey   : @"在QQ浏览器\n中打开",
                        imgNameKey : @"sheet_Collection"},
                      
                      @{titleKey   : @"调整字体",
                        imgNameKey : @"sheet_Moments"},
                      
                      @{titleKey   : @"投诉",
                        imgNameKey : @"sheet_Share"}];
    
    NSMutableArray *array1 = [NSMutableArray array];
    for (NSDictionary *dict in arr1)
    {
        NSString *text = [dict objectForKey:titleKey];
        NSString *imgName = [dict objectForKey:imgNameKey];
        [array1 addObject:[WallItemModel modelWithImage:[UIImage imageNamed:imgName] text:text]];
    }
    
    NSMutableArray *array2 = [NSMutableArray array];
    for (NSDictionary *dict in arr2)
    {
        NSString *text = [dict objectForKey:titleKey];
        NSString *imgName = [dict objectForKey:imgNameKey];
        [array2 addObject:[WallItemModel modelWithImage:[UIImage imageNamed:imgName] text:text]];
    }
    
    return [NSMutableArray arrayWithObjects:array1, array2, nil];
}


@end
