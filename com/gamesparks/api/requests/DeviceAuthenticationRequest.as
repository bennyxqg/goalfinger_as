package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class DeviceAuthenticationRequest extends GSRequest
    {

        public function DeviceAuthenticationRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".DeviceAuthenticationRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : DeviceAuthenticationRequest
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
                    callback(new AuthenticationResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : DeviceAuthenticationRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setDeviceId(param1:String) : DeviceAuthenticationRequest
        {
            this.data["deviceId"] = param1;
            return this;
        }// end function

        public function setDeviceModel(param1:String) : DeviceAuthenticationRequest
        {
            this.data["deviceModel"] = param1;
            return this;
        }// end function

        public function setDeviceName(param1:String) : DeviceAuthenticationRequest
        {
            this.data["deviceName"] = param1;
            return this;
        }// end function

        public function setDeviceOS(param1:String) : DeviceAuthenticationRequest
        {
            this.data["deviceOS"] = param1;
            return this;
        }// end function

        public function setDeviceType(param1:String) : DeviceAuthenticationRequest
        {
            this.data["deviceType"] = param1;
            return this;
        }// end function

        public function setDisplayName(param1:String) : DeviceAuthenticationRequest
        {
            this.data["displayName"] = param1;
            return this;
        }// end function

        public function setOperatingSystem(param1:String) : DeviceAuthenticationRequest
        {
            this.data["operatingSystem"] = param1;
            return this;
        }// end function

        public function setSegments(param1:Object) : DeviceAuthenticationRequest
        {
            this.data["segments"] = param1;
            return this;
        }// end function

    }
}
