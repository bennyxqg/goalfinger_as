package com.gamesparks.api.responses
{
    import com.gamesparks.*;

    public class GetPropertySetResponse extends GSResponse
    {

        public function GetPropertySetResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getPropertySet() : Object
        {
            if (data.propertySet != null)
            {
                return data.propertySet;
            }
            return null;
        }// end function

    }
}
