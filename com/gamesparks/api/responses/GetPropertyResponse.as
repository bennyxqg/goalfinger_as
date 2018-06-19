package com.gamesparks.api.responses
{
    import com.gamesparks.*;

    public class GetPropertyResponse extends GSResponse
    {

        public function GetPropertyResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getProperty() : Object
        {
            if (data.property != null)
            {
                return data.property;
            }
            return null;
        }// end function

    }
}
