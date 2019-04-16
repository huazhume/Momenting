//
//  MTLocalDataManager.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/9.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTLocalDataManager.h"
#import "MTCoreDataManager.h"
#import "MTNoteModel.h"
#import "MTNotePo+CoreDataProperties.h"
#import "MTNoteTextPo+CoreDataProperties.h"
#import "MTNoteImagePo+CoreDataProperties.h"
#import "MTNotificationVo.h"
#import "MTNotificationPo+CoreDataProperties.h"

@implementation MTLocalDataManager

+ (MTLocalDataManager *)shareInstance
{
    static MTLocalDataManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MTLocalDataManager alloc] init];
        
    });
    
    return manager;
}


- (BOOL)insertDatas:(NSArray *)datas withType:(MTCoreDataContentType)type
{
    if (type == MTCoreDataContentTypeNoteSelf) {
        [datas enumerateObjectsUsingBlock:^(MTNoteModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MTNotePo *po = [NSEntityDescription insertNewObjectForEntityForName:@"MTNotePo" inManagedObjectContext:[[MTCoreDataManager shareInstance] managedObjectContext]];
            po.noteId = obj.noteId;
            po.imagePath = obj.imagePath;
            po.text = obj.text;
            po.width = obj.width;
            po.height = obj.height;
            po.weather = obj.weather;
            
        }];
    } else {
        [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[MTNoteTextVo class]]) {
                MTNoteTextVo *vo = (MTNoteTextVo *)obj;
                MTNoteTextPo *po = [NSEntityDescription insertNewObjectForEntityForName:@"MTNoteTextPo" inManagedObjectContext:[[MTCoreDataManager shareInstance] managedObjectContext]];
                po.text = vo.text;
                po.fontName = vo.fontName;
                po.fontSize = vo.fontSize;
                po.noteId = vo.noteId;
                po.fontType = vo.fontType;
                po.sortIndex = idx;
                
            } else {
                MTNoteImageVo *vo = (MTNoteImageVo *)obj;
                MTNoteImagePo *po = [NSEntityDescription insertNewObjectForEntityForName:@"MTNoteImagePo" inManagedObjectContext:[[MTCoreDataManager shareInstance] managedObjectContext]];
                po.path = vo.path;
                po.width = vo.width;
                po.height = vo.height;
                po.noteId = vo.noteId;
                po.sortIndex = idx;
            }
        }];
    }
    
    NSError *error = nil;
    if ([[[MTCoreDataManager shareInstance] managedObjectContext] save:&error]) {
        NSLog(@"数据插入到数据库成功");
        return YES;
    }else{
        NSLog(@"数据插入到数据库失败");
        return NO;
    }
}

- (NSArray *)getNoteSelf
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MTNotePo"];
    NSArray *array = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:request error:nil];
    NSMutableArray *muArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(MTNotePo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MTNoteModel *model = [MTNoteModel new];
        model.noteId = obj.noteId;
        model.imagePath = obj.imagePath;
        model.text = obj.text;
        model.width = obj.width;
        model.height = obj.height;
        model.weather = obj.weather;
        if (muArray.count == 0) {
            [muArray addObject:model];
        } else {
            [muArray insertObject:model atIndex:0];
        }
    }];
    return muArray;
}

- (NSArray *)getNoteDetailList:(NSString *)noteId
{
    NSFetchRequest *textRequest=[NSFetchRequest fetchRequestWithEntityName:@"MTNoteTextPo"];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"noteId=%@",noteId];
    textRequest.predicate = predicate;
    NSArray *textArray = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:textRequest error:nil];
    
    NSFetchRequest *imageRequest=[NSFetchRequest fetchRequestWithEntityName:@"MTNoteImagePo"];
    NSPredicate *imagePredicate=[NSPredicate predicateWithFormat:@"noteId=%@",noteId];
    imageRequest.predicate=imagePredicate;
    NSArray *imageArray = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:imageRequest error:nil];
    
    NSMutableArray *muArray = [[NSMutableArray alloc] initWithArray:textArray];
    [muArray addObjectsFromArray:imageArray];
    NSMutableArray *muVoArray = [NSMutableArray array];
    [muArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MTNoteTextPo class]]) {
            MTNoteTextVo *vo = [MTNoteTextVo new];
            MTNoteTextPo *po = (MTNoteTextPo *)obj;
            vo.text = po.text;
            vo.fontName = po.fontName;
            vo.fontSize = po.fontSize;
            vo.noteId = po.noteId;
            vo.sortIndex = po.sortIndex;
            vo.fontType = po.fontType;
            [muVoArray addObject:vo];
            
        } else {
            MTNoteImageVo *vo = [MTNoteImageVo new];
            MTNoteImagePo *po = (MTNoteImagePo *)obj;
            vo.path = po.path;
            vo.width = po.width;
            vo.height = po.height;
            vo.noteId = po.noteId;
            vo.sortIndex = po.sortIndex;
            [muVoArray addObject:vo];
        }
    }];
    [muVoArray sortUsingComparator:^NSComparisonResult(MTNoteBaseVo *obj1, MTNoteBaseVo *obj2) {
        return obj1.sortIndex > obj2.sortIndex;
    }];

    return muVoArray;
}


- (BOOL)deleteNoteWithNoteId:(NSString *)noteId
{
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"noteId=%@",noteId];
    {
        NSFetchRequest *deleRequest = [NSFetchRequest fetchRequestWithEntityName:@"MTNotePo"];
        deleRequest.predicate = predicate;
        NSArray *deleArray = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:deleRequest error:nil];
        for (MTNotePo *stu in deleArray) {
            [[[MTCoreDataManager shareInstance] managedObjectContext] deleteObject:stu];
        }
    }
    {
        NSFetchRequest *imageDeleRequest = [NSFetchRequest fetchRequestWithEntityName:@"MTNoteImagePo"];
        
        imageDeleRequest.predicate = predicate;
        NSArray *deleImageArray = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:imageDeleRequest error:nil];
        for (MTNoteImagePo *stu in deleImageArray) {
            [[[MTCoreDataManager shareInstance] managedObjectContext] deleteObject:stu];
        }
    }
    {
        NSFetchRequest *textDeleRequest = [NSFetchRequest fetchRequestWithEntityName:@"MTNoteImagePo"];
        textDeleRequest.predicate = predicate;
        NSArray *deleTextArray = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:textDeleRequest error:nil];
        for (MTNoteTextPo *stu in deleTextArray) {
            [[[MTCoreDataManager shareInstance] managedObjectContext] deleteObject:stu];
        }
    }
    NSError *error = nil;
    if ([[[MTCoreDataManager shareInstance] managedObjectContext] save:&error]) {
        return YES;
    }else{
        return NO;
    }
}


- (BOOL)insertNotificationDatas:(NSArray *)datas
{
    [datas enumerateObjectsUsingBlock:^(MTNotificationVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MTNotificationPo *po = [NSEntityDescription insertNewObjectForEntityForName:@"MTNotificationPo" inManagedObjectContext:[[MTCoreDataManager shareInstance] managedObjectContext]];
        po.notificationId = obj.notificationId;
        po.content = obj.content;
        po.time = obj.time;
        po.state = obj.state.integerValue;
    }];

    NSError *error = nil;
    if ([[[MTCoreDataManager shareInstance] managedObjectContext] save:&error]) {
        NSLog(@"数据插入到数据库成功");
        return YES;
    }else{
        NSLog(@"数据插入到数据库失败");
        return NO;
    }
}

