package com.gamesparks.api.responses
{
    import com.gamesparks.*;

    public class PushRegistrationResponse extends GSResponse
    {

        public function PushRegistrationResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getRegistrationId() : String
        {
            if (data.registrationId != null)
            {
                return data.registrationId;
            }
            return null;
        }// end function

    }
}
