//
//  ViewController.m
//  TestTaskAV
//
//  Created by Vladislav Andreev on 10.10.17.
//  Copyright © 2017 Vladislav Andreev. All rights reserved.
//

#import "ViewController.h"
#import <stdlib.h>
#import <time.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *primesLabel;
@property (strong, nonatomic) NSArray *firstPrimes;
@property (assign, nonatomic) BOOL isBlackBackgroundShown;

@end

long long start = 1000000000000000000;
int k = 63; // accurancy for 9223372036854775807 = long long MAX

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isBlackBackgroundShown = YES;
    self.firstPrimes = @[@3, @5, @7, @11, @13, @17, @19, @23, @29, @31,
                         @37, @41, @43, @47, @53, @59, @61, @67, @71, @73,
                         @79, @83, @89, @97, @101, @103, @107, @109, @113,
                         @127, @131, @137, @139, @149, @151, @157, @163,
                         @167, @173, @179, @181, @191, @193, @197, @199,
                         @211, @223, @227, @229, @233, @239, @241, @251];
    
    if (start % 2 == 0) {
        start += 1;
    }
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (long long i = start; i <= LONG_MAX; i += 2) {
            if([self isProbablyPrime:i k:k]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.primesLabel.text = [NSString stringWithFormat:@"%lld", i];
                });
            }
        }
    });
}


- (bool) isProbablyPrime: (long long)n k: (int)k {

    
    for (NSNumber *prime in self.firstPrimes) {
        int num = [prime intValue];
        if (n % num == 0) { return false; }
    }
    
    long long d = n-1;
    int s = 0;
    while (d % 2 == 0) {
        d = d / 2;
        s++;
    }

    srand(time(NULL));
    for (int i = 0; i < k; i++) {
        long long a = (rand() % (n - 2)) + 2;
        long long x = [self powBase:a pow:d mod:n];
        if (x == 1 || x == (n - 1)) {
            continue;
        }
        bool shouldDoubleBreak = false;
        for (int j = 0; j < s; j++) {
            x = (x * x) % n;
            if (x == 1) {
                return false;
            }
            if(x == (n - 1)) {
                shouldDoubleBreak = true;
                break;
            }
        }

        if (shouldDoubleBreak && x != (n-1)) {
            return false;
        }

    }

    return true;

}

-(long long) powBase: (long long) base pow:(long long) pow  mod:(long long) mod{
    if(pow == 0)
        return 1;
    if(pow % 2 ==0){
        long long t = [self powBase: base pow: pow / 2 mod: mod];
        return [self multiply: t b: t mod: mod] % mod;
    }
    return ([self multiply:[self powBase: base pow: pow-1 mod: mod] b: base mod: mod]) % mod;
}


-(long long)multiply:(long long) a b:(long long) b mod:(long long) mod {
    if(b == 1)
        return a;
    if(b % 2 == 0){
        long long t = [self multiply: a b: b / 2 mod: mod];
        return (2 * t) % mod;
    }
    return ([self multiply: a b: b - 1 mod: mod] + a) % mod;
}

- (IBAction)showHideButtonAction:(UIButton *)sender {
    
    if (self.isBlackBackgroundShown) {
        
        [UIView animateWithDuration:1 animations:^{
            self.primesLabel.alpha = 0.0f;
        }];
        
        [sender setTitle:@"show!" forState:UIControlStateNormal];
        self.isBlackBackgroundShown = NO;
        
    } else {
        
        [UIView animateWithDuration:1 animations:^{
            self.primesLabel.alpha = 1.0f;
        }];
        
        [sender setTitle:@"hide!" forState:UIControlStateNormal];
        self.isBlackBackgroundShown = YES;
        
    }
    
}


@end
