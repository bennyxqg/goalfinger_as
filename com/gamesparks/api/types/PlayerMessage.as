package com.gamesparks.api.types
{
    import com.gamesparks.*;

    public class PlayerMessage extends GSData
    {

        public function PlayerMessage(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getId() : String
        {
            if (data.id != null)
            {
                return data.id;
            }
            return null;
        }// end function

        public function getMessage() : Object
        {
            if (data.message != null)
            {
                return data.message;
            }
            return null;
        }// end function

        public function getSeen() : Boolean
        {
            if (data.seen != null)
            {
                return data.seen;
            }
            return false;
        }// end function

        public function getStatus() : String
        {
            if (data.status != null)
            {
                return data.status;
            }
            return null;
        }// end function

        public function getWhen() : Date
        {
            if (data.when != null)
            {
                return RFC3339toDate(data.when);
            }
            return null;
        }// end function

    }
}
