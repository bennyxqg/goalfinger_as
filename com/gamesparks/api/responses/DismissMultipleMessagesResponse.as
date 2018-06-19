package com.gamesparks.api.responses
{
    import __AS3__.vec.*;
    import com.gamesparks.*;

    public class DismissMultipleMessagesResponse extends GSResponse
    {

        public function DismissMultipleMessagesResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getFailedDismissals() : Vector.<String>
        {
            if (data.failedDismissals != null)
            {
                return data.failedDismissals;
            }
            return null;
        }// end function

        public function getMessagesDismissed() : Number
        {
            if (data.messagesDismissed != null)
            {
                return data.messagesDismissed;
            }
            return NaN;
        }// end function

    }
}
