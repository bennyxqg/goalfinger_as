package com.gamesparks.api.messages
{
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class ChallengeJoinedMessage extends GSResponse
    {
        public static var MESSAGE_TYPE:String = ".ChallengeJoinedMessage";

        public function ChallengeJoinedMessage(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getChallenge() : Challenge
        {
            if (data.challenge != null)
            {
                return new Challenge(data.challenge);
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
