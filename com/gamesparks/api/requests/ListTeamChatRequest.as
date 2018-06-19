package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class ListTeamChatRequest extends GSRequest
    {

        public function ListTeamChatRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".ListTeamChatRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : ListTeamChatRequest
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
                    callback(new ListTeamChatResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : ListTeamChatRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setEntryCount(param1:Number) : ListTeamChatRequest
        {
            this.data["entryCount"] = param1;
            return this;
        }// end function

        public function setOffset(param1:Number) : ListTeamChatRequest
        {
            this.data["offset"] = param1;
            return this;
        }// end function

        public function setOwnerId(param1:String) : ListTeamChatRequest
        {
            this.data["ownerId"] = param1;
            return this;
        }// end function

        public function setTeamId(param1:String) : ListTeamChatRequest
        {
            this.data["teamId"] = param1;
            return this;
        }// end function

        public function setTeamType(param1:String) : ListTeamChatRequest
        {
            this.data["teamType"] = param1;
            return this;
        }// end function

    }
}
