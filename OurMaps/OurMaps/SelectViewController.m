//
//  BWSelectViewController.m
//  OurMaps
//
//  Created by Jiangchuan Huang on 9/21/14.
//  Copyright (c) 2014 OurMaps. All rights reserved.
//


#import "SelectViewController.h"

static NSString *CellIdentifier = @"Cell";


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SelectViewController ()

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SelectViewController

@synthesize items = _items;
@synthesize selectedIndexPaths = _selectedIndexPaths;
@synthesize multiSelection = _multiSelection;
@synthesize cellClass = _cellClass;
@synthesize allowEmpty = _allowEmpty;
@synthesize selectBlock = _selectBlock;


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithItems:(NSArray *)items
     multiselection:(BOOL)multiSelection
         allowEmpty:(BOOL)allowEmpty
      selectedItems:(NSArray *)selectedItems
        selectBlock:(SelectViewControllerDidSelectBlock)selectBlock; {
    
    self = [self init];
    if (self) {
        self.items = items;
        self.multiSelection = multiSelection;
        self.allowEmpty = allowEmpty;
        [self.selectedIndexPaths addObjectsFromArray:selectedItems];
        self.selectBlock = selectBlock;
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.multiSelection = NO;
        self.cellClass = [UITableViewCell class];
        self.allowEmpty = NO;
        _selectedIndexPaths = [[NSMutableArray alloc] init];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setDidSelectBlock:(SelectViewControllerDidSelectBlock)didSelectBlock {
    self.selectBlock = didSelectBlock;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSelectedIndexPaths:(NSArray *)indexPaths {
    [self.selectedIndexPaths removeAllObjects];
    [self.selectedIndexPaths addObjectsFromArray:indexPaths];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view data source


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (nil == cell) {
        cell = [[self.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
    
    cell.accessoryType = [self.selectedIndexPaths containsObject:indexPath] ?
    UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma Table view delegate


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *indexPathsToReload = [NSMutableArray arrayWithObject:indexPath];
    
    if ([self.selectedIndexPaths containsObject:indexPath]) {
        if (YES == self.allowEmpty || (self.selectedIndexPaths.count > 1 && NO == self.allowEmpty) ) {
            [self.selectedIndexPaths removeObject:indexPath];
        }
    } else {
        if (NO == self.multiSelection) {
            [indexPathsToReload addObjectsFromArray:self.selectedIndexPaths];
            [self.selectedIndexPaths removeAllObjects];
        }
        
        [self.selectedIndexPaths addObject:indexPath];
    }
    
    [self.tableView reloadRowsAtIndexPaths:indexPathsToReload
                          withRowAnimation:UITableViewRowAnimationNone];
    
    if (nil != self.selectBlock)
        self.selectBlock(self.selectedIndexPaths, self);
}


@end
