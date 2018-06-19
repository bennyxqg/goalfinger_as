package com.gamesparks.api.requests
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class BatchAdminRequest extends GSRequest
    {

        public function BatchAdminRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".BatchAdminRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : BatchAdminRequest
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
                    callback(new BatchAdminResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : BatchAdminRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setPlayerIds(param1:Vector.<String>) : BatchAdminRequest
        {
            this.data["playerIds"] = toArray(param1);
            return this;
        }// end function

        public function setRequest(param1:Object) : BatchAdminRequest
        {
            this.data["request"] = param1;
            return this;
        }// end function

    }
}
