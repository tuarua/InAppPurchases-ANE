/* Copyright 2018 Tua Rua Ltd.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "FreMacros.h"
#import "InAppPurchasesANE_oc.h"
#import <InAppPurchasesANE_FW/InAppPurchasesANE_FW.h>

#define FRE_OBJC_BRIDGE TRIAP_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation InAppPurchasesANE_LIB
SWIFT_DECL(TRIAP) // use unique prefix throughout to prevent clashes with other ANEs
CONTEXT_INIT(TRIAP) {
    SWIFT_INITS(TRIAP)
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/
    
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRIAP, init)
        ,MAP_FUNCTION(TRIAP, createGUID)
        ,MAP_FUNCTION(TRIAP, retrieveProductsInfo)
        ,MAP_FUNCTION(TRIAP, getProductsInfo)
        ,MAP_FUNCTION(TRIAP, canMakePayments)
        ,MAP_FUNCTION(TRIAP, purchaseProduct)
        ,MAP_FUNCTION(TRIAP, getPurchaseProduct)
        ,MAP_FUNCTION(TRIAP, finishTransaction)
    };
    
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRIAP) {
    [TRIAP_swft dispose];
    TRIAP_swft = nil;
    TRIAP_freBridge = nil;
    TRIAP_swftBridge = nil;
    TRIAP_funcArray = nil;
}
EXTENSION_INIT(TRIAP)
EXTENSION_FIN(TRIAP)
@end
