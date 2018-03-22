//
//  MineViewController.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/19.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "MineViewController.h"
#import "TextImageHtmlLabelCell.h"
#import "TextImageWebViewCell.h"

@interface MineViewController () <UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy)NSString *contentString;
@property (nonatomic, assign)CGFloat height;

@property (nonatomic, strong)UITextView *myTextView;

//文本存储，存放需要展示的文本,由于NSTextStorage继承自NSMutableAttributedString所以具有对一部分文本设置属性的能力
@property(nonatomic)NSTextStorage *textStorage;

//文本容器，他定义文本布局的区域，类似画布,他可以指定那部分可以布局，那部分不能布局，不能布局的部分称之为排除路径
@property(nonatomic)NSTextContainer *textContainer;

//布局管理器，是一个中间组件，他协调文本存储和文本容器,把上面二个组件结合在一起
//先从文本存储中找到字符，根据字体转换为对应的字型（字符对应的图片）
//根据文本容器指定的区域进行逐行的布局
@property(nonatomic)NSLayoutManager *layoutManager;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildRichTextUI];
}

- (void)buildRichTextUI {
    
    NSString *tempString = @"<p></p><p></p><p></p><p></p><p></p><p></p><p></p><p></p><p><img  src='http://cf.52cold.com/Public/upload/news/2017/05-05/590c430a5e478.png' title='index.png'/></p><p>D1<br/></p><p>北京-上海- 酒店<br/></p><p>北京前往上海</p><p>上海虹桥机场/火车站全天接站（10:00—20：00发车前往酒店，每班车发车间隔时间不超过2小时）</p><p>上海浦东机场全天接站（10:00—20：00发车前往酒店，每班车发车间隔时间不超过2小时</p><p>D2上海<br/></p><p>早上统一08:30集合，车赴上海迪士尼乐园</p><p>入园须知：</p><p>凭有效证件至上海迪士尼乐园验票口直接验证入园。</p><p>入园时，购票时登记的身份证件持有人本人必须在场，且需与同一订单上的所有同行游客一同入园。</p><p>上海迪士尼乐园的所有门票均为指定日票，即游客只能在购票时所选定的日期当天入园。针对某个具体入园日，每单每个身份证件最多可购买5张门票。</p><p>凭有效身份证件可在入园当日多次进出。</p><p>未满16周岁的未成年人必须由16周岁或以上的成年游客代为购票，且必须在成年游客的陪同下方能入园游玩。</p><p>游览【上海迪士尼乐园】：一座神奇王国风格的迪士尼主题乐园，包含六个主题园区：米奇大街、奇想花园、探险岛、宝藏湾、明日世界、梦幻世界。六大主题园区充满花园、舞台表演、游乐项目——其中还有许多崭新体验。</p><p>奇幻童话城堡：位于迪斯尼内的奇幻童话城堡，是全球最高、最大、最具互动性的迪士尼城堡。</p><p>创极速光轮：在明日世界，一座巨大的、色彩绚丽变幻的穹顶在夜空点亮。这里便是迪士尼乐园里最紧张刺激的极速飞车项目之一-----创极速光轮!</p><p>巴斯光年星际营救：星际营救，全新的故事结合升级互动式的目标射击系统将使其成为上海迪士尼乐园中最具吸引力的景点之一！大家想要加入巴斯光年星际营救，一起“飞向太空，宇宙无限”吗？</p><p>幻想曲旋转木马：专为上海迪士尼乐园设计建造的幻想曲旋转木马将呈现迪士尼开创性电影《幻想曲》中的经典角色和交响曲，让游客在木马上跟着优美的音乐旋转！</p><p>雷鸣山漂流：探险岛是上海迪士尼乐园独有的全新主题园区！上海迪士尼的漂流被定名为“雷鸣山漂流”，而雷鸣山就是上海迪士尼的最高假山。以往假山上安排的可都是矿车，这次变成了漂流，惊险、有趣程度真是令人期待！这里前所未有的探险故事和原创的亚柏栎部落文明，将使这片全新主题园区成为上海迪士尼乐园的一大特色。</p><p>七个小矮人矿山车：游客可以在七个小矮人矿山车搭上一趟充满欢声笑语的矿山车。只不过当矿山车遇上七个小矮人，小矮人和白雪公主难道要搬家去矿山，白雪公主还能雪白么……</p><p>沉落宝藏之战：“宝藏湾”园区中的主要景点包括一个全新的高科技船载游乐项目：“加勒比海盗—沉落宝藏之战”。该大型景点将带领游客来到海洋深处，穿过海盗战舰，直击激烈海战，同时在海上乘风破浪、勇往直前，体验一般的海盗探险历程。</p><p>号外：</p><p>舞台秀：《人猿泰山：丛林的呼唤》将把迪士尼故事与中国杂技完美融合在一起；《风暴来临——杰克船长之惊天特技大冒险》取材于迪士尼经典系列电影《加勒比海盗》，专门设计了“沉浸式”的互动表演，届时人们将与杰克船长一同体验海上冒险！</p><p>街头表演：不仅会有来自美国加州的唐老鸭打太极拳表演，游客还可以与《星球大战》中的天行者、黑武士等人物在街头偶遇。观看迪斯尼夜景灯光秀</p><p>晚09:00-09:30统一景区门口集合返回酒店。</p><p>D3上海<br/></p><p>早餐后，再次车赴迪士尼乐园，游览【上海迪士尼乐园】：一座神奇王国风格的迪士尼主题乐园，包含六个主题园区：米奇大街、奇想花园、探险岛、宝藏湾、明日世界、梦幻世界。六大主题园区充满花园、舞台表演、游乐项目——其中还有许多崭新体验。<br/></p><p>D4上海</p><p>早餐后，根据返程时间送站（08:00—12:00前送站）<br/></p><p>温馨的家</p><p>备注</p><p>1、我们为08:00-20:00点间抵达的游客朋友提供了免费班车接驳服务。班车时间间隔2小时，请早到的稍作等待。（如时间宝贵不愿等待的，我们也同时提供有偿的接送站服务<br/></p><p>2.免费班车接送服务为跟团增值服务，不享受不退费用。</p><p>标准</p><p>1、&amp;nbsp;住宿：仅含1床2晚费用，如有单人需补房差。<br/></p><p>舒适型（三星未挂牌酒店）：300元/人</p><p>豪华型（四星级未挂牌酒店）：450元/人</p><p>超级豪华型（五星未挂牌酒店）：700元/人</p><p>准三参考酒店：上海紫锦，申花花木，申花芳甸路，海霞宾馆，祖杰宾馆，欣勃宾馆，旺武宾馆，隆阳商务宾馆，凤雅华漕宾馆，凤雅莘松宾馆，陈太商务宾馆，旗胜商务宾馆，圣安客宾馆，蓝波湾宾馆，斯亚概念等如家、莫泰、格林豪泰等快捷酒店<br/></p><p>准四参考酒店：富驿时尚柳营路、钱桥国际大酒店、锦洲大酒店、上海云上四季、上海丽爵酒店、上海喆啡酒店、上海金富门大酒店；上海维也纳国际酒店；上海麦豪德精品酒店；上海夏洛特精品酒店，阳坤华府国际酒店；悦兴国际大酒店；上海芭堤雅假日酒店；海荷欧风大酒店；上海富驿时尚酒店北外滩店；上海宝隆居家酒店，上海瓷之源酒店，浦东辅特戴斯酒店，上海利爵商务酒店，上海如家精选酒店，上海新海霞大酒店，上海云上四季商务酒店；上海迦南大酒店；上海华晶宾馆；上海喆.啡酒店；上海卓•酒店迪斯尼申康路店；上海栀子酒店，上海零点依精品酒店；上海富驿时尚酒店；上海水庭酒店（水庭度假村）；上海欧帝臻品酒店；上海龙添大酒店；上海雅假日酒店；虹桥思贝酒店；上海全季酒店；上海龙添大酒店；上海翰森假日。</p><p>准五参考酒店：上海法莱德，上海锦江都城市北店、上海金古源豪生大酒店、上海皇冠假日大酒店、上海外高桥喜来、登大酒店，上海美兰湖皇冠假日酒店，北上海大酒店，上海浦东宝龙丽生酒店、</p><p>2、&amp;nbsp;接送：含机场或火车站—酒店之间2趟，酒店—迪士尼之间往返2趟（全程含4次接送服务）</p><p>门票&amp;nbsp;：含1成人迪士尼门票，只限本人当天使用。不可换人，换日期进园。</p><p>注意事项</p><p>1、&amp;nbsp;接送站时间如超出我们规定范围，并且人数低于6人的，我们按200/次接送一趟的费用收费。<br/></p><p>2、&amp;nbsp;接站后需要等候，送站时间如有变动需要提前预约。</p><p>3、&amp;nbsp;酒店当天入住时间为14:00后（如有特殊要求需提前联系我社），酒店当天退房时间为12:00</p><p>4、&amp;nbsp;14:00前出发的航班车次，09点左右（或更早）酒店集合班车赶赴机场/车站，结束愉快行程。</p><p>5、&amp;nbsp;13:00班车出发，送虹桥机场/车站/浦东机场，乘高铁/动车/航班返回温馨的家。</p><p>6、&amp;nbsp;如您的返程航班或车次早于14：00点，我们安排早送机。</p><p>7、&amp;nbsp;②虹桥返程航班或车次建议选择16：00以后的，我们13：00安排统一送站</p><p>8、&amp;nbsp;③浦东机场返程的航班建议选择17：00以后的，我们13：00安排统一送站。</p><p>9、&amp;nbsp;☆应上海机场通知，国际出发提前4小时办理（即提前6小时左右赴机场），国内出发提前2小时理（即提前4小时左右赴机场）。请妥善选择乘坐班车的时间，预留足够的时间应对突发状况。</p><p>10、 ☆凭本人有效证件，自行办理登机/登车、安检手续。</p><p>☆（如时间宝贵的，我们也同时提供有偿的送站服务：浦东机场300元/车，限乘4人无行李舱；虹桥机场/火车</p><p>站 250元/车，限乘4人无行李舱）</p><p><br/></p>";
    NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
                            "<head> \n"
                            "<style type=\"text/css\"> \n"
                            "body {font-size:15px;}\n"
                            "</style> \n"
                            "</head> \n"
                            "<body>"
                            "<script type='text/javascript'>"
                            "window.onload = function(){\n"
                            "var $img = document.getElementsByTagName('img');\n"
                            "for(var p in  $img){\n"
                            " $img[p].style.width = '100%%';\n"
                            "$img[p].style.height ='auto'\n"
                            "}\n"
                            "}"
                            "</script>%@"
                            "</body>"
                            "</html>",tempString];

    self.myTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    self.myTextView.attributedText = attributeString;
    [self.view addSubview:self.myTextView];
    
    //遍历富文本得到NSTextAttachment类，改变图片的大小
