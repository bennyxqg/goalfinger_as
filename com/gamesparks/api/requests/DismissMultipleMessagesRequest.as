package com.gamesparks.api.requests
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class DismissMultipleMessagesRequest extends GSRequest
    {

        public function DismissMultipleMessagesRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".DismissMultipleMessagesRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : DismissMultipleMessagesRequest
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
                    callback(new DismissMultipleMessagesResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : DismissMultipleMessagesRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setMessageIds(param1:Vector.<String>) : DismissMultipleMessagesRequest
        {
            this.data["messageIds"] = toArray(param1);
            return this;
        }// end function

    }
}
