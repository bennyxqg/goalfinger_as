package com.gamesparks.api.requests
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class ListBulkJobsAdminRequest extends GSRequest
    {

        public function ListBulkJobsAdminRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".ListBulkJobsAdminRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : ListBulkJobsAdminRequest
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
                    callback(new ListBulkJobsAdminResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : ListBulkJobsAdminRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setBulkJobIds(param1:Vector.<String>) : ListBulkJobsAdminRequest
        {
            this.data["bulkJobIds"] = toArray(param1);
            return this;
        }// end function

    }
}
