package com.gamesparks.api.messages
{
    import com.gamesparks.*;

    public class AchievementEarnedMessage extends GSResponse
    {
        public static var MESSAGE_TYPE:String = ".AchievementEarnedMessage";

        public function AchievementEarnedMessage(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getAchievementName() : String
        {
            if (data.achievementName != null)
            {
                return data.achievementName;
            }
            return null;
        }// end function

        public function getAchievementShortCode() : String
        {
            if (data.achievementShortCode != null)
            {
                return data.achievementShortCode;
            }
            return null;
        }// end function

        public function getCurrency1Earned() : String
        {
            if (data.currency1Earned != null)
            {
                return data.currency1Earned;
            }
            return null;
        }// end function

        public function getCurrency2Earned() : String
        {
            if (data.currency2Earned != null)
            {
                return data.currency2Earned;
            }
            return null;
        }// end function

        public function getCurrency3Earned() : String
        {
            if (data.currency3Earned != null)
            {
                return data.currency3Earned;
            }
            return null;
        }// end function

        public function getCurrency4Earned() : String
        {
            if (data.currency4Earned != null)
            {
                return data.currency4Earned;
            }
            return null;
        }// end function

        public function getCurrency5Earned() : String
        {
            if (data.currency5Earned != null)
            {
                return data.currency5Earned;
            }
            return null;
        }// end function

        public function getCurrency6Earned() : String
        {
            if (data.currency6Earned != null)
            {
                return data.currency6Earned;
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

        public function getVirtualGoodEarned() : String
        {
            if (data.virtualGoodEarned != null)
            {
                return data.virtualGoodEarned;
            }
            return null;
        }// end function

    }
}
