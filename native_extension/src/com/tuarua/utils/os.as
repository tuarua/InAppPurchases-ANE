package com.tuarua.utils {

import flash.system.Capabilities;

public final class os {
    private static const platform:String = Capabilities.version.substr(0, 3).toLowerCase();
    public static const isWindows:Boolean = platform == "win";
    public static const isOSX:Boolean = platform == "mac";
    public static const isAndroid:Boolean = platform == "and";
    public static const isIos:Boolean = platform == "ios" && Capabilities.os.toLowerCase().indexOf("tvos") == -1;
    public static const isTvos:Boolean = Capabilities.os.toLowerCase().indexOf("tvos") > -1;
}
}