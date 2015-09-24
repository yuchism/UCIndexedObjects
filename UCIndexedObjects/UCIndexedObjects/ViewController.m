//
//  ViewController.m
//  UCIndexedObjects
//
//  Created by John Y on 31/08/2015.
//  Copyright (c) 2015 Yuch. All rights reserved.
//

#import "ViewController.h"
#import "UCIndexedObjects.h"
#import "UCIdGen.h"
#import "NSDate+Utils.h"
#import "Group.h"
#import "Item.h"



@interface ViewController ()
{
    UCIndexedObjects *indexedObject;
    NSTimer *timer;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    indexedObject = [[UCIndexedObjects alloc] init];
    indexedObject.groupClass = [Group class];
    [self _generateData];
    [self.tableView reloadData];

    [self startTimer];

}

- (void)startTimer
{
    [self stopTimer];
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

- (void)tick:(NSTimer *)timer
{
    dispatch_block_t block = ^{
        [self _generateData];
        [self.tableView reloadData];
    };
    dispatch_async(dispatch_get_main_queue(), block);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [indexedObject numberOfObjectsInGroup:section];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [indexedObject numberOfGroup];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    Group *group = [indexedObject groupWithIdx:section];

    UILabel *lbl = [[UILabel alloc] init];
    lbl.text = group.name;
    lbl.backgroundColor = [UIColor redColor];
    
    
    return lbl;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];

    Item *item = [indexedObject objectForGroup:indexPath.section idx:indexPath.row];
    cell.textLabel.text = item.name;
    
    return cell;
}


- (void) _generateData
{
    for (NSInteger idx = 0 ; idx < 10; idx ++)
    {
        Item *item = [[Item alloc] init];
        [indexedObject addObject:item];
    }
    
}

@end