- (NSArray *)getNotifications
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MTNotificationPo"];
    NSArray *array = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:request error:nil];
    NSMutableArray *muArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(MTNotificationPo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MTNotificationVo *po = [MTNotificationVo new];
        po.notificationId = obj.notificationId;
        po.content = obj.content;
        po.time = obj.time;
        po.state = [NSNumber numberWithInteger:obj.state];
        if (muArray.count == 0) {
            [muArray addObject:po];
        } else {
            [muArray insertObject:po atIndex:0];
        }
    }];
    return muArray;
}


- (BOOL)deleteNotificationWithContent:(NSString *)content
{
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"content=%@",content];
    {
        NSFetchRequest *deleRequest = [NSFetchRequest fetchRequestWithEntityName:@"MTNotificationPo"];
        deleRequest.predicate = predicate;
        NSArray *deleArray = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:deleRequest error:nil];
        for (MTNotePo *stu in deleArray) {
            [[[MTCoreDataManager shareInstance] managedObjectContext] deleteObject:stu];
        }
    }
    NSError *error = nil;
    if ([[[MTCoreDataManager shareInstance] managedObjectContext] save:&error]) {
        return YES;
    }else{
        return NO;
    }
}

- (void)config
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"contentConfig"]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"info" forKey:@"contentConfig"];
    MTNoteTextVo *vo1 = [MTNoteTextVo new];
    vo1.noteId = @"note_01";
    vo1.text = @"今夕何夕兮搴洲中流。今日何日兮得与王子同舟。蒙羞被好兮不訾诟耻。心几烦而不绝兮得知王子。山有木兮木有枝。心悦君兮君不知。";
    
    MTNoteTextVo *vo2 = [MTNoteTextVo new];
    vo2.noteId = @"note_02";
    vo2.text = @"我想和你结婚，做炙热的亲吻，我想和在这开始私定终身。";
    
    MTNoteTextVo *vo3 = [MTNoteTextVo new];
    vo3.noteId = @"note_03";
    vo3.text = @"我想我爱你，不是三言两语，不是甜言蜜语，就能轻松地说明，想你也不必说个不停，每看你一眼都是清新，我们要一起数遍所有星星，看腻每个美景再重新，让我来填饱你的生活日记。";
    
    
    MTNoteTextVo *vo4 = [MTNoteTextVo new];
    vo4.noteId = @"note_04";
    vo4.text = @"知道吗？这里的雨季只有一两天，白昼很长 也很短，夜晚有三年，知道吗 今天的消息，说一号公路上 那座桥断了，我们还去吗，要不再说呢，会修一年吧，一年能等吗";
    
    
    MTNoteTextVo *vo5 = [MTNoteTextVo new];
    vo5.noteId = @"note_05";
    vo5.text = @"我真的好想你 在每一个雨季，你选择遗忘的 是我最不舍的，纸短情长啊 道不尽太多涟漪，我的故事都是关于你呀";
    
    MTNoteTextVo *vo6 = [MTNoteTextVo new];
    vo6.noteId = @"note_06";
    vo6.text = @"一棹春风一叶舟，一纶茧缕一轻钩。花满渚，酒满瓯，万顷波中得自由";
    
    MTNoteTextVo *vo7 = [MTNoteTextVo new];
    vo7.noteId = @"note_07";
    vo7.text =  @"樱桃落尽春将困，秋千架下归时。漏暗斜月迟迟，在花枝。彻晓纱窗下，待来君不知。";
    
    MTNoteTextVo *vo8 = [MTNoteTextVo new];
    vo8.noteId = @"note_08";
    vo8.text =  @"南风知我意，吹梦到西洲..";
    
    
    NSArray *selfArray = @[vo1,vo2,vo3,vo4,vo5,vo6,vo7,vo8];
    long time = (long)[[NSDate date]timeIntervalSince1970];
    [selfArray enumerateObjectsUsingBlock:^(MTNoteTextVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.noteId = [NSString stringWithFormat:@"%ld",time + 60 * idx];
        [self insertDatas:@[obj] withType:MTCoreDataContentTypeNoteContent];
        MTNoteModel *po = [MTNoteModel new];
        po.noteId = obj.noteId;
        po.text = obj.text;
//        [self insertDatas:@[po] withType:MTCoreDataContentTypeNoteSelf];
        
    }];
    
     [self addNote1];
    
}

- (void)aboutMe
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"aboutMe"]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"info" forKey:@"contentConfig"];
    MTNoteTextVo *vo1 = [MTNoteTextVo new];
    vo1.noteId = @"note_01";
    vo1.text = @"关于我\n\n欢迎来到Secret。\n"
    
    "在阿尔卑斯山一处风景秀美却也极为险峻的山路转弯处，经常发生事故，可即使如此，来往的车辆依旧疾驰而过，不断更换的警示牌没有起到任何作用，直到有一天那里立起一块木牌，写着“慢慢走，欣赏啊”，人们才猛然惊觉，原来只记得埋头赶路，竟忘了看看这满目秀丽。\n\n"
    
    "人生就是如此美好\n"
    "有时当你遇到一个人，你是否也想和她一起思考、书写、聆听、欣赏……\n\n";
    
    MTNoteTextVo *vo2 = [MTNoteTextVo new];
    vo2.noteId = @"note_01";
    vo2.text = @"我喜欢一个女孩，短发样子很可爱，她从我的身边走过去，我的眼睛都要掉出来...\n";
    
 
}


