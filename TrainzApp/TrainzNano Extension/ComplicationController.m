//
//  ComplicationController.m
//  TrainzNano Extension
//
//  Created by Ian Meyer on 1/14/17.
//  Copyright © 2017 Ian Meyer. All rights reserved.
//

#import "ComplicationController.h"

@interface ComplicationController ()

@end

@implementation ComplicationController

#pragma mark - Timeline Configuration

- (void)getSupportedTimeTravelDirectionsForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimeTravelDirections directions))handler {
    handler(CLKComplicationTimeTravelDirectionForward|CLKComplicationTimeTravelDirectionBackward);
}

- (void)getTimelineStartDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler(nil);
}

- (void)getTimelineEndDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler(nil);
}

- (void)getPrivacyBehaviorForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationPrivacyBehavior privacyBehavior))handler {
    handler(CLKComplicationPrivacyBehaviorShowOnLockScreen);
}

#pragma mark - Timeline Population

- (void)getCurrentTimelineEntryForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimelineEntry * __nullable))handler {
    // Call the handler with the current timeline entry
    handler([CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:[self templateForComplication:complication] timelineAnimationGroup:nil]);
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication beforeDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries prior to the given date
    handler(nil);
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication afterDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries after to the given date
    handler(nil);
}

#pragma mark - Placeholder Templates

- (void)getLocalizableSampleTemplateForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTemplate * __nullable complicationTemplate))handler {
    // This method will be called once per supported complication, and the results will be cached
    handler([self templateForComplication:complication]);
}

#pragma mark - Utilities

- (CLKComplicationTemplate *)templateForComplication:(CLKComplication *)complication {
    CLKComplicationTemplate *rtnTemplate = nil;
    
    switch (complication.family) {
        case CLKComplicationFamilyExtraLarge: {
            CLKComplicationTemplateExtraLargeStackImage *tmpTemplate = [[CLKComplicationTemplateExtraLargeStackImage alloc] init];
            [tmpTemplate setLine1ImageProvider:[CLKImageProvider imageProviderWithOnePieceImage:[UIImage imageNamed:@"train"]]];
            [[tmpTemplate line1ImageProvider] setTintColor:[UIColor orangeColor]];
            [tmpTemplate setLine2TextProvider:[CLKTextProvider textProviderWithFormat:@"Good Service"]];
            rtnTemplate = tmpTemplate;
        }
            break;
            
        case CLKComplicationFamilyModularLarge: {
            CLKComplicationTemplateModularLargeStandardBody *tmpTemplate = [[CLKComplicationTemplateModularLargeStandardBody alloc] init];
            [(CLKComplicationTemplateModularLargeStandardBody*)tmpTemplate setHeaderTextProvider:[CLKTextProvider textProviderWithFormat:@"Good Service"]];
            [(CLKComplicationTemplateModularLargeStandardBody*)tmpTemplate setBody1TextProvider:[CLKTextProvider textProviderWithFormat:@"On your favorite train lines."]];
            rtnTemplate = tmpTemplate;
        }
            break;
            
        case CLKComplicationFamilyModularSmall: {
            CLKComplicationTemplateModularSmallStackText *tmpTemplate = [[CLKComplicationTemplateModularSmallStackText alloc] init];
            [(CLKComplicationTemplateModularSmallStackText*)tmpTemplate setLine1TextProvider:[CLKTextProvider textProviderWithFormat:@"Good Service"]];
            [(CLKComplicationTemplateModularSmallStackText*)tmpTemplate setLine2TextProvider:[CLKTextProvider textProviderWithFormat:@"On your favorite train lines."]];
            rtnTemplate = tmpTemplate;
        }   break;
            
        case CLKComplicationFamilyCircularSmall: {
            CLKComplicationTemplateCircularSmallStackText *tmpTemplate = [[CLKComplicationTemplateCircularSmallStackText alloc] init];
            [(CLKComplicationTemplateModularSmallStackText*)tmpTemplate setLine1TextProvider:[CLKTextProvider textProviderWithFormat:@"Good Service"]];
            [(CLKComplicationTemplateModularSmallStackText*)tmpTemplate setLine2TextProvider:[CLKTextProvider textProviderWithFormat:@"On your favorite train lines."]];
            rtnTemplate = tmpTemplate;
        }   break;
            
        case CLKComplicationFamilyUtilitarianLarge: {
            CLKComplicationTemplateUtilitarianLargeFlat *tmpTemplate = [[CLKComplicationTemplateUtilitarianLargeFlat alloc] init];
            [(CLKComplicationTemplateUtilitarianSmallFlat*)tmpTemplate setImageProvider:[CLKImageProvider imageProviderWithOnePieceImage:[UIImage imageNamed:@"train"]]];
            [[tmpTemplate imageProvider] setTintColor:[UIColor orangeColor]];
            [(CLKComplicationTemplateUtilitarianSmallFlat*)tmpTemplate setTextProvider:[CLKTextProvider textProviderWithFormat:@"Good Service"]];
            rtnTemplate = tmpTemplate;
        }   break;
            
        case CLKComplicationFamilyUtilitarianSmall: {
            CLKComplicationTemplateUtilitarianSmallRingText *tmpTemplate = [[CLKComplicationTemplateUtilitarianSmallRingText alloc] init];
            [(CLKComplicationTemplateUtilitarianSmallFlat*)tmpTemplate setTextProvider:[CLKTextProvider textProviderWithFormat:@"Good Service"]];
            // configure ring?
            rtnTemplate = tmpTemplate;
        }   break;
            
        case CLKComplicationFamilyUtilitarianSmallFlat: {
            CLKComplicationTemplateUtilitarianSmallFlat *tmpTemplate = [[CLKComplicationTemplateUtilitarianSmallFlat alloc] init];
            [(CLKComplicationTemplateUtilitarianSmallFlat*)tmpTemplate setTextProvider:[CLKTextProvider textProviderWithFormat:@"Good Service"]];
            rtnTemplate = tmpTemplate;
        }   break;
    }

    return rtnTemplate;
}

@end
