package com.gamesparks.api.messages
{
    import com.gamesparks.*;

    public class TeamChatMessage extends GSResponse
    {
        public static var MESSAGE_TYPE:String = ".TeamChatMessage";

        public function TeamChatMessage(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getChatMessageId() : String
        {
            if (data.chatMessageId != null)
            {
                return data.chatMessageId;
            }
            return null;
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

        public function getOwnerId() : String
        {
            if (data.ownerId != null)
            {
                return data.ownerId;
            }
            return null;
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

        public function getTeamId() : String
        {
            if (data.teamId != null)
            {
                return data.teamId;
            }
            return null;
        }// end function

        public function getTeamType() : String
        {
            if (data.teamType != null)
            {
                return data.teamType;
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
