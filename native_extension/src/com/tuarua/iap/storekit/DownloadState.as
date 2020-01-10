/* Copyright 2019 Tua Rua Ltd.

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

package com.tuarua.iap.storekit {
public final class DownloadState {
    /** Download is inactive, waiting to be downloaded */
    public static var waiting:uint = 0;
    /** Download is actively downloading */
    public static var active:uint = 1;
    /** Download was paused by the user */
    public static var paused:uint = 2;//
    /** Download is finished, content is available */
    public static var finished:uint = 3;
    /** Download failed */
    public static var failed:uint = 4; //
    /** Download was cancelled */
    public static var cancelled:uint = 5;
}
}
