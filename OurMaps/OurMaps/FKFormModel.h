//
//  FKFormModel.h
//  OurMaps
//
//  Created by Jiangchuan Huang on 9/21/14.
//  Copyright (c) 2014 OurMaps. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FKBlocks.h"

@class BKCellMapping;
@class FKFormMapping;
@class FKFormAttributeMapping;

@interface FKFormModel : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, retain) id object;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, assign) Class selectControllerClass;
@property (nonatomic, assign) Class longTextControllerClass;
@property (nonatomic, copy, readonly) FKFormMappingDidChangeValueBlock didChangeValueBlock;
@property (nonatomic, copy, readonly) FKFormMappingConfigureCellBlock configureCellsBlock;
@property (nonatomic, retain) UIView *viewOrigin;
@property (nonatomic, strong) UIColor *labelTextColor;
@property (nonatomic, strong) UIColor *valueTextColor;
@property (nonatomic, assign) Class topHeaderViewClass;
@property (nonatomic, assign) Class bottomHeaderViewClass;

/**
 A set of attribute names with invalid values.
 
 Make sure you use the same strings that you used when mapping  attributes.
 
 You should call reloadData on your table view after setting this value.
 */
@property (nonatomic,strong) NSSet *invalidAttributes;

/**
 Color used for the title label in table cells for attribues with invalid values.
 
 The default is red.
 */
@property (nonatomic,strong) UIColor *validationErrorColor;

/**
 Cell background color in table cells for attribues with values.
 */
@property (nonatomic, strong) UIColor *validationNormalCellBackgroundColor;

/**
 Cell background color in table cells for attribues with invalid values.
 */
@property (nonatomic, strong) UIColor *validationErrorCellBackgroundColor;

+ (id)formTableModelForTableView:(UITableView *)tableView;

+ (id)formTableModelForTableView:(UITableView *)tableView
            navigationController:(UINavigationController *)navigationController;

- (id)initWithTableView:(UITableView *)tableView
   navigationController:(UINavigationController *)navigationController;

- (void)registerMapping:(FKFormMapping *)formMapping;

- (void)loadFieldsWithObject:(id)object;

- (void)reloadRowWithIdentifier:(NSString *)identifier;

- (void)reloadRowWithAttributeMapping:(FKFormAttributeMapping *)attributeMapping;

- (void)reloadSectionWithIdentifier:(NSString *)sectionIdentifier;

- (void)setDidChangeValueWithBlock:(FKFormMappingDidChangeValueBlock)didChangeValueBlock;

- (void)configureCells:(FKFormMappingConfigureCellBlock)configureCellsBlock;

/**
 Find the first UITextField or UITextView in the table view.
 @return Return first UITextField or UITextView.
 */
- (id)findFirstTextField;

/**
 Find all UITextField or UITextView in the table view.
 @return Return an array of UITextField and UITextView.
 */
- (NSArray *)findTextFields;

/**
 Save all attributes
 */
- (void)save;

- (void)validateForm;

- (BOOL)isFormValid;

- (void)validateFieldWithIdentifier:(NSString *)identifier;

@end