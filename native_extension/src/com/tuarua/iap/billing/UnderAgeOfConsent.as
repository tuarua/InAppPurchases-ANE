package com.tuarua.iap.billing {
public final class UnderAgeOfConsent {
    /** App has not specified how ad requests shall be handled. */
    public static const unspecified:int = 0;
    /** App indicates the ad requests shall be handled in a manner suitable for users under the age of consent. */
    public static const underAgeOfConsent:int = 1;
    /** App indicates the ad requests shall NOT be handled in a manner suitable for users under the age of consent. */
    public static const notUnderAgeOfConsent:int = 2;
}
}
