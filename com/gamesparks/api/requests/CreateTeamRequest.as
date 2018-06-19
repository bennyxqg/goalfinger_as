package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class CreateTeamRequest extends GSRequest
    {

        public function CreateTeamRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".CreateTeamRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : CreateTeamRequest
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
                    callback(new CreateTeamResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : CreateTeamRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setTeamId(param1:String) : CreateTeamRequest
        {
            this.data["teamId"] = param1;
            return this;
        }// end function

        public function setTeamName(param1:String) : CreateTeamRequest
        {
            this.data["teamName"] = param1;
            return this;
        }// end function

        public function setTeamType(param1:String) : CreateTeamRequest
        {
            this.data["teamType"] = param1;
            return this;
        }// end function

    }
}
