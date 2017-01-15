//
//  TransitHandler.m
//  interlocking
//
//  Created by Ian Meyer on 11/2/15.
//  Copyright © 2015 Ian Meyer. All rights reserved.
//

#import "TransitHandler.h"

static TransitHandler *_defaultHandler = nil;

NSString *const kXMLReaderTextNodeKey = @"textInProgress";

@interface TransitHandler () <NSXMLParserDelegate>

@property (readwrite) NSDictionary *transitData;

@property (readwrite) BOOL updating;
@property (readwrite) NSDate *lastUpdated;

@property (readwrite) NSArray *subwayLineStatus;

//Parser internals
@property NSMutableDictionary *rootDictionary;
@property NSMutableArray *elementStack;
@property NSMutableDictionary *elementInProgress;
@property NSMutableString *textInProgress;

@end

@implementation TransitHandler

+ (TransitHandler *)defaultHandler {
    if ( !_defaultHandler ) {
        _defaultHandler = [TransitHandler new];
    }
    return _defaultHandler;
}

- (void)updateDataWithCompletion:(void (^)(NSArray<SubwayLine *> *, NSError *))completionBlock {
    NSURL *dataURL = [NSURL URLWithString:@"http://web.mta.info/status/serviceStatus.txt"];
    NSURLSessionTask *dataTask = [[NSURLSession sharedSession]
                                  dataTaskWithURL:dataURL
                                  completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                      if ( error ) {
                                          NSLog(@"error updating status: %@", error);
                                          if ( completionBlock ) {
                                              completionBlock(nil, error);
                                          }
                                          return;
                                      }
                                      NSString *tmpDataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSLog(@"fetched status: %@ bytes", @(tmpDataString.length));
                                      
                                      NSXMLParser *tmpParser = [[NSXMLParser alloc] initWithData:[tmpDataString dataUsingEncoding:NSUTF8StringEncoding]];
                                      [tmpParser setDelegate:self];
                                      BOOL tmpParsed = [tmpParser parse];
                                      
                                      if ( tmpParsed ) {
                                          tmpParsed = [self parseTransitData:self.transitData];
                                      }
                                      
                                      if ( tmpParsed ) {
                                          if ( completionBlock ) {
                                              dispatch_async(dispatch_get_main_queue(), ^{ completionBlock(self.subwayLineStatus, nil); });
                                          }
                                      } else {
                                          NSLog(@"parsing failed! clearing all data");
                                          self.rootDictionary = nil;
                                          self.transitData = nil;
                                          self.subwayLineStatus = nil;
                                          
                                          if ( completionBlock ) {
                                              NSError *tmpError = nil; // wat
                                              dispatch_async(dispatch_get_main_queue(), ^{ completionBlock(nil, tmpError); });
                                          }
                                      }
                                  }];
    [dataTask resume];
}

+ (NSString *)formattedNameFromString:(NSString *)string {
    NSString *rtnString = string;

    
    if ( [rtnString rangeOfString:@"1"].location != NSNotFound ) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"1" withString:@"①"];
    }

    if ( [rtnString rangeOfString:@"2"].location != NSNotFound ) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"2" withString:@"②"];
    }

    if ( [rtnString rangeOfString:@"3"].location != NSNotFound ) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"3" withString:@"③"];
    }

    if ( [rtnString rangeOfString:@"4"].location != NSNotFound ) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"4" withString:@"④"];
    }

    if ( [rtnString rangeOfString:@"5"].location != NSNotFound ) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"5" withString:@"⑤"];
    }

    if ( [rtnString rangeOfString:@"6"].location != NSNotFound ) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"6" withString:@"⑥"];
    }

    if ( [rtnString rangeOfString:@"7"].location != NSNotFound ) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"7" withString:@"⑦"];
    }


    
    if ( [rtnString rangeOfString:@"A"].location != NSNotFound ) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"A" withString:@"Ⓐ"];
    }
    
    if ( [rtnString rangeOfString:@"B"].location != NSNotFound ) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"B" withString:@"Ⓑ"];
    }
    
    if ( [rtnString rangeOfString:@"C"].location != NSNotFound ) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"C" withString:@"Ⓒ"];
    }
    
    if ( [rtnString rangeOfString:@"D"].location != NSNotFound ) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"D" withString:@"Ⓓ"];
    }
    
    if ( [rtnString rangeOfString:@"E"].location != NSNotFound ) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"E" withString:@"Ⓔ"];
    }
    
    if ( [rtnString rangeOfString:@"F"].location != NSNotFound ) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"F" withString:@"Ⓕ"];
    }
    
    if ( [rtnString rangeOfString:@"G"].location != NSNotFound ) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"G" withString:@"Ⓖ"];
    }
    
    if ( [rtnString rangeOfString:@"J"].location != NSNotFound ) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"J" withString:@"Ⓙ"];
    }
    
    if ( [rtnString rangeOfString:@"L"].location != NSNotFound ) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"L" withString:@"Ⓛ"];
    }
    
    if ( [rtnString rangeOfString:@"M"].location != NSNotFound ) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"M" withString:@"Ⓜ︎"];
    }
    
    if ( [rtnString rangeOfString:@"N"].location != NSNotFound ) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"N" withString:@"Ⓝ"];
    }
    
    if ( [rtnString rangeOfString:@"Q"].location != NSNotFound ) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"Q" withString:@"Ⓠ"];
    }
    
    if ( [rtnString rangeOfString:@"R"].location != NSNotFound ) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"R" withString:@"Ⓡ"];
    }
    
    if ( [rtnString rangeOfString:@"S"].location != NSNotFound ) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"S" withString:@"Ⓢ"];
    }
    
    if ( [rtnString rangeOfString:@"Z"].location != NSNotFound ) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"Z" withString:@"Ⓩ"];
    }
    
    return rtnString;
}

