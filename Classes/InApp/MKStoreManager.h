

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "MKStoreObserver.h"

@interface MKStoreManager : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver> {
	NSMutableArray *purchasableObjects;
	MKStoreObserver *storeObserver;
}

@property (nonatomic, retain) NSMutableArray *purchasableObjects;
@property (nonatomic, retain) MKStoreObserver *storeObserver;

- (void) requestProductData;

- (void) buyFeatureA; // expose product buying functions, do not expose
- (void) buyFeatureB; // expose product buying functions, do not expose
- (void) buyFeatureC; // expose product buying functions, do not expose
- (void) buyFeatureD; // expose product buying functions, do not expose
- (void) buyFeatureE; // expose product buying functions, do not expose
// do not call this directly. This is like a private method
- (void) buyFeature:(NSString*) featureId;
-(void) buyUnloadAll;

- (void) failedTransaction: (SKPaymentTransaction *)transaction;
-(void) provideContent: (NSString*) productIdentifier;

+ (MKStoreManager*)sharedManager;

+ (BOOL) featureAPurchased;
+ (BOOL) featureBPurchased;

+(void) loadPurchases;
+(void) updatePurchases;

+(void) makePaidVersion;
+(void) make10Persion;

-(void)restoreFunc;

@end
