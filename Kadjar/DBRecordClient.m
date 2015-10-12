//
//  DBRecordClient.m
//  Kadjar
//
//  Created by Cesar Jacquet on 03/09/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import "DBRecordClient.h"

@implementation DBRecordClient




-(id) initWithObject:(NSArray *)obj
{
    if(obj.count <= 6){
        return nil;
    }
    self.clientInfoID = [[obj objectAtIndex:0] integerValue];
    self.nom = [NSString stringWithString:[obj objectAtIndex:1]];
    self.prenom = [NSString stringWithString:[obj objectAtIndex:2]];
    self.email = [NSString stringWithString:[obj objectAtIndex:3]];
    self.gsm = [NSString stringWithString:[obj objectAtIndex:4]];
    self.gameCode = [NSString stringWithString:[obj objectAtIndex:5]];
    self.prize = [NSString stringWithString:[obj objectAtIndex:6]];
    return self;
}



@end
