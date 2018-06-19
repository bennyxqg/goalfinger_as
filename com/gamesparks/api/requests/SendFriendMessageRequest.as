package com.gamesparks.api.requests
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class SendFriendMessageRequest extends GSRequest
    {

        public function SendFriendMessageRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".SendFriendMessageRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : SendFriendMessageRequest
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
                    callback(new SendFriendMessageResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : SendFriendMessageRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setFriendIds(param1:Vector.<String>) : SendFriendMessageRequest
        {
            this.data["friendIds"] = toArray(param1);
            return this;
        }// end function

        public function setMessage(param1:String) : SendFriendMessageRequest
        {
            this.data["message"] = param1;
            return this;
        }// end function

    }
}
