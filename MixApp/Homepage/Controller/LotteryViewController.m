//
//  LotteryViewController.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/26.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "LotteryViewController.h"
#import "TextImageWebViewCell.h"
#import "Person.h"
#import <objc/message.h>
#import "UIImage+RunTimeImage.h"
#import "NSObject+Property.h"

@interface LotteryViewController () <UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)CGFloat height;

@end

@implementation LotteryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"抽奖";
    [self dynamicAppendingMetnod];
}

- (void)runTimeMechanism {
    //runTime  简介
    /*
     一、runtime简介
     
     RunTime简称运行时。OC就是运行时机制，也就是在运行时候的一些机制，其中最主要的是消息机制。
     对于C语言，函数的调用在编译的时候会决定调用哪个函数。
     对于OC的函数，属于动态调用过程，在编译的时候并不能决定真正调用哪个函数，只有在真正运行的时候才会根据函数的名称找到对应的函数来调用。
     事实证明：
     在编译阶段，OC可以调用任何函数，即使这个函数并未实现，只要声明过就不会报错。
     在编译阶段，C语言调用未实现的函数就会报错。
     
     C静态调用  OC动态调用 可能编译过，运行时找不到方法
     消息机制  Xcode5之后，苹果不建议使用底层方法
     需要导入头文件#import <objc/message.h>
     Build Setting:编译设置
     搜索  msg   使用底层时 设置为NO
     
     二、runtime作用

     */
}

/*
     1.发送消息
     
     方法调用的本质，就是让对象发送消息。
     objc_msgSend,只有对象才能发送消息，因此以objc开头.
     使用消息机制前提，必须导入#import <objc/message.h>
     消息机制简单使用
 */
- (void)msgMechanism {
    //     类也是一种特殊对象
    Class PersonClass = [Person class];
    objc_msgSend(PersonClass, @selector(run));
    [PersonClass performSelector:@selector(run)];
    
    
    //创建Person对象
    Person *p = [[Person alloc] init];
    
    //修改私有属性的值
    [p setValue:@"想把我唱给你听" forKey:@"name"];
    //访问私有属性的值
    NSString *name = [p valueForKey:@"name"];
    
    //调用对象方法
    [p eat];
    //本质：让对象发送消息
    objc_msgSend(p,@selector(eat));

    //调用类方法的方式:两种
    //第一种通过类名调用
    [Person eat];
    //第二种通过类对象调用
    [[Person class] eat];
    
    //用类名调用类方法，底层会自动把类名转换为类对象调用
    //本质：让类对象发送消息
    objc_msgSend([Person class],@selector(eat));

}

/*
     2.交换方法
     
     开发使用场景:系统自带的方法功能不够，给系统自带的方法扩展一些功能，并且保持原有的功能。
     方式一:继承系统的类，重写方法.
     方式二:使用runtime,交换方法.
 
 */
- (void)exchangeMethod {
    //需求:给imageNamed方法提供功能，每次加载图片就判断下图片是否加载成功。
    //步骤一:先搞个分类，定义一个能加载图片并且能打印的方法+(instancetype)imageWithName:(NSString *)name;
    //步骤二:交换imageNamed和imageWithName的实现，就能调用imageWithName,间接调用imageWithName的实现
//    UIImage *image = [UIImage imageNamed:@"123"];
}

/*
     3.动态添加方法
     
     开发使用场景：如果一个类方法非常多，加载类到内存的时候也比较耗费资源，需要给每个方法生成映射表，可以使用动态给某个类，添加方法解决。
     经典面试题：有没有使用performSelector，其实主要想问你有没有动态添加过方法。
     简单使用

 */

- (void)dynamicAppendingMetnod {
    Person *p = [[Person alloc] init];
    
    //默认person,没有实现eat方法，可以通过performSelector调用，但是会报错  -[Person eat]: unrecognized selector sent to instance 0x610000008100
    //动态添加方法就不会报错
    [p performSelector:@selector(eat)];
}

/*
     4.给分类添加属性
     
     原理：给一个类声明属性，其实本质就是给这个类添加关联，并不是直接把这个值的内存空间添加到类存空间。

 */
- (void)caterogyAppendingProperty {
    //给系统NSObject类动态添加属性name
    NSObject *objc = [[NSObject alloc] init];
    objc.name = @"想把我唱给你听";
    NSLog(@"%@",objc.name);
    
}

