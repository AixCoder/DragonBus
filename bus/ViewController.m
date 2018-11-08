//
//  ViewController.m
//  bus
//
//  Created by liuhongnian on 2018/11/6.
//  Copyright © 2018年 liuhongnian. All rights reserved.
//

#import "ViewController.h"
#import "Bus59ViewModel.h"
#import "NSObject+FBKVOController.h"

typedef NS_ENUM(NSUInteger, TimeModel) {
    WorkTimeMode = 1,
    LifeTimeMode,
};

@interface ViewController ()

@property(nonatomic, strong) Bus59ViewModel *bus59ViewModel;
@property(nonatomic, strong) BRT1ViewModel *brt1ViewModel;
@property (nonatomic, strong)Bus11ViewModel *bus11ViewModel;

@property(nonatomic, assign) TimeModel currentModel;

@property(weak, nonatomic) IBOutlet UILabel *bus59Label;
@property(weak, nonatomic) IBOutlet UILabel *brt1Label;
@property(weak, nonatomic) IBOutlet UILabel *bus11Label;

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
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger hour = [dateComponent hour];

    if (hour >= 17) {
        _currentModel = LifeTimeMode;
    } else {
        _currentModel = WorkTimeMode;
    }

    _bus59ViewModel = [[Bus59ViewModel alloc] init];
    _brt1ViewModel = [[BRT1ViewModel alloc] init];
    _bus11ViewModel = [[Bus11ViewModel alloc] init];
    [self observe59ViewModel];
    [self observeB1ViewModel];
    [self observe11ViewModel];

    [self startRequest59BusInfo];
    [self startRequestB1BusInfo];
    [self startRequest11BusInfo];


    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"工作"
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(toWorkModel)];
    self.navigationItem.leftBarButtonItem = left;

    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"下班啦"
                                                              style:UIBarButtonItemStyleDone
                                                             target:self
                                                             action:@selector(toLifeModel)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)toWorkModel {
    
    _currentModel = WorkTimeMode;

    [self startRequest59BusInfo];
    [self startRequestB1BusInfo];
    [self startRequest11BusInfo];
}

- (void)toLifeModel {
    
    _currentModel = LifeTimeMode;
    [self startRequest59BusInfo];
    [self startRequestB1BusInfo];
    [self startRequest11BusInfo];

}

- (IBAction)ButtonClicked:(id)sender {

}

#pragma mark ViewModel

- (void)observe59ViewModel {
    __weak typeof(self) weakSelf = self;
    [self.KVOController observe:_bus59ViewModel keyPath:FBKVOKeyPath(_bus59ViewModel.result) options:NSKeyValueObservingOptionNew block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSKeyValueChangeKey, id> *_Nonnull change) {
        NSString *contentOf59 = change[NSKeyValueChangeNewKey];

        weakSelf.bus59Label.text = contentOf59;
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
                              NSString *contentOfB1 = change[NSKeyValueChangeNewKey];
                              weakSelf.brt1Label.text = contentOfB1;
                          }];
}

- (void)observe11ViewModel
{
    __weak typeof(self) weakSelf = self;
    [self.KVOController observe:_bus11ViewModel
                        keyPath:FBKVOKeyPath(_bus11ViewModel.result)
                        options:NSKeyValueObservingOptionNew
                          block:^(id _Nullable observer,
                                  id _Nonnull object,
                                  NSDictionary<NSKeyValueChangeKey, id> *_Nonnull change) {
                              NSString *contentOf11Road = change[NSKeyValueChangeNewKey];
                              weakSelf.bus11Label.text = contentOf11Road;
                          }];
}

- (void)startRequestB1BusInfo {
    //下班模式
    if (_currentModel == LifeTimeMode) {
        [_brt1ViewModel startRequestBRT1RoadWithDirection:@"2"
                                              stationName:@"通江路黄河路"];
    } else {
        [_brt1ViewModel startRequestBRT1RoadWithDirection:@"1"
                                              stationName:@"辽河路常澄路"];
    }
}

- (void)startRequest11BusInfo
{
    if (_currentModel == LifeTimeMode){
        [_bus11ViewModel startRequest11RoadWithDirection:@"2" stationName:@"锦江国际大酒店"];

    } else{
        [_bus11ViewModel startRequest11RoadWithDirection:@"1" stationName:@"龙虎塘公交枢纽"];
    }
}

- (void)startRequest59BusInfo {

    //下班模式
    if (_currentModel == LifeTimeMode) {
        [_bus59ViewModel startRequest59RoadWithDirection:@"2" stationName:@"薛家"];
    } else {
        [_bus59ViewModel startRequest59RoadWithDirection:@"1" stationName:@"富都小区"];
    }

}


@end
