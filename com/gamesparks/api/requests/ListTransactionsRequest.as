package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class ListTransactionsRequest extends GSRequest
    {

        public function ListTransactionsRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".ListTransactionsRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : ListTransactionsRequest
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
                    callback(new ListTransactionsResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : ListTransactionsRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setDateFrom(param1:Date) : ListTransactionsRequest
        {
            this.data["dateFrom"] = dateToRFC3339(param1);
            return this;
        }// end function

        public function setDateTo(param1:Date) : ListTransactionsRequest
        {
            this.data["dateTo"] = dateToRFC3339(param1);
            return this;
        }// end function

        public function setEntryCount(param1:Number) : ListTransactionsRequest
        {
            this.data["entryCount"] = param1;
            return this;
        }// end function

        public function setInclude(param1:String) : ListTransactionsRequest
        {
            this.data["include"] = param1;
            return this;
        }// end function

        public function setOffset(param1:Number) : ListTransactionsRequest
        {
            this.data["offset"] = param1;
            return this;
        }// end function

    }
}
