package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class ListMessageRequest extends GSRequest
    {

        public function ListMessageRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".ListMessageRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : ListMessageRequest
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
                    callback(new ListMessageResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : ListMessageRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setEntryCount(param1:Number) : ListMessageRequest
        {
            this.data["entryCount"] = param1;
            return this;
        }// end function

        public function setInclude(param1:String) : ListMessageRequest
        {
            this.data["include"] = param1;
            return this;
        }// end function

        public function setOffset(param1:Number) : ListMessageRequest
        {
            this.data["offset"] = param1;
            return this;
        }// end function

    }
}
