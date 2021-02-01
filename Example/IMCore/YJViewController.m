//
//  YJViewController.m
//  IMCore
//
//  Created by yangjun on 02/01/2021.
//  Copyright (c) 2021 yangjun. All rights reserved.
//

#import "YJViewController.h"
#import <NetworkService.h>
@interface YJViewController ()

@end

@implementation YJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [NetworkService.sharedInstance setShortLinkPort:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
