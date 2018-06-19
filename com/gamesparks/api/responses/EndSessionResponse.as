package com.gamesparks.api.responses
{
    import com.gamesparks.*;

    public class EndSessionResponse extends GSResponse
    {

        public function EndSessionResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getSessionDuration() : Number
        {
            if (data.sessionDuration != null)
            {
                return data.sessionDuration;
            }
            return NaN;
        }// end function

    }
}
