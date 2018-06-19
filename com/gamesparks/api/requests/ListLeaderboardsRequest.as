package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class ListLeaderboardsRequest extends GSRequest
    {

        public function ListLeaderboardsRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".ListLeaderboardsRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : ListLeaderboardsRequest
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
                    callback(new ListLeaderboardsResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : ListLeaderboardsRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

    }
}
