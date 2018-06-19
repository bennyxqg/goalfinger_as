package com.gamesparks.api.responses
{
    import com.gamesparks.*;

    public class GetMessageResponse extends GSResponse
    {

        public function GetMessageResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getMessage() : Object
        {
            if (data.message != null)
            {
                return data.message;
            }
            return null;
        }// end function

        public function getStatus() : String
        {
            if (data.status != null)
            {
                return data.status;
            }
            return null;
        }// end function

    }
}