- (void)addNote1
{
    MTNoteTextVo *vo1 = [MTNoteTextVo new];
    vo1.noteId = @"detail_01";
    vo1.text = @"她离开了，就在我醒来的某一天早晨。"
    
    "\n\n"
    
    "房间里什么都没有留下，连一张便条都没有，这不是她的风格。每次走的时候她总会留下点什么，哪怕支言半语。上次是一张照片，上上次是一份信，上上上次是遗留下来的身份证。每次看到这些东西，我都知道她走不远的，甚至怀疑她是故意留下来这些东西的，女人的身体永远比嘴诚实。剧烈的头痛冲击着大脑，我揉了揉太阳穴，不紧不慢地穿起了衣服。内裤、袜子、衬衣、毛衣。天气冷了，我该回家再带件衣服的，那还要不要去找她，一想到这个问题就剧烈的头痛，我在房间里转悠了两圈，拿起手机又放下。想起上次，上上次......罢了，反正也打不通，打通了也是故技重施的把戏，这游戏我也的确玩腻了。"
    
    "\n\n"
    
    "我去卫生间洗了洗脸刷了牙，整理好东西，走进了地铁站。通往徐泾东的2号线地铁站空荡荡的，少了平日的拥挤，反而有点不大习惯。时不时传来广播里聒噪的广播女声，预报着即将到来的列车，我顺势走向车尾，找了个位置放下书包倚靠在车门边。"
    
    
    "\n\n"
    "旁边有一对小情侣低头呢喃着，女的歪着头靠在男的肩膀上，男的也歪着头耳朵贴在女孩的头发上。"
    
    "\n\n"
    
    "疲倦感袭击而来，我闭住眼好像想到些什么。"
    
    "\n\n"
    
    "你为什么每次都这样？"
    
    "我和你说过多少遍了，不要再和我讲道理。"
    
    "你走吧。"
    
    "别管我。"
    
    "我求你了。"
    
    "你根本不爱我。"
    
    
    "\n\n"
    "我的鼻尖碰触着她的，呼出来的气息喷在她的脸上。彼此试探着，内心有一头猛兽想要侵略对方的领地，却只能在黑夜里故作矜持。我的手小心的触碰着她的肌肤，一边解着内衣的暗扣，一边竖着耳朵察觉她的动静。她像一只兔子，那么温顺，仅仅是抱着就好像融化在这滩温水里，我内心有一团火燃烧着，却又仿佛被她这滩水所柔化，似乎再进一步，就会伤害她。我屏着呼吸，不自觉地咽喉处蠕动了一下。"
    
    "\n\n"
    
    "我睁开眼，吞了一口唾沫，不愿再往下回忆。一个男人想念着一个女人的身体时，仿佛才真正想念起这个人。只是霸占过的身体，总是索然无趣。"
    
    
    "\n\n"
    "她一个眼神，稍微翻个身，我就知道该怎么配合，太过熟悉，就会失去探索的乐趣。爱，说白了还是短暂的存在，像烟花一样也只在那一瞬间绽放，划过天际，总会被习惯磨灭，到最后灰飞烟灭，只留下肮脏的灰烬不易被人发觉。"
    
    "\n\n"
    
    "到了徐泾东，我下了地铁，下意识去拉后面的手，被空气抓住，不敢收回。打开手机，最后一条消息：我在地铁口等你下班。看了下上面的时间：一个月前。"
    
    
    "\n\n"
    
    
    "我离开了，就在一个月前的一天晚上。"
    
    "\n\n"
    
    "他没有找我，也没有联系我，对话框最后一条消息是我发的，那是我最后一次在地铁口等他时发出去的一条消息。我那天说了很多话，他一直沉默着。这不像他，以前我说什么他都会反驳一两句，给我讲讲他的大道理，虽然我根本听不进去。女人真是虚荣极了，她在外受尽委屈，都吞进心里，却只想获得自己男人的呵护和认同，然后把这点虚伪的保护当做是被爱的证据。不光光是这样，女人还喜欢欺骗自己，哪怕得知不被爱，也要从对方身上搜寻出蛛丝马迹证明自己被爱过。"
    
    "\n\n"
    
    "他低着头，不论我说什么，他都不会反驳，原来沉默的杀伤力远远胜过了任何的话语。我为他想了很多种理由：他工作累了、他觉得我说的对、他只是想听听我说的。我始终不愿承认，其实他根本没有在听。"
    
    "\n\n"
    
    "我离开的时候，他还在熟睡中，我轻轻揭开被子，替他捏了捏被角，穿好衣服，提着行李箱，轻轻关上了门。"
    
    "\n\n"
    
    "地铁口有一对老夫妻刚刚开张卖煎饼，两人熟练地配合着，女人一个眼神男人便会意替她围上围巾。"
    
    
    "\n\n"
    "我闭住眼，脑子里嗡嗡作响。"
    
    "\n\n"
    
    "你知不知道你这样很烦？"
    "\n\n"
    "你到底想怎么样？"
    
    "难道我做的还不够多吗？"
    
    "我亏待你了吗？"
    
    "对不起，我不值得。"
    
    "\n\n"
    
    "第一次见他的时候，他像个慌张的大男孩，拉着我的手，走哪都不敢放开。走在电梯上时，总是喜欢站在我后面，两只手紧紧抱着我。看向我的眼神里透露着紧张和呵护欲，我就像一朵他心爱的花，每天浇水施肥从来不敢摘下。而我，看向他一眼就会脸红心跳。我的鼻子碰着他的鼻尖，两个人都会下意识的躲开。那种小心翼翼，想触碰却又躲开的肌肤，光是抱着，呼吸着对方呼出来的气，就好像把两个人的灵魂绑在一起。女人总是把身体和灵魂联系在一起，以为男人占有了你的身体，就会对你的灵魂有着无尽的兴趣，却总是忘了，身体和身体可以彼此熟悉，而心和心永远隔着厚重的肚皮。"
    
    "\n\n"
    
    "永远对一个人无法了解，无论是通过身体的哪一个部位。人类之间不存在互通，只是靠在一起取暖或是满足私欲。"
    
    "\n\n"
    
    "他抱着我的时候的动作，他亲吻我时的温柔，他冲我笑时的神情，他趴在我腿上委屈巴巴的样子。他的嘴唇，他的鼻梁，他平坦的小腹。女人总是在想念一个人时，才会贪恋他的身体。他说：“我不舍得你离开。”他说这句话时，手正在我背上摸索，没有了拿捏的小心翼翼，听起来如此的动人，我想象着他的眼神是那么深情，如果不是黑夜，我仿佛多看一眼就会沉醉其中。"
    
    "\n\n"
    
    "我知道他的痛处，他知道我的底线。我们把最真实丑陋的一面暴露出来，一切也就变得索然无味，而生活最无趣的就是漫长和不断地重复。"
    
    "\n\n"
    
    "我走到地铁车尾，倚靠在门口。从车门玻璃上，看到自己的模样开始越来越清晰。村上春树说：死并不是生的对立面，而是它的一部分。”我也认为逃离不是回归的对立面，逃离的本身是为了回归。世界上任何一件事物，任何一个人的存在并不是为了被拥有，而是为了存在而存在。我从未拥有过他们，我只是路过曾想借用一生。"
    
    
    "\n\n"
    "上了地铁，滴滴声响了两遍，地铁门关上的那一刻，我彻底地消失在了2号线";
    
    MTNoteTextVo *vo2 = [MTNoteTextVo new];
    vo2.noteId = @"detail_02";
    vo2.text = @"我买了一串葡萄，心情不错地往老爸的病房走，好像很久没那么开心过了，就在刚才的水果店里，老板的猫死命拽着我不给我走，大概是连续一礼拜的光顾，让它对我有了好感吧。"
    
    "\n\n"
    
    "只是好景不长，我的好心情被一个不速之客被摔了个稀巴烂。"
    
    "\n\n"
    
    "那个名叫千叶的男人，此刻就坐在我老爸床边，若无其事地削一个苹果。"
    
    
    "\n\n"
    "萌吉，你回来啦。你男朋友来看我了，死孩子，交往那么久也不告诉我。"
    
    "\n\n"
    
    "老爸一抬头发现了站在门口的我，眉开眼笑地唤道。"
    
    "\n\n"
    
    "看到千叶的瞬间，我的内心只有一个想法：晦气。"
    
    "\n\n"
    
    "千叶是一个死神，我曾在伊坂幸太郎的书上读到过有关他的事迹。据说，他每负责一个对象都会变一次脸和身份，唯独名字不变。"
    
    "\n\n"
    
    "在工作调查期间，他会和临死之人相处七天，最后提交的结果分为两种，“可”与“放行”。只不过，多数时候他们提交的结果都是“可”，也就是死亡。"
    
    "\n\n"
    
    "虽说这是我第一次见到千叶，但从他身上散发出来的迷之暗黑气息以及那张欠揍的面瘫脸中，我隐隐感受到了大事不妙。"
    
    "\n\n"
    
    "萌吉，”就在这时，那张面瘫脸打破了良久的沉默，吓了我一跳，“这附近有音像店吗？”";
    
    MTNoteTextVo *vo3 = [MTNoteTextVo new];
    vo3.noteId = @"detail_03";
    vo3.text = @"我的鼻尖碰触着她的，呼出来的气息喷在她的脸上。彼此试探着，内心有一头猛兽想要侵略对方的领地，却只能在黑夜里故作矜持。我的手小心的触碰着她的肌肤，一边解着内衣的暗扣，一边竖着耳朵察觉她的动静。她像一只兔子，那么温顺，仅仅是抱着就好像融化在这滩温水里，我内心有一团火燃烧着，却又仿佛被她这滩水所柔化，似乎再进一步，就会伤害她。我屏着呼吸，不自觉地咽喉处蠕动了一下。"
    
    "\n\n"
    
    "我睁开眼，吞了一口唾沫，不愿再往下回忆。一个男人想念着一个女人的身体时，仿佛才真正想念起这个人。只是霸占过的身体，总是索然无趣。"
    
    
    "\n\n"
    "她一个眼神，稍微翻个身，我就知道该怎么配合，太过熟悉，就会失去探索的乐趣。爱，说白了还是短暂的存在，像烟花一样也只在那一瞬间绽放，划过天际，总会被习惯磨灭，到最后灰飞烟灭，只留下肮脏的灰烬不易被人发觉。"
    
    "\n\n"
    
    "到了徐泾东，我下了地铁，下意识去拉后面的手，被空气抓住，不敢收回。打开手机，最后一条消息：我在地铁口等你下班。看了下上面的时间：一个月前。"
    
    
    "\n\n"
    
    
    "我离开了，就在一个月前的一天晚上。"
    
    "\n\n"
    
    "他没有找我，也没有联系我，对话框最后一条消息是我发的，那是我最后一次在地铁口等他时发出去的一条消息。我那天说了很多话，他一直沉默着。这不像他，以前我说什么他都会反驳一两句，给我讲讲他的大道理，虽然我根本听不进去。女人真是虚荣极了，她在外受尽委屈，都吞进心里，却只想获得自己男人的呵护和认同，然后把这点虚伪的保护当做是被爱的证据。不光光是这样，女人还喜欢欺骗自己，哪怕得知不被爱，也要从对方身上搜寻出蛛丝马迹证明自己被爱过。";
    
    
    MTNoteTextVo *vo4 = [MTNoteTextVo new];
    vo4.noteId = @"detail_04";
    vo4.text = @"很久以前，我总是梦见一个女孩。"
    
    "她有着白皙的皮肤，治愈的笑容，和一双硕大无比的翅膀。"
    "\n"
    "早晨，她和阳光一起醒来，把睡了一夜有些发皱的翅膀折叠起来，藏进纱质的长裙里。她轻踱着脚步跳出去，颀长的手臂沐浴在细软的微风里。"
    "\n"
    "我认识她的时候，正是困顿的那几年。"
    "\n"
    "逃出国境的我慌不择路，遇见她的时候紧张得很，生怕哪一步走错就会前功尽弃。后有追兵，前有堵截，我随着她的身影穿梭在黑夜的密林里。"
    "\n"
    "高大的树木把天空盖得严实，月光透不进来半分。我摸着石头磕磕绊绊地趟过小溪，不断被粗糙的灌木划伤身体，偶尔忍不住疼痛喊叫起来。"
    "\n"
    "她却走得无比轻松，与石、水、木、花像是好友。"
    "\n"
    "月光终于洒在我已经破烂的鞋上，我们到了一片旷地。她向前走了几步，抬起头注视着远方的月亮。月亮在我们前方的高空上挂着，下面是另一片密林。"
    "\n"
    "她盯着那月亮看了很久。看得那么认真，那么深情。她的翅膀在淡绿色的月光中生长了出来，挣脱出她柔软的长裙。"
    "\n"
    
    "对不起，未经允许就写下你的故事。"
    "\n"
    "我没见过他，可我见过你。见过你的笑容，见过你干干净净的思念，见过你历久弥新的爱，见过你说起他时脸上的神情，见过你柔软的思念。"
    "\n"
    "想起你们，就想起梦里的月光。"
    "\n"
    "不管未来是否道阻且长，祝福你呀。";
    
    
    MTNoteTextVo *vo5 = [MTNoteTextVo new];
    vo5.noteId = @"detail_05";
    vo5.text = @"嘿，我亲爱的未来女友："
    
    "\n\n"
    
    "虽然你可能还不知道我是谁，但你应该很快就能遇见我了。所以我想，能够提前让你知道，当我在等你的时候，内心里有关于你的一切甜蜜幻想，这些话只许你一个人听，可千万不要让别人知道了。"
    
    "\n\n"
    
    "最近，身边的朋友们一个个都脱了单，找到了那个相伴扶持的人，天天在朋友圈里秀着恩爱，秀恩爱的同时还不忘催着我让我抓紧时间，赶紧找个合适的女孩子。虽然每次我都表现的毫不在意，嘴上说着不着急，但其实心里已经幻想过无数种和你在一起的样子了。"
    
    "\n\n"
    
    "每次刷微博的时候，总是能看到一些情侣之间的聊天截图，两个人因为异地的距离而吵架，因为性格的差异而分手，还有男生打了一整夜游戏没有及时回复女朋友的消息，惹的女朋友生气，女生和别的男生多说了几句话，让男朋友吃醋……各种各样的理由和原因让彼此变得不坚定。这就让我觉得谈恋爱真的好累好麻烦啊。"
    
    
    "\n\n"
    "但是我又会看到他们分享着在一起的点点滴滴，记录下在一起的每个时刻，为了对方而让自己悄悄做出改变，让两个人的未来更加坚定，在失意的时候有一双手可以牵着，在难过的时候有一个肩膀可以依靠，在烦恼的时候有一个臂弯可以拥抱……所以我又开始觉得好想有一段这样的恋爱啊，我什么时候才能遇见你呢。"
    
    "\n\n"
    
    "我也时常会想，当你出现的时候，会是什么样的。"
    
    
    "\n\n"
    "我们会在哪里相遇，操场、餐厅还是在地铁上？你又会穿着一身怎样的衣服，T恤、牛仔还是一件长裙？是长发还是短发？我们是谁先开始搭讪？是加了微信还是关注了微博？遇见的那天都聊了些什么？最后是谁先说的晚安？"
    
    "\n\n"
    
    "我想要好好了解你，这样才能更加喜欢你。你生于南方还是北方？爱吃米还是吃面？喜欢养猫还是养狗？倾向韩剧还是美剧？爱看恐怖电影还是喜剧片？有收集口红的习惯吗？迪奥、阿玛尼还是香奈儿？是不是和我一样对生活充满了仪式感？你会希望我带你去看一场心心念念的电影吗？还是去吃上次逛街你随口一说的那家烧烤？虽然我对这些事物可能并没有那么大的兴趣，但只要你喜欢，我也愿意去喜欢。"
    
    "\n\n"
    
    "如果我们在一起之后，你会不会接受我那一点点的坏习惯？会介意我因为制作要熬夜到很晚吗？会不会因为我偶尔没有及时地回复你而感到不开心？会不会讨厌我身上的烟酒味？会不会受不了我情绪突然的抑郁？要是你不喜欢的话，那我就努力去改。我可以戒烟戒酒，可以每天早一点跟你说晚安，可以让自己多笑，可以把你放在我的第一位。"
    
    "\n\n"
    
    "一想到我和你甜甜的恋爱，我就忍不住想要快点见到你，也会偷偷地学会一些搭讪技巧，撩人情话。因为世界上只有两件事情是藏不住的，一件是咳嗽，另一件就是我对你的喜欢，我怕一旦我藏不住了，还能提前做好跟你告白的准备。只是不知道，你有没有准备好呢。"
    
    "\n\n"
    
    "虽然我现在一个人努力生活，每天按时起床，按时吃饭，按时睡觉，来来去去都是自己一个人，还有很多的功课和文章要做，但我也还能照顾好自己。只是对越来越多的东西失去了兴趣，好像习惯了一个人，可还是有那么一瞬间，让我很想很想谈恋爱。"
    
    "\n\n"
    
    "夏天就快要到了，这应该是我遇见你的最佳时机了吧。我们可以一起吃冰淇淋，一起喝冰镇可乐，一起抱着西瓜吹空调，也可以穿着情侣装在街上大方地牵手，带你吃你喜欢的所有味道，或者带你去稻城看日出，去海边看日落……这些幸福的瞬间都是我想要有你在身边的。"
    
    
    "\n\n"
    "你只要准备好出现就可以了，剩下的都交给我来做，我一定会把所有的温柔，所有的体贴，所有的爱都给你。当然，还有我也给你。"
    
    "\n\n"
    
    "所以，你准备好做我女朋友了吗？";
    
    MTNoteTextVo *vo6 = [MTNoteTextVo new];
    vo6.noteId = @"detail_06";
    vo6.text = @"我也不知道为什么有人可以这么倔强，把没可能说的那么绝对，好像感情这回事是说完就能完的故事。看小说或者看电影，看主角身边的甲乙丙丁在离开以后，就不再在故事里出现，像消失了一样，他们终于在故事里潦草退场。"
    "\n\n"
    "可是现实里的爱情却不能够，我们好像总是对散场以后的关系依然心存余温，在所有可能和不可能里找寻哪怕一点点希望的痕迹。所以有好多分手以后的男女，依旧心里惦念着对方，也总觉得对方没有放下自己，一遍遍猜忌，一次次多疑，胡思乱想，自找难堪。"
    "\n\n"
    "小c和男朋友分手以后，仍然舍不得删掉他。和他在一起从认识起的聊天记录，拍过的照片，听过的音乐，每一个点滴都是一看到就能想起那个人的寄存，她总是和我们说，“我好像还有机会。”"
    
    "\n\n"
    
    "那男生在一家餐厅打工，她就每天有时间就去，点一杯奶茶，坐着等。餐厅里的所有人都知道小c，也都习惯了她。男生觉得她每天来找人让他丢脸，终于在一天晚上找她来谈话，在小c还满怀期待地去见男生的时候，男生狠狠地丢了一堆难听的话。"
    
    "最后他丢下一句，“我真的没见过你这么贱的人。”"
    
    "如果很难过的话，大概是不会掉眼泪的，所有的情绪都被堵在喉咙口，想要挣扎着强调些什么，浑身上下笼罩着一种恐怖的无助感。小c就这样，生硬地挤出一丝笑脸，说，“好的，我知道了。”"
    "\n\n"
    "感情哪有什么公平和不公平的事，对喜欢得多的那个人就是不公平，这么简单的道理，却有太多的人不懂，太多的人想要求对方的回馈。他就是不喜欢你啊，所以伤害你的时候也不会心疼，也根本不在意你的感受，你又何必为难自己去找一个可能。"
    
    "亲爱的你，要什么时候你才懂得放弃，你才明白你终于已经失去那个人了。他带给你的辗转反侧和彻夜难眠，他带给你的胡思乱想和患得患失，他带给你的所有不安全感，其实都在告诉你，他不属于你了。"
    
    
    "\n\n"
    "之前在微博上看到一段话:"
    
    "照片我没删，我只是加密了。东西我没丢，我把它们整理好，装进那个大箱子里。而你，我也没忘记。我只是把你和许多没说出口的话一起，放进了那些小心翼翼的梦里。"
    
    "人们都有保存的习惯，那些美好的风花雪月，情歌唱了无数遍，你的样子还是没有变，看见你的时候依然想要拥抱你，这些温柔的细节就先让我好好保存，等到过了一个期限，我再选择把它们遗忘。"
    
    "而这个期限，就像是手机里最近删除的文件夹，都有30天的期限，那些最近删除里，有你的照片和同你聊天的截图，那些说着我爱你爱我的情话，还有早安晚安的问候。30天，在不知不觉中只剩下5天，只剩下4天，最后只剩下小于1天。"
    
    "这冰冷的程序计算公式都告诉我，是时候要放弃了。"
    
    "我终于是失去你了。";
    
    MTNoteTextVo *vo7 = [MTNoteTextVo new];
    vo7.noteId = @"detail_07";
    vo7.text =  @"我最后只落得了这个下场，虽然早已料到，但还是难免心中酸楚。从父母气急败坏把我赶出家门那一刻起，我就越来越糟。我走遍昔日一起鬼混的狐朋狗友的家门，只想讨一口酒喝，可是他们不是大门紧闭，就是说早已戒酒多时，这样的把戏未免也太低级了，我又不是瘟疫，为何唯避之而不及呢？我不过要一口酒，一口酒罢了。"
    "\n\n"
    "我来到前妻家门前时已是午夜，我饥寒交迫，再加上酒瘾发作浑身难受，我感觉自己一下子老了许多，曾经酒场上叱咤风云的时代如同一个赴死的壮士一样一去不返还了。我佝偻着身子，颤颤巍巍地抬起手正欲敲门，却听得屋内传来的一阵窸窣声，啊呀！那对我来说是多么熟悉而又遥远的声音啊，女人娇柔的呻吟，男人粗重的喘息，随着美妙的节奏一起一伏，你缠着我我绕着你，不必多费口舌说一些浪荡的情话，因为情欲已恣意盛放，每分每秒都在渴望着侵占与被侵占。我想我还是走吧，我的前妻正快活着呢，她不会想搭理我，她甚至会因此恨我，好吧实际上她已恨我入骨了太久。我沮丧地走回大街上，四顾茫然，心生凄凉，我也许会因为这一口永远流淌不到我血液里的酒而死在这个晚上，谁又会在乎呢？天一亮就当是一个流浪汉饿死或冻死街头，我的尸体会在城市里的人们出门上班之前被清理走，好像是有些残忍冷酷，但又的确理所应当。事到如今我还是没有一丝悔改之心，这就是上帝交给我的."
    "\n\n"
    "每个人的生命伊始上帝都会赐给他一样东西，管它是天赋还是陋习，总之你一生逃脱不了，我出生那日上帝应当是喝醉了，他满脸通红，摇摇晃晃地来到我面前，口齿不清地说：“来，孩子，干一杯，为了生命，干一杯！”我懵懵懂懂地从上帝手中接过一只精致的酒杯，便一生再也没能将它放下过，如今它已是满身斑驳铁锈，杯身里空无一物，如同生命之河枯竭干涸，皲裂的河床满目疮痍。前方街角传来一阵欢快的布鲁斯乐，啊，一定是一家通宵达旦营业的小酒馆，我忽地看到了希望似地疾步向前走去，黑暗中的一点光明总是给人以欣喜，我拐过街角，一小栋灯火通明的房屋与我隔街而望，房屋门前的招牌霓虹闪烁，一道道流光溢彩使我顿时士气大振，激动得不由得小跑了起来，轻轻推门而入时我还有些紧张和拘谨，毕竟我的穿着破破烂烂，又身无分文。多么幸运的一个夜晚，门后刚好是一位喝到了兴头上正开心跳舞的小胖妞，她甚至都没有看清我是谁，便一把拉过我的手撒欢似地跳起来，实在是盛情难却，我一边跟随着可爱的她蹦蹦跳跳，一边看着周遭的一切。音乐，音乐里不知疲倦的悦动，灯光，灯光里不灭不死的光彩，人群，人群里忘乎所以的欢舞，酒杯，酒杯里此处销魂的啤酒、威士忌、伏特加、朗姆酒、白兰地、琴酒、龙舌兰……一切都相得益彰，这简直就是人间天堂！人们不时端起酒杯，欢声纵饮，他们抛却烦恼，载歌载舞只醉今朝，我跳得大汗淋漓晕头转向，在一刹那又回到了我的年轻岁月，便越发得意忘形，又越发口干舌燥。这时不知是哪个大嗓门叫嚣到谁能将他喝倒他便为谁买今晚所有的单，我浑身一个激灵，双眼放光，上帝保佑，我今晚死不了了。我在众人怀疑与嘲讽的眼光中接受了大嗓门的挑战，实际上大嗓门已经喝过了头，他红着眼睛喘着粗气，光是站着也东倒西歪，随时都有可能一头栽倒在地直接痛痛快快睡到明天傍晚，无酒亦无眠，有酒不知眠。我叫了一大瓶最烈的百加得朗姆酒，往地上狠啐了一口唾沫，仰头就开始咕噜咕噜喝起来，这些美妙的酒仿佛不是自喉咙流进胃里，而是缓慢地注入了我肮脏陈杂的血液里，我原本消沉颓丧的灵魂如沐春风，一点一点地苏醒过来。“砰”，我很快一口气喝完了全部，空酒瓶用力往桌上一放，我看着大嗓门昏昏欲睡的神情，拍拍他的肩笑道：“老兄夜晚才刚刚开始呀！该重振雄风啦！”紧接着我又叫了三瓶威士忌和五打啤酒，啤酒分给大家一起喝，见者有份嘛，谁叫欢乐的时光总是短暂，明日的吃喝拉撒就让它永远留在明日，及时行乐，及时行乐吧！人群里爆发出一阵大笑，像是对不称意的生活发出的蔑视，我打开酒瓶，又仰头咕噜咕噜地喝起来，我感到我的血液开始迅速地新陈代谢，每一粒分子都焕发着活力，我的生命愈发地饱满，正以我从未见过的绝世姿态舒展开来。三瓶威士忌和数不清的啤酒一下肚，我已是酒酣耳热，但仍觉欲求未满，大嗓门半靠在座椅上，眼睛半眯着，已经不能完全地睁开了。我叫了几杯鸡尾酒，递给他一杯表示真诚地感谢，他迷迷糊糊，又强打着精神，咕哝着老弟还是伙计什么的，便干脆利落地一饮而尽，立刻又半眯着眼了，我只好独自一人将剩下的几杯喝完，浪费总是可耻的。人们越来越热情，不停地过来与我干杯、畅谈、大笑、跳舞，满地的空酒瓶叮叮当当哐哐锵锵，在我们脚下滚来滚去欢快作响，正如我们本身一样。我喝得越来越多，眼前的景象变得层层叠叠影影错错，耳朵里的声音也跟着忽大忽小忽远忽近，我感受到我剧烈的心跳，以及身上每一个细胞同样剧烈的躁动，我的灵魂化作一堆篝火，噼里啪啦地燃烧，登峰造极般发烫，如同生命的酒杯被打翻，一切都陷入一种极度亢奋的混沌之中。又有人来与我碰了一杯，他是谁是男是女是美是丑我都已来不及知道，酒水堵住了所有人的喋喋不休，淹没了所有的道德和规则，隔离了所有糟糕的过去与不安的未来，我的胃里一阵接着一阵抽搐，心里却一阵接着一阵狂喜。像是行走在云里雾里，我一步高一步低踉踉跄跄地来到厕所，看见了马桶像看见魂牵梦绕的情人一样一把扑上去抱住了它，仿佛有一只手从我嘴里径直穿过了喉咙，拉着整个胃狠狠往外拽，而我却丝毫不觉难受，反而觉得这只手是如此亲切，这种翻江倒海的感觉我已经丢失了太久。我一边吐一边瘫软了下来，如同一只这了气的皮球，一滩往阴沟里滑落的烂泥，一根到达高潮射完精后的阳具。我整个人瘫倒在潮湿的地板上，惊觉生命与时光无可挽回的流失，一时不知身在何处，天堂、地狱，抑或人间？也忘了自己到底多少岁，三十六、四十八、还是五十四？我甚至想不起来自己的名字，鲍勃、杰克、还是汤姆？是什么让我重获新生，又令我生不如死？是什么让我在天地间起落，又令我无枝可栖？是什么让我超凡脱俗，又令我一无所有？是什么让我忘了自己，又令我疯疯癫癫不得安宁？我情不自禁一声轻笑，缓缓合上了沉重不已的眼皮，脑海里明明灭灭地浮现出许多年前不知在哪看见的一段话：可是酒又有何益呢？它麻痹我的味蕾，伤害我的肠胃，倒腾我的血液，损坏我的神经，它拖拽着我的灵魂，一步一步向悬崖靠近，它撕扯着我，却说万丈深渊，亦是远大前程。";
    
    MTNoteTextVo *vo8 = [MTNoteTextVo new];
    vo8.noteId = @"detail_08";
    vo8.text =  @"人过了青春，就好像一部淘汰的老车，有时候就会想留下来做什么？是纯粹的怕死吗？还是也对世界充满一点点的希望？人正当青春的时候，一无所有，在滚滚的红尘里，连呼吸一口空气都会害怕会不会影响pm2.5，于是，又在思考人活着是为了什么？"
    "\n\n"
    "一个人活着，无论是年轻还是老去，有时候会迷茫，不知道如何快乐的生活，不知道珍惜的活着，直白的说，这样其实就是在辜负生命的意义。有的人，错过了青春的岁月，就多多少少对人生产生了恐惧，因为面对的事越来越多，思想的混乱就是常有之事。"
    "\n\n"
    "有时候在家里和长辈们闲谈，经常会听到他们抱怨说自己老了，不行啦，甚至有的会说，现在只是在混日子，混一天算一天这样的话，小一点的时候，自己会以为可能每个人渐渐的老去，都会有这种心态吧，后来我才明白，其实不是这样的。"
    "\n\n"
    "尽管前面有广袤的原野和恐惧，尽管还一无所有，但在幻想中感觉自己拥有一切，那就是青春。我个人觉得青春是无关年龄，如果，你才二十多岁，你对生活没有了幻想，那么你便没有了青春，如果你已经有六七十岁，你依然对生活充满渴望，充满幻想，那么你是拥有青春的。有时候会常常看到与我一般大的年轻人抱怨生活，年纪轻轻就觉得人生没有意思，真的心疼也遗憾。青春其实是很珍贵的，一去不复返，于我而言，我希望青春是充实的，我希望我能从不怠慢，从不浪费。"
    "\n\n"
    "或许此刻的你，正经历生命从开始萌生到成熟稳定转型，你苦恼、挣扎、失望、焦虑，但是同时你也容纳了它们的快乐、开心、收获和胜利。罗曼.罗兰说过：大半的人在二十或三十岁“就死了”。因为人过了这个年龄就容易变成自己的影子。有的人，错过了青春，就觉得青春有无限可能；有的人困守青春，觉得青春是一种缺陷，人都是这样，当你触碰到青春的时候，并不知道保持幻想，等到青春离别的时候，才对青春渴望、遗憾甚至追念。"
    "\n\n"
    "青春就如同一颗树，不管是它的枝还是它的叶、根，都象征了爱与希望，不管遭遇多大的风雨，都能在蓝天下茁壮成长，希望正值青春的每一个我们，都能为了梦想，无所畏惧，愿你永远青春，愿我永远不老。";
    
    
    MTNoteTextVo *vo9 = [MTNoteTextVo new];
    vo9.noteId = @"detail_09";
    vo9.text =  @"开始我用陌陌加的你，后来加了QQ，再到第一次见你，我们在学校的奶茶店，你一直安静地听我说话，我从此在你眼里就是话唠了。"
    "\n\n"
    "正好那段时间我们在同一个城市，你经常去学校陪我吃饭，偶尔我做完兼职也会去找你，还记得你带我去的那家面馆，后来我去过几次，也经常坐车路过，还是老样子，只是再也不是你带我去了。"
    "\n\n"
    "已经两年多不见了，现在写这篇文章已经没有了当初那种感觉，现在反而心里比较平静了，也许该换个标题的。"
    "\n\n"
    "我一直觉得自己有些无病呻吟，可你却总是能很好地安抚我，似乎是我太依赖你，你说你不想跟我在一起的时候像养女儿一样。"
    "\n\n"
    "后来我离开了，再联系是你突然而来的短信，说实话，收到你短信的时候我哭了，自己也不知道为什么要哭。"
    "\n\n"
    "前阵子看到你的头像，猜想你应该要结婚了，忍不住问了你，原来是已经结婚了，看了你的动态，近况不是很好，忍不住又关心你，想陪陪你，没事的时候总会和你聊聊天。"
    "\n\n"
    "今天看你状态好些了，我想我也该走了，你说不想和我失联，我竟不忍拒绝。"
    
    "晚上又翻了一遍你的朋友圈，看到了她，看到了你和她，祝你幸福！";
    
    
    MTNoteTextVo *vo10 = [MTNoteTextVo new];
    vo10.noteId = @"detail_010";
    vo10.text =  @"时光荏苒，有你就好，在最好的年华遇到了那个此生致爱的人，已经是一种幸福！心底的那份真情只有自己知道。"
    "\n"
    "幸福到底有着什么样的定义，也许是一束鲜花？还是一句我爱你？或者是单膝跪地那一枚钻戒？只有自己的内心才会明白，你到底需要什么？"
    "\n"
    "青春，别错过爱情，别错过理想，别错过有一丝可能性的希望，以及有百分之九十九的赌注。爱过才不枉一生。";
    
    
    MTNoteTextVo *vo11 = [MTNoteTextVo new];
    vo11.noteId = @"banner_02";
    vo11.text =  @"我的快乐是片刻的"
    "\n"
    "我的言语是片刻的"
    "\n"
    "我的心动是片刻的"
    "\n"
    "我的友情是片刻的"
    "\n"
    "我的难过也是片刻的"
    
    "\n"
    
    "我希望长跑是片刻的"
    "\n"
    "肚子痛是片刻的"
    "\n"
    "慌张是片刻的"
    "\n"
    "期待是片刻的"
    "\n"
    "我的喜欢也是片刻的"
    
    "\n"
    "\n"
    
    "确定了这个消息挺惊讶和讽刺的。似乎有关系，又没有关系。在片刻的日子接近过真实的自己，却又触不可及而迷茫。在这里认识过些那样温暖的人，后来经常因为结局而偷偷难受。不知道这算不算情感呢，虽然这辈子多半不会长寿，依旧希望在很长很长一段时间里，他们都能存在于我对青春的回忆里。";
    
    
    
    
    MTNoteTextVo *vo12 = [MTNoteTextVo new];
    vo12.noteId = @"banner_01";
    vo12.text =  @"那些喜欢、徘徊、坚持乃至放弃"
    
    
      "\n"  "\n"
    "都是因为，我们还年轻"
    
      "\n"  "\n"
    "有些人虽未同行，但好像始终看到的是同一条路的风景。"
    
      "\n"
    
    "前些日子和青以一起在整理回忆录，翻出许多旧照片。我说看到那些阳光下闪闪发光的湖面，总是会热泪盈眶。看着照片就像能想起来当时空气的味道，少女在湖边奔跑。大概美好的事物都是有保质期的，所以我们想用另一种方式把它留住。"
      "\n"
    
    
    "有一天刚醒来，就看到一位过去同事发来的一条推送链接，他说以来我觉得我的朋友中只有你看完了会理解，所以我只有发给你一个人了。"
    
    
      "\n"
    "推送里有一段海明威的话：“如果你足够幸运，年轻时候在巴黎居住过，那么此后你到哪里，巴黎都将一直跟着你。”"
    
      "\n"
    
    "大城市的气质会影响一个人的一生。"
    
      "\n"
    
    "大概年轻时候的许多经历都将影响我们一生。"
    
      "\n"
    
    
    
    "但我永远怀念我。"
    
      "\n"
    
    "其实这篇文章从半个月前我就开始写，我和青以说我们想表达的情感好丰富，可我好像很难去表达清楚，青以说我们不能丧失表达情感的能力啊。"
    
      "\n"
    
    "前阵子说起想出去散散心，哥哥给我发来消息说：“你想去哪里都可以，这里是你的家。想好想去哪儿了要告诉我，如果近我就来找你，如果远我就去送你。”"
    
      "\n"
    
    "哥哥真的是太温柔的人啊，青以说想要把身边温暖优秀的人都记录下来，我们打算开始计划一个采访栏目，想留住人间值得的东西。"
    
      "\n"
    
    "人生短暂，没有人是看遍了所有的风景甘愿离去的。人生漫长，想要万事胜意又太难了。而那些我们必须要去努力的，我希望是我勇敢过后做出的选择。"
    
      "\n"
    
    "我喜欢回忆，是那些疼痛或欢腾的经历造就了今天的我，缺失了任何一点都不完整。但我更爱当下，我们还有好多电影没有一起看，还有好多梦没有一起做。"
    
      "\n"
    
    "年轻时候渴望那些一锤定音的事情。而随着日常生活，如今觉得更多的决定，乃至放弃其实都是不连贯的，是自己与自己，生活与生活磨出来的。有断断续续的努力，也有不为人知的溃散。隐藏在成品之下，还有许多的未完成。"
    
      "\n"
    
    "年轻时候我们都想过要怎样活成自己，我们始终想要情怀，想要去爱与被爱并且表达爱。"
    
      "\n"
    
    "那种感情，于我而言是永远热泪盈眶的。"
    
      "\n"
    
    "我想要这世界有一个人是为我而来的。"
    
    
      "\n"
    "我温柔，反叛，浪费，蹉跎，自我，不急进，不浮躁。";
    
    

    
    MTNoteTextVo *vo13 = [MTNoteTextVo new];
    vo13.noteId = @"banner_03";
    vo13.text =  @"长这么大，虽然没正正经经谈过几段恋爱可我也是摸过几个男人的手的，黑的、白的、光滑的、粗糙的、毛多的、毛少的，摸上去也没什么感觉，就和左手摸右手一样。但是摸老周的手的时候，我像吸了毒，心里咯噔一下，耳朵里只剩下怦怦怦的声音。"
    
    "\n"
    
    "下了公交以后，他从我后面绕过来从右边走到左边，我心里想这是捣什么鬼，他有点不好意思地笑了笑：“我走你左边吧。”我懵逼地点了点头，心里偷着乐：“没想到啊，这死直男还懂得挺多，这是想站在离我心脏最近的地方啊。”我抿着嘴，害怕笑出了声，害羞地低下了头。"
    
    "\n"
    
    "你偷笑什么啊？"
    "\n"
    "啊！没有...啊...那个...你为什么要站我左边？”我掩着嘴，边问边窃笑，不好意思地等待他的回答。"
    "\n"
    "哦，没什么啊，我就是习惯走人左边，得劲！"
    "\n"
    "我脸上的笑容顿时凝固，冻在脸上。女人啊！千万不要给自己加太多戏！"
    
    
    "\n""\n"
    
    
    "刚下公交没走几步，就过马路了，一路上我都是手插在兜子里，不是因为冷，我只是不知道手该往哪里放。偶尔把手掏出来，也是左手拿着手机，右手插兜。武汉的光谷那边经常修路，那条路已经被糟蹋地不像样了，连个红绿灯都没有，过马路全凭司机和行人之间没有言语交流的默契，然而大多数情况下默契感为零。我看着来往的车辆丝毫没有放慢的节奏，一着急都想摆手让它停下了，不知不觉就把手从兜里拿出来，还没等我反应过来，突然有一只宽厚的大手握住了我的小手，然后拿走了我的手机。我抬头看了老周一眼，老周没有看我，直接把手机放到他自己的兜子里然后拉着我的手过马路。"
    
    
    "\n"
    "这个画面在我脑海里曾经被幻想过好多次，像幻灯片一样，但由于当时事情发生的太突然，而且过于真实，我根本来不及点保存，当时我是被拉着走的，我忘记了我是怎么迈开双腿的，怎么挪动脚步的，只记得那么一双温暖的大手像呵护一朵小花一样包住我的手，让我根本动弹不得，甚至来不及抽回去就被抓得死死的，他，根本就没想给我拒绝的机会。我目光盯着那两只缠绕在一起的手，脸一会红一会白，还在恍惚之间就到了马路对面。"
    
    "\n"
    
    "从那一刻，他的手就好像抓住了猎物一般，一路上都没有放开过，好像一放开我就会跑掉一样。老周的手其实之前我在照片上见过，我算不上手控，但是对于好看的手也是毫无抵抗力，第一次见他的手的时候就像被抓住了短处，那双手修长，每根手指都有自己的特点，让你看到就恨不得上去摸一摸。我承认，无数次在他不注意的时候，我都对着那双手罪恶的意淫了。"
    "\n"
    
    
    "我们走了一会，他一手拿着手机找附近的饭店，一手牵着我的手。对于牵手这事，他就好像什么都没发生一样，搞得我心里一直抓毛：难道就不解释一下吗？就这么把我给牵了？我单身二十年还没被男人摸过手，还没表白，什么都没有，难道不解释下我们的关系就随随便便把我手给牵了？"
    
    "\n"
    
    "你盯着我干嘛？"
    "\n"
    "啊？有…有吗？"
    "\n"
    "我脸上有东西？"
    "\n"
    "没…没有啊。"
    
    "他突然凑近，呼出来的热气扑向我鼻尖，我两只眼睛盯着他，喉咙不自主地蠕动了一下，咽下一口唾沫。"
    
    "你是不是很紧张，手心里怎么都是汗。”他笑得很嚣张，带着一点小人得志的得意。嘴角上扬的时候，纹路明显地映入眼帘。"
    
    "\n"
    
    "我避开他直勾勾的目光，盯着自己的脚说：“没有吧，我怎么感觉是你紧张，我从来不出汗。"
    
    "他像是为了掩饰自己的慌张一样，把“罪责”推卸给我。在他凑近时低头的那个瞬间，我明明看到他额头上有一些细密密的东西粘了上去，晶莹透亮。"
    
    "\n"
    
    "到底是谁手心里出汗，其实我也不知道，但是我能感觉到我冰凉的手越来越热，而且两只交汇在一起的手之间密密麻麻都是汗，在两只手之间酝酿却不蒸发。我始终相信，不是我的。哪怕真的有我的，也只占了三分之一。一想到这么个大男人牵个手都能紧张的出汗，倒觉得他有点孩子气的可爱。"
    
    
    "\n"
    "两个人相视一笑，不知道为什么两只手握的更紧了。"
    
    
    "\n"
    "后来的日子里，走哪老周都没放开过我的手，握得紧紧的，和第一次牵起我的手一样。"
    "\n"
    "我从来没有告诉过老周，他牵起我手的时候我在想什么，他也没有说过。他牵起我的手的时候什么都没有说，他走在前面，我走在后面，在这个城市的大街小巷穿梭着，好像彼此有了一点依偎感。我像有了软肋又像有了盔甲，就这么跟着眼前的男人走着，好像不知道从哪来，也不知道到哪去，走着走着，有那么一瞬间，恍惚中我竟然在脑海里和这个男人过完了一生。"
    
    
    "\n"
    "只是心心念念的那些瞬间，短暂而美好，拉着我的手站在我身边的老周却对此一无所知。";
    
    NSArray *selfArray = @[vo1,vo2,vo3,vo4,vo5,vo6,vo7,vo8,vo9,vo10,vo11,vo12,vo13];
    long time = (long)[[NSDate date]timeIntervalSince1970];
    [selfArray enumerateObjectsUsingBlock:^(MTNoteTextVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self insertDatas:@[obj] withType:MTCoreDataContentTypeNoteContent];
    }];
}


































@end
