//
//  TimeModel+CoreDataProperties.h
//  Alarm Clock
//
//  Created by mymac on 16/9/30.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TimeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TimeModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *time;
@property (nullable, nonatomic, retain) NSNumber *number;

@end

NS_ASSUME_NONNULL_END
