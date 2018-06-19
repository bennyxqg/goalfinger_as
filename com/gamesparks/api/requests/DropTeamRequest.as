package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class DropTeamRequest extends GSRequest
    {

        public function DropTeamRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".DropTeamRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : DropTeamRequest
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
                    callback(new DropTeamResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : DropTeamRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setOwnerId(param1:String) : DropTeamRequest
        {
            this.data["ownerId"] = param1;
            return this;
        }// end function

        public function setTeamId(param1:String) : DropTeamRequest
        {
            this.data["teamId"] = param1;
            return this;
        }// end function

        public function setTeamType(param1:String) : DropTeamRequest
        {
            this.data["teamType"] = param1;
            return this;
        }// end function

    }
}
