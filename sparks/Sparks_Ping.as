package sparks
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;
    import com.greensock.*;
    import flash.utils.*;

    public class Sparks_Ping extends Object
    {
        private var vPingStarted:Boolean = true;
        private var vPrivateKey:int;
        private var vPingKey:int = 0;
        private var vPingKeyReceived:String;
        private var vPingDelay:int = 30;
        private var vPingTolerance:int = 3;
        private var vPingLastTimer:int;
        private var vPingNbError:int = 0;
        private var gs:GS;

        public function Sparks_Ping(param1:GS)
        {
            this.gs = param1;
            this.vPrivateKey = Math.round(99999 * Math.random());
            return;
        }// end function

        private function nextPing() : void
        {
            if (!this.vPingStarted)
            {
                return;
            }
            var _loc_1:* = this;
            var _loc_2:* = this.vPingKey + 1;
            _loc_1.vPingKey = _loc_2;
            this.vPingLastTimer = getTimer();
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Ping").setJSONEventAttribute("cKey", this.vPrivateKey.toString() + "_" + this.vPingKey.toString()).send(this.onPingReceived);
            TweenMax.delayedCall(this.vPingDelay, this.nextPing);
            return;
        }// end function

        private function onPingReceived(param1:LogEventResponse) : void
        {
            var _loc_2:* = param1.getScriptData();
            if (_loc_2 != null)
            {
                this.vPingKeyReceived = _loc_2.cKey;
            }
            return;
        }// end function

        private function checkPing() : void
        {
            if (!this.vPingStarted)
            {
                return;
            }
            Global.addLogTrace("------------ checkPing vPrivateKey=" + this.vPrivateKey + " vPingKey=" + this.vPingKey + " vPingKeyReceived=" + this.vPingKeyReceived, "Sparks_Ping");
            if (this.vPrivateKey.toString() + "_" + this.vPingKey.toString() != this.vPingKeyReceived)
            {
                if (getTimer() > this.vPingLastTimer + this.vPingTolerance * 1000)
                {
                    var _loc_1:* = this;
                    var _loc_2:* = this.vPingNbError + 1;
                    _loc_1.vPingNbError = _loc_2;
                    Global.addLogTrace("Ping Error vPingNbError=" + this.vPingNbError, "Sparks_Ping");
                    if (this.vPingNbError == 3)
                    {
                        Global.addLogTrace("Ping Fatal Error : restartApp", "Sparks_Ping");
                        if (Global.vDev)
                        {
                        }
                        Global.vRoot.restartApp("Ping Error");
                        this.stopPing();
                    }
                }
            }
            else
            {
                this.vPingNbError = 0;
            }
            TweenMax.delayedCall(1, this.checkPing);
            return;
        }// end function

        public function stopPing() : void
        {
            this.vPingStarted = false;
            return;
        }// end function

    }
}
