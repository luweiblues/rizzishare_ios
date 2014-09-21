//
//  FKFormMapping.h
//  OurMaps
//
//  Created by Jiangchuan Huang on 9/21/14.
//  Copyright (c) 2014 OurMaps. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "FKFormAttributeMapping.h"
#import "FKBlocks.h"

@interface FKFormMapping : NSObject {
    NSMutableDictionary *_attributeMappings;
    NSMutableDictionary *_sectionTitles;
    NSMutableDictionary *_attributeValidations;
    FKFormAttributeMapping *_saveAttribute;
}

@property (nonatomic, assign) Class objectClass;
@property (nonatomic, readonly) NSDictionary *attributeMappings;
@property (nonatomic, readonly) NSDictionary *sectionTitles;
@property (nonatomic, readonly) NSDictionary *attributeValidations;
@property (nonatomic, retain) NSArray *fieldsOrder;
@property (nonatomic, retain) FKFormAttributeMapping *saveAttribute;
@property (nonatomic, assign) Class textFieldClass;
@property (nonatomic, assign) Class floatFieldClass;
@property (nonatomic, assign) Class integerFieldClass;
@property (nonatomic, assign) Class labelFieldClass;
@property (nonatomic, assign) Class passwordFieldClass;
@property (nonatomic, assign) Class switchFieldClass;
@property (nonatomic, assign) Class saveButtonFieldClass;
@property (nonatomic, assign) Class disclosureIndicatorAccessoryField;
@property (nonatomic, assign) Class sliderFieldClass;
@property (nonatomic, assign) Class buttonFieldClass;
@property (nonatomic, assign) Class separatorFieldClass;
@property (nonatomic, assign) CGFloat separatorMargin;

- (id)initWithObjectClass:(Class)objectClass;

+ (id)mappingForClass:(Class)objectClass block:(void(^)(FKFormMapping *mapping))block;

- (FKFormAttributeMapping *)mapAttribute:(NSString *)attribute title:(NSString *)title;

- (FKFormAttributeMapping *)mapAttribute:(NSString *)attribute
                                   title:(NSString *)title
                         placeholderText:(NSString *)placeholderText
                                    type:(FKFormAttributeMappingType)type;

- (FKFormAttributeMapping *)mapAttribute:(NSString *)attribute
                                   title:(NSString *)title
                                    type:(FKFormAttributeMappingType)type;

- (FKFormAttributeMapping *)mapAttribute:(NSString *)attribute
                                   title:(NSString *)title
                                    type:(FKFormAttributeMappingType)type
                            keyboardType:(UIKeyboardType)keyboardType;

- (FKFormAttributeMapping *)mapAttribute:(NSString *)attribute
                                   title:(NSString *)title
                                    type:(FKFormAttributeMappingType)type
                         controllerClass:(Class)controllerClass;

- (FKFormAttributeMapping *)mapSliderAttribute:(NSString *)attribute
                                         title:(NSString *)title
                                      minValue:(float)minValue
                                      maxValue:(float)maxValue
                                    valueBlock:(FKFormMappingSliderValueBlock)valueBlock;

- (FKFormAttributeMapping *)mapAttribute:(NSString *)attribute
                                   title:(NSString *)title
                                    type:(FKFormAttributeMappingType)type
                         dateFormatBlock:(FKFormMappingDateFormatBlock)dateFormatBlock;

- (FKFormAttributeMapping *)mapAttribute:(NSString *)attribute
                                   title:(NSString *)title
                                    type:(FKFormAttributeMappingType)type
                              dateFormat:(NSString *)dateFormat;;

- (FKFormAttributeMapping *)mapAttribute:(NSString *)attribute
                                   title:(NSString *)title
                            showInPicker:(BOOL)showInPicker
                       selectValuesBlock:(FKFormMappingSelectValueBlock)selectValueBlock
                    valueFromSelectBlock:(FKFormMappingValueFromSelectBlock)valueFromSelectBlock
                         labelValueBlock:(FKFormMappingSelectLabelValueBlock)labelValue;

- (FKFormAttributeMapping *)mapCustomCell:(Class)cell
                               identifier:(NSString *)identifier
                     willDisplayCellBlock:(FKFormMappingWillDisplayCellBlock)willDisplayCellBlock
                           didSelectBlock:(FKFormMappingCellSelectionBlock)selectionBlock;

- (FKFormAttributeMapping *)mapCustomCell:(Class)cell
                               identifier:(NSString *)identifier
                                rowHeight:(CGFloat)rowHeight
                     willDisplayCellBlock:(FKFormMappingWillDisplayCellBlock)willDisplayCellBlock
                           didSelectBlock:(FKFormMappingCellSelectionBlock)selectionBlock;

- (FKFormAttributeMapping *)mapCustomCell:(Class)cell
                               identifier:(NSString *)identifier
                                rowHeight:(CGFloat)rowHeight
                                blockData:(id)data
                     willDisplayCellBlock:(FKFormMappingWillDisplayCellWithDataBlock)willDisplayCellBlock
                           didSelectBlock:(FKFormMappingCellSelectionWithDataBlock)selectionBlock;

- (void)sectionWithTitle:(NSString *)title identifier:(NSString *)identifier;

- (void)sectionWithTitle:(NSString *)title footer:(NSString *)footer identifier:(NSString *)identifier;

- (FKFormAttributeMapping *)button:(NSString *)title
                        identifier:(NSString *)identifier
                           handler:(FKFormMappingButtonHandlerBlock)blockHandler
                      accesoryType:(UITableViewCellAccessoryType)accesoryType;

- (FKFormAttributeMapping *)buttonSave:(NSString *)title handler:(FKBasicBlock)blockHandler;

- (void)mappingForAttribute:(NSString *)attribute
           attributeMapping:(FKFormMappingAttributeMappingBlock)attributeMappingBlock;

- (void)mappingForAttribute:(NSString *)attribute
                      title:(NSString *)title
                       type:(FKFormAttributeMappingType)type
           attributeMapping:(FKFormMappingAttributeMappingBlock)attributeMappingBlock;

- (void)validationForAttribute:(NSString *)attribute validBlock:(FKFormMappingIsValueValidBlock)validBlock;

- (void)validationForAttribute:(NSString *)attribute
                    validBlock:(FKFormMappingIsValueValidBlock)validBlock
             errorMessageBlock:(FKFormMappingFieldErrorStringBlock)errorMessageBlock;

@end