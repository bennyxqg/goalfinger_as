package com.gamesparks.api.messages
{
    import com.gamesparks.*;

    public class FriendMessage extends GSResponse
    {
        public static var MESSAGE_TYPE:String = ".FriendMessage";

        public function FriendMessage(param1:Object)
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

        public function getMessage() : String
        {
            if (data.message != null)
            {
                return data.message;
            }
            return null;
        }// end function

        public function getMessageId() : String
        {
            if (data.messageId != null)
            {
                return data.messageId;
            }
            return null;
        }// end function

        public function getNotification() : Boolean
        {
            if (data.notification != null)
            {
                return data.notification;
            }
            return false;
        }// end function

        public function getSubTitle() : String
        {
            if (data.subTitle != null)
            {
                return data.subTitle;
            }
            return null;
        }// end function

        public function getSummary() : String
        {
            if (data.summary != null)
            {
                return data.summary;
            }
            return null;
        }// end function

        public function getTitle() : String
        {
            if (data.title != null)
            {
                return data.title;
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
