package com.tuarua.iap.billing {
public final class ChildDirected {
    /** App has not specified whether its ad requests should be treated as child directed or not. */
    public static const unspecified:int = 0;
    /** App indicates its ad requests should be treated as child-directed. */
    public static const childDirected:int = 1;
    /** App indicates its ad requests should NOT be treated as child-directed. */
    public static const notChildDirected:int = 2;
}
}