/*
 5.字典转模型
 
 设计模型：字典转模型的第一步
 模型属性，通常需要跟字典中的key一一对应
 问题：一个一个的生成模型属性，很慢？
 需求：能不能自动根据一个字典，生成对应的属性。
 解决：提供一个分类，专门根据字典生成对应的属性字符串。
 
 */
- (void)dictionaryToDataModel {
    
}


//自动打印属性字符串
+ (void)resolveDict:(NSDictionary *)dict {
    //拼接属性字符串代码
    NSMutableString *strM = [NSMutableString string];
    
    //1.遍历字典，把字典中的所有key取出来，生成对应的属性代码
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //类型经常变，抽离出来
        NSString *type;
        
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")]) {
            type = @"NSString";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")]){
            type = @"NSArray";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
            type = @"int";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]) {
            type = @"NSDictionary";
        }
    
        //属性字符串
        NSString *str;
        if ([type containsString:@"NS"]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@",type,key];
        }else {
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) %@ *%@",type,key];

        }
        //每生成属性字符串，就自动换行
        [strM appendFormat:@"\n%@\n",str];
        
    }];
    
    //把拼接好的字符串打印出来
    NSLog(@"%@",strM);
}

/*
 
 字典转模型的方式一：KVC
 */


- (void)buildUI {
    NSDate *date = [[NSDate alloc] init];
    NSDate *tempDate = [date dateByAddingTimeInterval:20];
    NSLog(@"%ld",[date compare:tempDate]);
    
    [self.view addSubview:self.tableView];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    activityView.backgroundColor = [UIColor redColor];
    [activityView startAnimating];
    [self.view addSubview:activityView];

}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 200;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"TextImageWebViewCell" bundle:nil] forCellReuseIdentifier:@"TextImageWebViewCell"];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TextImageWebViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextImageWebViewCell"];
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
                            "</html>",@"<p></p><p>行程D1日&amp;nbsp;</p><p>北京/桂林。(火车运行时间约21H/26H/2100KM)</p><p>无餐 &amp;nbsp;硬卧 &amp;nbsp;火车</p><p>北京西客站乘K21次（08:06）或Z5次（16：09）或备选车次Z285次（21：10）硬卧火车赴山水甲天下的诗经家园——桂林，开始愉快的旅程！</p><hr/><p>行程D2日</p><p>桂林</p><p>无餐</p><p>桂林 &amp;nbsp;空调旅游车</p><p>K21（12:47）或Z5（11：34）或Z285（16:27）抵桂林。接团后送酒店办理入住，如时间充裕可自由活动。</p><hr/><p>行程D3日</p><p>桂林。◇当日景点：尧山、訾洲景区、南溪山、山水间</p><p>早中 桂林 空调旅游车</p><p>早餐后乘车前往桂林市最高峰国家4A景区【尧山】（缆车上下费用自理，60元/人），因周唐时山上建有尧帝庙而得名，景区四季变幻莫测，春天来桂林旅游，漫山遍野的杜鹃花将一座层峦漓江边骑行，摄影自拍。前往游览【訾洲景区】（约60分钟），在訾洲可以180°观赏桂林城徽“象鼻山”，览无敌江景。在烟雨弥漫的时节，云纱雾幔，訾洲笼罩在一片朦胧之中，岚雾缭绕，洲岛隐约可见，或淡或浓，犹如一幅水墨画卷，充满诗情画意，“訾洲烟雨”是桂林著名的老八景之一。后游览因南溪萦绕而得名的【南溪山景区】（游览不少于45分钟）它有东西两峰，彼此并列，耸拔千尺，北面有峭壁，其山石洁白。在古代“南溪新霁”就是桂林八景之一，南溪山洞多而奇。</p><p>观赏亚洲首台大型壮乡山水情景表演秀【山水间】（约60分钟），该剧采用不同场景变化和一流的声、光、电舞台技术运用，充分展现了漓江山水的历史变迁、山水景观和人文情怀，唯美变幻的舞美，惊险刺激的杂技，让您看过之后终身难忘。</p><p>晚间自由活动</p><p><strong>温馨提示</strong></p><p>※ 自由活动无导游陪同，晚间您可在城市中心正阳步行街休闲一游，感受尚水美食街的小吃特色，【尚水美食街】主题定位为桂林美食文化休闲街 ，汇集中外颇具地方特色的美食小吃：经典桂林米粉、羊肉粉、螺蛳粉、竹筒饭、海鲜锅、烧烤、砂锅、汤包、飞饼、麻辣烫、奶茶、甜品等上百种小吃，让我们贵宾们来一次正宗的“桂林小吃盛宴”，充分感受真正“舌尖上的桂林”。用餐餐费敬请自理！</p><hr/><p>行程D4日</p><p>桂林/阳朔。◇当日景点：泰国园、逍遥湖、阳朔西街</p><p>早中 阳朔 空调旅游车</p><p>参观【桂林堤雅国际商城】（约120分钟）。桂林堤雅国际商城是泰国宝利公司，在中国设立的唯一一家品牌旗舰商城，泰国芭堤雅乳胶作为泰国最具特色的商品，通过东盟免税进入中国，泰国宝利公司选址桂林，设立堤雅国际商城，宣传泰国国宝——乳胶，为中泰友谊锦上添花。</p><p>随后游览【逍遥湖】（约120分钟），逍遥湖是桂林旅游东线的一颗明珠，融自然风光与人文历史于一体。逍遥湖景区属于以山、林、溪、湖为主体的自然生态景区，通过仿古园林建筑、石刻诗词文章、历史名人趣事、坊间古风名俗，再现了底 蕴深厚的桂林历史文化。这里有古木参天，飞瀑流泉，古坊塔楼，是访古问幽，娱乐休闲的好去处。</p><p>晚间自由畅玩被称为阳朔的“洋人街”的【西街】。西街两旁的房屋古朴典雅，每一家的设计充满文艺气息，独具风格。小青瓦、红砖墙、坡屋面，在这里拍照，深得大家喜爱，累了还能在温馨的小店里休憩，在霓虹灯里“聆听”西街故事！</p><p><strong>温馨提示：</strong></p><p>※ 晚9点半后才是西街最富生命力的时刻！西街漫步为自由活动，无导游陪同，敬请注意安全！</p><p>※ 桂林和阳朔当地有很多商贩小店，贩卖各种特产10元4盒，5盒均为假冒伪劣的山寨高仿包装。请勿图便宜购买，另外酒店和景区门口贩卖各种水果的商贩缺斤少情况非常多，请勿与当地农民争执，以免发生不愉快的情况。</p><hr/><p>行程D5日</p><p>桂林/北京。&amp;nbsp;</p><p>早中 硬卧 空调旅游车</p><p>早餐后随后游览【多人遇龙河景区】（40分钟），遇龙河有“小漓江”之称，是阳朔山水的精华。它以山青水碧竹 翠桥奇村巧而闻名于世，是桂林山水中不可多得的美景，也是阳朔风光的最好体现。选择徒步旅游遇龙河，欣赏美丽的阳朔风光是赏这条“小漓江”的最佳方式。【百亩油菜花】次第而开，绽放出金黄色的光芒。由金色花朵编制而成的无边无际的黄金地毯，没有人工雕琢的痕迹，没有都市喧嚣，一切都是那么自然，朴实，悠闲。中餐：品尝CCTV推荐菜品——正宗阳朔啤酒鱼</p><p>参观【少数民族侗家观光村】，初入古寨，如水音蝉韵般侗族清曲伴随着清风徐徐入耳，独具侗家特色的吊脚楼错落有致，沿着曲折婉转小路深入古寨，品尝侗族特有，参观桂林特色产业【广西玉石文化推广中心】（参观约90分钟，桂林独有特色产业，桂林鸡血玉，形成于10亿年前。第九届中国-东盟博览会，桂林鸡血玉被定为国礼，赠给与各国元首及政要。参观全国连锁平价超市——世纪华联，选购桂林土特产赠送亲朋好友。根据航班/火车时间送团，结束愉快的旅程。后按照约定时间乘约定车次Z6次（14:22）或Z286次（21:31）或K22（19:50）火车硬卧返回北京。</p><p><strong>温馨提示：</strong></p><p>※ 若您还有空余时间，返回市区后将为您安排到正规的市民超市为亲友挑选桂林土特产作为手礼。</p><p>※ 本次行程到此结束；返程期间请注意您的个人物品保管，祝您一路顺风，返程愉快！</p><hr/><p>行程D6日</p><p>抵达北京。(火车运行时间约21H/26H/2100KM)</p><p>无 温馨的家</p><p>当日下午Z6次09:48、Z286次17:03、K22次22:48抵达北京西客站，结束愉快旅途。</p><hr/><p><strong>费用包括</strong></p><p>往返交通；</p><p>桂林高标准等级标间（双人标准间、独立卫生间）；</p><p>餐费（十人一桌、正餐八菜一汤）；</p><p>空调旅游车；当地专线导游服务；</p><p>15万元旅行社责任险；</p><p>景点第一门票。</p><hr/><p><strong>顾客须知</strong></p><p>儿童费用：12岁以内1.4米以下儿童：含当地用车和正餐的半餐，其余不含，超高请于景区门口按景区标明的价格现补门票（桂林阳朔当地的景点游览会根据儿童身高按不同比例收费，此部分费用由家长在当地现付），遇龙河漂流,儿童高度达到1.1m（含1.1m)需自行购买成人票。</p><hr/><p><strong>住宿说明</strong></p><p>桂林指定参考酒店：维也纳万象店、戴斯酒店、潇湘滨湖、民丰酒店或同级</p><p>阳朔指定参考酒店喆啡酒店，印象大酒店，河谷度假大酒店，公园度假酒店，金阁大酒店，新阳大酒店，漓江酒店</p><p>谢三姐商务酒店，向阳酒店，君临天下酒店，月光度假酒店，十里郎人文酒店，鸿泰假日酒店，怡景大酒店，鸿润</p><p>大酒店，田家河酒店，花园小洋房或同级</p><p></p><hr/><p><strong>用餐说明</strong><br/></p><p>全程3早4正（价值68元桂林风味特色自助餐+价值68元逍遥湖野炊+CCTV推荐正宗阳朔啤酒鱼+桂林正宗米粉宴+桂林正宗米粉宴）</p><hr/><p><strong>购物说明</strong></p><p>乳胶店、珠宝店、土特产及景中店不算店（根据新旅游法规定，景区内购物场所非旅行社指定消费项目，请谨慎选择） &amp;nbsp;&amp;nbsp;</p><p></p><p></p><p><strong><span style='color: rgb(255, 0, 0);'></span></strong></p><hr/><p><strong><span style='color: rgb(255, 0, 0);'>备注说明</span></strong><br/></p><p>1、旅行社处理投诉以游客在当地签署的意见书为依据，如未提出异议则视为无投诉接待，返程后提出异议的旅行社有权拒绝无举证投诉的处理。</p><p>2、在旅游中地接社可对行程先后顺序作出调整，但不影响原约定标准及游览景点。</p><p>3、团队出现单男单女时，团友有义务配合及听从导游安排协调住房，团友也可自行支付单间差。</p><p>4、如遇人力不可抗拒因素（风雪、塌方、塞车、航班延误或取消等），需更改行程的超支费用由双方协商解决。</p><p>5、以上所列游览、购物时间均为仅供游客参考，如因特殊情况下造成减少的可根据实际情况协商。</p><p>6、当地为旅游热点地区，散拼客人当地会出现换车换导游现象，属于旅游正常现象，由此提异议恕不给予处理。</p><p>7、行程如果因抵离时间不足三整天，行程内景点走不完无费用退！</p><hr/><p><strong style='color: rgb(255, 0, 0);'>特别声明</strong></p><p>所有产品严格执行2013旅游新法规，此产品为促销产品，导游可在不影响行程的情况下推荐自费，但绝不强制。</p><p>&amp;nbsp; &amp;nbsp;</p><p></p><p><br/></p>"];
    cell.myWebView.delegate = self;
    cell.myWebView.scrollView.scrollEnabled = NO;
    [cell.myWebView loadHTMLString:[self htmlEntityDecode:htmlString] baseURL:nil];
    return cell;
}

//将 &lt 等类似的字符转化为HTML中的“<”等
- (NSString *)htmlEntityDecode:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    return string;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    webView.frame=CGRectMake(0, 0, self.view.frame.size.width,height);
    NSLog(@"height   %f",height);
    // 防止死循环
    if (height != _height) {
        _height = height;
        if (_height > 0) {
            // 刷新cell高度
            [self.tableView reloadData];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _height;
}


@end