//    [self.descriptionString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.descriptionString.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
//        
//        if ([value isKindOfClass:[NSTextAttachment class]]) {
//            NSTextAttachment * attachment = value;
//            CGFloat height = attachment.bounds.size.height;
//            attachment.bounds = CGRectMake(0, 0, kScreenWidth-20, height);
//        }
//        
//    }];
    
//
    //生成显示组件textView
//    self.myTextView = [[UITextView alloc] initWithFrame:rect textContainer:self.textContainer];
    
//    [self.view insertSubview:self.myTextView belowSubview:self.imageView];
    
    //给textContianer指定排除路径
//    self.textContainer.exclusionPaths = @[[self exclusionPath]];
}


//-(UIBezierPath*)exclusionPath
//{
//    CGRect rect = self.imageView.frame;
//    //把 图片的frame 从 相对self.view转换到 self.textView
//    CGRect convertRect = [self.myTextView convertRect:rect fromView:self.view];
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:convertRect];
//    return path;
//}
//
////使用正值表达式来查找字符
//-(void)strockWordUsingRedColorUndlerLine:(NSString*)word{
//    //生成则在表达式
//    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:word options:0 error:nil];
//    //使用正则式来匹配字符串
//    NSArray *resultArray = [regular matchesInString:TEXT options:0 range:NSMakeRange(0, TEXT.length)];
//    for (NSTextCheckingResult *result in resultArray) {
//        //遍历匹配成功的每一项，针对每一项设置属性
//        //指定属性红色和下划线
//        NSDictionary *dict = @{NSForegroundColorAttributeName:[UIColor redColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]};
//        [self.textStorage addAttributes:dict range:result.range];
//    }
//}
//




