//
//  BarcodeData+CoreDataProperties.h
//  
//
//  Created by Ephraim Kunz on 6/23/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BarcodeData.h"

NS_ASSUME_NONNULL_BEGIN

@interface BarcodeData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *barcode;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *detail;
@property (nullable, nonatomic, retain) NSNumber *rottenRating;
@property (nullable, nonatomic, retain) NSNumber *metaRating;
@property (nullable, nonatomic, retain) NSNumber *imdbRating;

@end

NS_ASSUME_NONNULL_END
