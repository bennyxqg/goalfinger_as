package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class ListMessageSummaryRequest extends GSRequest
    {

        public function ListMessageSummaryRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".ListMessageSummaryRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : ListMessageSummaryRequest
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
                    callback(new ListMessageSummaryResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : ListMessageSummaryRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setEntryCount(param1:Number) : ListMessageSummaryRequest
        {
            this.data["entryCount"] = param1;
            return this;
        }// end function

        public function setOffset(param1:Number) : ListMessageSummaryRequest
        {
            this.data["offset"] = param1;
            return this;
        }// end function

    }
}
