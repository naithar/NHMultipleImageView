//
//  NViewController.m
//  NHMultipleImageView
//
//  Created by Naithar on 05/01/2015.
//  Copyright (c) 2014 Naithar. All rights reserved.
//

#import "NViewController.h"
#import <NHMultiImageView.h>

@interface NViewController ()<UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NViewController

- (void)viewDidLoad
{

//    NHMultiImageView *view = [[NHMultiImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
//
//    [self.view addSubview:view];
    //    view.backgroundColor = [UIColor groupTableViewBackgroundColor];



    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.


    self.tableView.rowHeight = 320;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.delaysContentTouches = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"MultiImageCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.dataSource = self;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
