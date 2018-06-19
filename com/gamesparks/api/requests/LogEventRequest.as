package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class LogEventRequest extends GSRequest
    {

        public function LogEventRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".LogEventRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : LogEventRequest
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
                    callback(new LogEventResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setNumberEventAttribute(param1:String, param2:Number) : LogEventRequest
        {
            this.data[param1] = param2;
            return this;
        }// end function

        public function setStringEventAttribute(param1:String, param2:String) : LogEventRequest
        {
            this.data[param1] = param2;
            return this;
        }// end function

        public function setJSONEventAttribute(param1:String, param2:Object) : LogEventRequest
        {
            this.data[param1] = param2;
            return this;
        }// end function

        public function setEventKey(param1:String) : LogEventRequest
        {
            this.data["eventKey"] = param1;
            return this;
        }// end function

    }
}
