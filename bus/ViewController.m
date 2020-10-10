//
//  ViewController.m
//  bus
//
//  Created by liuhongnian on 2018/11/6.
//  Copyright © 2018年 liuhongnian. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+FBKVOController.h"
#import "bus-Swift.h"
#import "BusViewModel.h"

typedef NS_ENUM(NSUInteger, TimeModel) {
    WorkTimeMode = 1,
    LifeTimeMode,
};

@interface ViewController ()

@property (nonatomic, strong) Bus59ViewModel *bus59ViewModel;

@property (nonatomic, strong) BRT1ViewModel  *brt1ViewModel_daRe;
@property (nonatomic, strong) BRT1ViewModel *brt1ViewModel;

@property(nonatomic, assign) TimeModel currentModel;

@property (nonatomic, strong) SearchBusApi *searchBusApi;

@property (weak, nonatomic) IBOutlet UILabel *bus59Station;
@property (weak, nonatomic) IBOutlet UILabel *bus59First;
@property (weak, nonatomic) IBOutlet UILabel *bus59Second;

@property (weak, nonatomic) IBOutlet UILabel *brt1Station;
@property (weak, nonatomic) IBOutlet UILabel *b1First;
@property (weak, nonatomic) IBOutlet UILabel *b1Second;

@property (nonatomic, weak) IBOutlet UILabel *b1HotStation;
@property (nonatomic, weak) IBOutlet UILabel *b1HotFirst;
@property (nonatomic, weak) IBOutlet UILabel *b1HotSecond;

@end

@implementation ViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;  //分钟
    NSDateComponents *dateComponent = [calendar components:unitFlags
                                                  fromDate:[NSDate date]];
    NSInteger hour = [dateComponent hour];

    if (hour >= 17) {
        _currentModel = LifeTimeMode;
    } else {
        _currentModel = WorkTimeMode;
    }

    _bus59ViewModel = [[Bus59ViewModel alloc] init];
    _brt1ViewModel = [[BRT1ViewModel alloc] init];
    _brt1ViewModel_daRe = [[BRT1ViewModel alloc] init];
    
    
    [self observe59ViewModel];
    [self observeB1ViewModel];

    [self startRequest59BusInfo];
    [self startRequestB1BusInfo];
    

    UIBarButtonItem *workItem = [[UIBarButtonItem alloc] initWithTitle:@"工作"
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(toWorkModel)];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchItemTapped)];
    self.navigationItem.leftBarButtonItems = @[workItem, searchItem];

    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"生活啊~"
                                                              style:UIBarButtonItemStyleDone
                                                             target:self
                                                             action:@selector(toLifeModel)];
    self.navigationItem.rightBarButtonItem = right;
    
}

- (void)injected
{
    NSLog(@"动态+");
}

- (void)toWorkModel {
    
    _currentModel = WorkTimeMode;

    [self startRequest59BusInfo];
    [self startRequestB1BusInfo];
}

- (void)toLifeModel {
    
    _currentModel = LifeTimeMode;
    [self startRequest59BusInfo];
    [self startRequestB1BusInfo];
    [self startRequestB1InfoForiReading];

}

- (void)searchItemTapped
{
    SearchLineViewController *searchLineVC = [[SearchLineViewController alloc] init];
    [self.navigationController pushViewController:searchLineVC
                                         animated:YES];
    
}

- (IBAction)ButtonClicked:(id)sender {

}

#pragma mark ViewModel

- (void)observe59ViewModel {
    __weak typeof(self) weakSelf = self;
    
    [self.KVOController observe:_bus59ViewModel keyPath:FBKVOKeyPath(_bus59ViewModel.result) options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSKeyValueChangeKey, id> *_Nonnull change) {
        NSDictionary *contentOf59 = change[NSKeyValueChangeNewKey];
        weakSelf.bus59Station.text = [NSString stringWithFormat:@"老司机在前往 %@ 的路上", contentOf59[@"station"]];

        NSArray *bus = contentOf59[@"neares_bus"];
        switch (bus.count) {
            case 0:
                weakSelf.bus59First.text = nil;
                weakSelf.bus59Second.text = nil;
                break;
            case 1:
                weakSelf.bus59First.text = [NSString stringWithFormat:@"第一辆离你还有%d站",[bus.firstObject intValue]];
                weakSelf.bus59Second.text = nil;
                break;
            case 2:
                weakSelf.bus59First.text = [NSString stringWithFormat:@"第一辆离你还有 %d站",[bus.firstObject intValue]];
                weakSelf.bus59Second.text = [NSString stringWithFormat:@"第二辆车离你还有 %d站",[bus.lastObject intValue]];
                break;
            default:
                break;
        }

    }];
}

