package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class SocialStatusRequest extends GSRequest
    {

        public function SocialStatusRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".SocialStatusRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : SocialStatusRequest
        {
            this.timeoutSeconds = param1;
            return this;
        }// end function

        override public function send(param1:Function) : String
        {
            var callback:* = param1;
            return super.send(function (param1:Object) : void
            {
                if (callback != null)
                {
                    callback(new SocialStatusResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : SocialStatusRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

    }
}
