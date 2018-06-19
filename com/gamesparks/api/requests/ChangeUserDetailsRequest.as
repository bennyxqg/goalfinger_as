package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class ChangeUserDetailsRequest extends GSRequest
    {

        public function ChangeUserDetailsRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".ChangeUserDetailsRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : ChangeUserDetailsRequest
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
                    callback(new ChangeUserDetailsResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : ChangeUserDetailsRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setDisplayName(param1:String) : ChangeUserDetailsRequest
        {
            this.data["displayName"] = param1;
            return this;
        }// end function

        public function setLanguage(param1:String) : ChangeUserDetailsRequest
        {
            this.data["language"] = param1;
            return this;
        }// end function

        public function setNewPassword(param1:String) : ChangeUserDetailsRequest
        {
            this.data["newPassword"] = param1;
            return this;
        }// end function

        public function setOldPassword(param1:String) : ChangeUserDetailsRequest
        {
            this.data["oldPassword"] = param1;
            return this;
        }// end function

        public function setUserName(param1:String) : ChangeUserDetailsRequest
        {
            this.data["userName"] = param1;
            return this;
        }// end function

    }
}
