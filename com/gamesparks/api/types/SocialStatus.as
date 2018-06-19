package com.gamesparks.api.types
{
    import com.gamesparks.*;

    public class SocialStatus extends GSData
    {

        public function SocialStatus(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getActive() : Boolean
        {
            if (data.active != null)
            {
                return data.active;
            }
            return false;
        }// end function

        public function getExpires() : Date
        {
            if (data.expires != null)
            {
                return RFC3339toDate(data.expires);
            }
            return null;
        }// end function

        public function getSystemId() : String
        {
            if (data.systemId != null)
            {
                return data.systemId;
            }
            return null;
        }// end function

    }
}
