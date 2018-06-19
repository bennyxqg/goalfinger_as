package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class GetUploadedRequest extends GSRequest
    {

        public function GetUploadedRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".GetUploadedRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : GetUploadedRequest
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
                    callback(new GetUploadedResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : GetUploadedRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setUploadId(param1:String) : GetUploadedRequest
        {
            this.data["uploadId"] = param1;
            return this;
        }// end function

    }
}
