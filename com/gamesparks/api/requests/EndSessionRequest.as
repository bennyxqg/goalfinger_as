package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class EndSessionRequest extends GSRequest
    {

        public function EndSessionRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".EndSessionRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : EndSessionRequest
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
                    callback(new EndSessionResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : EndSessionRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

    }
}