- (void)observeB1ViewModel {
    
    __weak typeof(self) weakSelf = self;
    
    [self.KVOController observe:_brt1ViewModel
                        keyPath:FBKVOKeyPath(_brt1ViewModel.result)
                        options:NSKeyValueObservingOptionNew
                          block:^(id _Nullable observer,
                                  id _Nonnull object,
                                  NSDictionary<NSKeyValueChangeKey, id> *_Nonnull change) {
                              NSDictionary *contentOfB1 = change[NSKeyValueChangeNewKey];
                              weakSelf.brt1Station.text = [NSString stringWithFormat:@"老司机在前往 %@ 的路上", contentOfB1[@"station"]];

                              NSArray *bus = contentOfB1[@"neares_bus"];
                              switch (bus.count) {
                                  case 0:
                                      weakSelf.b1First.text = nil;
                                      weakSelf.b1Second.text = nil;
                                      break;
                                  case 1:
                                      weakSelf.b1Second.text = [NSString stringWithFormat:@"第一辆离你还有%d站",[bus.firstObject intValue]];
                                      weakSelf.b1Second.text = nil;
                                      break;
                                  case 2:
                                      weakSelf.b1First.text = [NSString stringWithFormat:@"第一辆离你还有 %d站",[bus.firstObject intValue]];
                                      weakSelf.b1Second.text = [NSString stringWithFormat:@"第二辆车离你还有 %d站",[bus.lastObject intValue]];
                                      break;
                                  default:
                                      break;
                              }


                          }];
    
    
    [self.KVOController observe:_brt1ViewModel_daRe
                        keyPath:FBKVOKeyPath(_brt1ViewModel_daRe.result)
                        options:NSKeyValueObservingOptionNew
                          block:^(id _Nullable observer,
                                  id _Nonnull object,
                                  NSDictionary<NSKeyValueChangeKey, id> *_Nonnull change) {
                              NSDictionary *contentOfB1 = change[NSKeyValueChangeNewKey];
                              weakSelf.b1HotStation.text = [NSString stringWithFormat:@"老司机在前往 %@ 的路上", contentOfB1[@"station"]];

                              NSArray *bus = contentOfB1[@"neares_bus"];
                              switch (bus.count) {
                                  case 0:
                                      weakSelf.b1HotFirst.text = nil;
                                      weakSelf.b1HotSecond.text = nil;
                                      break;
                                  case 1:
                                      weakSelf.b1HotFirst.text = [NSString stringWithFormat:@"第一辆离你还有%d站",[bus.firstObject intValue]];
                                      weakSelf.b1HotSecond.text = nil;
                                      break;
                                  case 2:
                                      weakSelf.b1HotFirst.text = [NSString stringWithFormat:@"第一辆离你还有 %d站",[bus.firstObject intValue]];
                                      weakSelf.b1HotSecond.text = [NSString stringWithFormat:@"第二辆车离你还有 %d站",[bus.lastObject intValue]];
                                      break;
                                  default:
                                      break;
                              }


                          }];
    
    
    
}

- (void)startRequestB1BusInfo {
    //下班模式
    if (_currentModel == LifeTimeMode) {

        [_brt1ViewModel startRequestWithDirection:@"2" station:@"通江路黄河路"];
        
    } else {

        [_brt1ViewModel startRequestWithDirection:@"2" station:@"辽河路常澄路"];
    }

//    _searchBusApi = [[SearchBusApi alloc] initWithLineName:@"59"];
//    [_searchBusApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//        NSLog(@"search results: %@",request.responseString);
//    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//
//    }];
    //
}

- (void)startRequest59BusInfo {

    //Life.
    if (_currentModel == LifeTimeMode) {
        [_bus59ViewModel startRequestWithDirection:@"2" station:@"薛家"];
    }else{
        [_bus59ViewModel startRequestWithDirection:@"1" station:@"薛家"];
    }
}

- (void)startRequestB1InfoForiReading
{
    if (_currentModel == LifeTimeMode) {
        
        [_brt1ViewModel_daRe startRequestWithDirection:@"2" station:@"交通银行（通江路飞龙路）"];
    }
}


@end
