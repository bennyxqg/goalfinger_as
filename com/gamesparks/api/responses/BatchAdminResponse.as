package com.gamesparks.api.responses
{
    import com.gamesparks.*;

    public class BatchAdminResponse extends GSResponse
    {

        public function BatchAdminResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getResponses() : Object
        {
            if (data.responses != null)
            {
                return data.responses;
            }
            return null;
        }// end function

    }
}
