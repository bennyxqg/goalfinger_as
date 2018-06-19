package com.gamesparks.api.types
{
    import com.gamesparks.*;

    public class ChatMessage extends GSData
    {

        public function ChatMessage(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getFromId() : String
        {
            if (data.fromId != null)
            {
                return data.fromId;
            }
            return null;
        }// end function

        public function getId() : String
        {
            if (data.id != null)
            {
                return data.id;
            }
            return null;
        }// end function

        public function getMessage() : String
        {
            if (data.message != null)
            {
                return data.message;
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

        public function getWho() : String
        {
            if (data.who != null)
            {
                return data.who;
            }
            return null;
        }// end function

    }
}
