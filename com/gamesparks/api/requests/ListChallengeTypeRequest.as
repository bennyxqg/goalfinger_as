package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class ListChallengeTypeRequest extends GSRequest
    {

        public function ListChallengeTypeRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".ListChallengeTypeRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : ListChallengeTypeRequest
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
                    callback(new ListChallengeTypeResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : ListChallengeTypeRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

    }
}
