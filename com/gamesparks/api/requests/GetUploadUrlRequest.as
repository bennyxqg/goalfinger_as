﻿package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class GetUploadUrlRequest extends GSRequest
    {

        public function GetUploadUrlRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".GetUploadUrlRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : GetUploadUrlRequest
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
                    callback(new GetUploadUrlResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : GetUploadUrlRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setUploadData(param1:Object) : GetUploadUrlRequest
        {
            this.data["uploadData"] = param1;
            return this;
        }// end function

    }
}