- (void)buildUI {
    [self.view addSubview:self.tableView];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 200;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [_tableView registerNib:[UINib nibWithNibName:@"TextImageHtmlLabelCell" bundle:nil] forCellReuseIdentifier:@"TextImageHtmlLabelCell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TextImageWebViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TextImageWebViewCell class])];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    TextImageHtmlLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextImageHtmlLabelCell"];
//    [cell.myActivityView startAnimating];
//    NSString *str = [NSString stringWithFormat:@"<head><style>img{max-width:%f !important;}</style></head>%@",kScreenWidth,_contentString];
//    cell.nameLabel.attributedText = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    TextImageWebViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TextImageWebViewCell class])];
    NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
                            "<head> \n"
                            "<style type=\"text/css\"> \n"
                            "body {font-size:15px;}\n"
                            "</style> \n"
                            "</head> \n"
                            "<body>"
                            "<script type='text/javascript'>"
                            "window.onload = function(){\n"
                            "var $img = document.getElementsByTagName('img');\n"
                            "for(var p in  $img){\n"
                            " $img[p].style.width = '100%%';\n"
                            "$img[p].style.height ='auto'\n"
                            "}\n"
                            "}"
                            "</script><p>aWER <br/></p>"
                            "</body>"
                            "</html>"];
    cell.myWebView.delegate = self;
    cell.myWebView.scrollView.scrollEnabled = NO;
    [cell.myWebView loadHTMLString:htmlString baseURL:nil];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    webView.frame=CGRectMake(0, 0, self.view.frame.size.width,height + 20);
    
    // 防止死循环
    if (height != _height) {
        _height = height;
        if (_height > 0) {
            // 刷新cell高度
            [self.tableView reloadData];
        }
    }
}

@end
