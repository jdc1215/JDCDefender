//
//  JDCViewController.m
//  JDCDefender
//
//  Created by jdc1215 on 08/26/2020.
//  Copyright (c) 2020 jdc1215. All rights reserved.
//

#import "JDCViewController.h"

//#import "NSArray+Defender.h"
@interface JDCViewController ()
@property (nonatomic,retain)NSArray *array;
@end

@implementation JDCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 200, 150, 30);
    [self.view addSubview:button];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)buttonTouched:(UIButton*)send{
    self.array =[[NSArray alloc]init];
    NSDictionary *dic = @{@"title":@"<nill>"};
    self.array = @[@"1"];
//    NSMutableDictionary *setD =[[NSMutableDictionary alloc]init];
//    NSString *title = dic[@"title"];
////    [setD setObject:title forKey:@"key"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