- (BOOL)parseTransitData:(NSDictionary *)transitData {
    BOOL rtnStatus = NO;
    
    // TODO: parse dictionary into array of subway line objects
    NSMutableArray *tmpSubwayLines = [NSMutableArray array];;
    for ( NSDictionary *tmpSubwayDict in [transitData valueForKeyPath:@"service.subway.line"] ) {
        SubwayLine *tmpSubwayLine = [[SubwayLine alloc] initWithDictionary:tmpSubwayDict];
        if ( tmpSubwayLine && ![tmpSubwayLine.name isEqualToString:@"SIR"] ) {
            [tmpSubwayLines addObject:tmpSubwayLine];
        }
    }
    if ( tmpSubwayLines.count > 0 ) {
        self.subwayLineStatus = [NSArray arrayWithArray:tmpSubwayLines];
        rtnStatus = YES;
    }
    
    // try to parse a date?
    NSString *tmpTimestampString = [transitData valueForKeyPath:@"service.timestamp"];
    NSDate *tmpTimestampDate = [[NSDateFormatter transitTimestampFormatter] dateFromString:tmpTimestampString];
    self.lastUpdated = tmpTimestampDate;
    
    return rtnStatus;
}

#pragma - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"parseErrorOccurred: %@", parseError);
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    // NSLog(@"parserDidStartDocument: %@", parser);

    self.rootDictionary = [NSMutableDictionary dictionary];
    self.elementStack = [NSMutableArray arrayWithObject:self.rootDictionary];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    // starting a new element, create a dictionary for its values
    self.elementInProgress = [NSMutableDictionary dictionary];
    // and add it to the stack
    [self.elementStack addObject:self.elementInProgress];
    
    // and (re)set the text builder
    self.textInProgress = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.textInProgress appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    // update the value of the current element
    if ( self.textInProgress ) {
        [self.elementInProgress setObject:self.textInProgress forKey:elementName];
    }
    
    NSMutableDictionary *tmpFinishedElement = self.elementInProgress;
    
    // pop it from the in-progress stack
    [self.elementStack removeObject:self.elementInProgress];

    // and pick up the last one
    self.elementInProgress = self.elementStack.lastObject;

    // and finally, put the finished element in its parent
    NSObject *existingElement = [self.elementInProgress objectForKey:elementName];
    if ( [existingElement isKindOfClass:[NSArray class]] ) {
        // add to existing collection
        NSArray *tmpArray = [(NSArray *)existingElement arrayByAddingObject:tmpFinishedElement];
        [self.elementInProgress setObject:tmpArray forKey:elementName];
    } else if ( [existingElement isKindOfClass:[NSDictionary class]] ) {
        // multiple entries, array it with the newly finished one
        NSArray *tmpArray = @[existingElement, tmpFinishedElement];
        [self.elementInProgress setObject:tmpArray forKey:elementName];
    } else if ( tmpFinishedElement.count == 1 && self.textInProgress ) {
        // only one value, and text. don't put the whole dictionary in the parent
        [self.elementInProgress addEntriesFromDictionary:tmpFinishedElement];
    } else {
        // multiple keys in this element, stick the whole thing in there
        [self.elementInProgress setObject:tmpFinishedElement forKey:elementName];
    }
    
    // don't forget to reset the string!
    self.textInProgress = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    self.transitData = self.rootDictionary;
    self.rootDictionary = nil;
}

@end

static NSDateFormatter *_transitTimestampFormatter = nil;

@implementation NSDateFormatter (TransitHandler)

+ (NSDateFormatter *)transitTimestampFormatter {
    if ( !_transitTimestampFormatter ) {
        // create and configure
        _transitTimestampFormatter = [[NSDateFormatter alloc] init];
        [_transitTimestampFormatter setDateFormat:@"M/d/yyyy hh:mm:ss a"];
        [_transitTimestampFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    }
    return _transitTimestampFormatter;
}

@end
