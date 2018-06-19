package tools
{
    import com.milkmangames.nativeextensions.*;

    public class GAStats extends Object
    {
        private var vRunning:Boolean = false;
        public var vLastPageView:String = "";

        public function GAStats(param1:String)
        {
            if (Global.vIOSVersion > 0 && Global.vIOSVersion < 6)
            {
                param1 = "";
            }
            if (param1 != "")
            {
                if (GAnalytics.isSupported())
                {
                    GAnalytics.create(param1);
                    this.vRunning = true;
                    GAnalytics.analytics.defaultTracker.trackScreenView("AppStart");
                    this.traceDevice();
                    ;
                }
            }
            else
            {
                this.vRunning = false;
            }
            return;
        }// end function

        public function Stats_PageView(param1:String) : void
        {
            if (this.vLastPageView == param1)
            {
                return;
            }
            this.vLastPageView = param1;
            if (!this.vRunning)
            {
                return;
            }
            if (Global.vDebug)
            {
                return;
            }
            GAnalytics.analytics.defaultTracker.trackScreenView(param1);
            return;
        }// end function

        public function Stats_Event(param1:String, param2:String, param3:String = null, param4:int = 0) : void
        {
            Global.addLogTrace("GA event: " + param1 + " | " + param2 + " = " + (isNaN(param4) ? ("NaN") : (param4)) + " ( " + param3 + " )", "GAStats");
            if (!this.vRunning)
            {
                return;
            }
            if (Global.vDebug)
            {
                return;
            }
            GAnalytics.analytics.defaultTracker.trackEvent(param1, param2, param3, param4);
            return;
        }// end function

        public function Stats_Custom(param1:String) : void
        {
            if (!this.vRunning)
            {
                return;
            }
            if (Global.vDebug)
            {
                return;
            }
            return;
        }// end function

        public function Stats_Error(param1:String) : void
        {
            if (!this.vRunning)
            {
                return;
            }
            Global.addLogTrace("GA error: " + param1, "GAStats");
            if (Global.vDebug)
            {
                return;
            }
            GAnalytics.analytics.defaultTracker.trackException(param1, false);
            return;
        }// end function

        public function appLaunched() : void
        {
            if (!this.vRunning)
            {
                return;
            }
            return;
        }// end function

        private function traceDevice() : void
        {
            return;
        }// end function

        private function doTraceDevice(param1:String, param2:String) : void
        {
            this.Stats_Custom(param2);
            return;
        }// end function

    }
}
