//
//  VIArrayDataSource.h
//  living
//
//  Created by Nils Fischer on 28.05.14.
//  Copyright (c) 2014 viWiD Webdesign & iOS Development. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "VIArraySectionInfo.h"

typedef UITableViewCell *(^VITableViewCellDequeueAndConfigureBlock)(UITableView *tableView, NSIndexPath *indexPath, id object);


@interface VIArrayDataSource : NSObject <UITableViewDataSource>

@property (strong, nonatomic) NSArray *array;
@property (strong, nonatomic) NSArray *sortDescriptors;
@property (strong, nonatomic) NSString *sectionNameKeyPath;
@property (strong, nonatomic) VITableViewCellDequeueAndConfigureBlock cellBlock;

- (id)initWithArray:(NSArray *)array sortDescriptors:(NSArray *)sortDescriptors sectionNameKeyPath:(NSString *)keyPath cellBlock:(VITableViewCellDequeueAndConfigureBlock)cellBlock;

- (NSArray *)objects;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray *)sections;
- (NSArray *)sectionIndexTitles;
- (NSInteger)sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;

@end
