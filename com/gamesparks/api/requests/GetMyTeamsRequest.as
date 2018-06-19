package com.gamesparks.api.requests
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class GetMyTeamsRequest extends GSRequest
    {

        public function GetMyTeamsRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".GetMyTeamsRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : GetMyTeamsRequest
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
                    callback(new GetMyTeamsResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : GetMyTeamsRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setOwnedOnly(param1:Boolean) : GetMyTeamsRequest
        {
            this.data["ownedOnly"] = param1;
            return this;
        }// end function

        public function setTeamTypes(param1:Vector.<String>) : GetMyTeamsRequest
        {
            this.data["teamTypes"] = toArray(param1);
            return this;
        }// end function

    }
}
