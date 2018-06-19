package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class GetPropertyRequest extends GSRequest
    {

        public function GetPropertyRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".GetPropertyRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : GetPropertyRequest
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
                    callback(new GetPropertyResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : GetPropertyRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setPropertyShortCode(param1:String) : GetPropertyRequest
        {
            this.data["propertyShortCode"] = param1;
            return this;
        }// end function

    }
}
