//
//  ViewController.m
//  定时器
//
//  Created by Zions Jen.
//

#import "ViewController.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(100, 100, 100, 50);
    btn.backgroundColor = UIColor.blueColor;
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)clickBtn{
    [self.navigationController pushViewController:[TestViewController new] animated:YES];
}
@end
