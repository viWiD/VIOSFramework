//
//  CardPackView.h
//  21
//
//  Created by Nils Fischer on 21.06.13.
//
//

#import "VIPlayingCardPack.h"

@interface CardPackView : UIView <UIScrollViewDelegate>

@property (weak, nonatomic) VIPlayingCardPack *pack;

@property (nonatomic) int displayCardNumber;

@property (nonatomic) BOOL reverse;

@end
