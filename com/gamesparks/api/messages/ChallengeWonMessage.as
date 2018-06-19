package com.gamesparks.api.messages
{
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class ChallengeWonMessage extends GSResponse
    {
        public static var MESSAGE_TYPE:String = ".ChallengeWonMessage";

        public function ChallengeWonMessage(param1:Object)
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

        public function getCurrency1Won() : Number
        {
            if (data.currency1Won != null)
            {
                return data.currency1Won;
            }
            return NaN;
        }// end function

        public function getCurrency2Won() : Number
        {
            if (data.currency2Won != null)
            {
                return data.currency2Won;
            }
            return NaN;
        }// end function

        public function getCurrency3Won() : Number
        {
            if (data.currency3Won != null)
            {
                return data.currency3Won;
            }
            return NaN;
        }// end function

        public function getCurrency4Won() : Number
        {
            if (data.currency4Won != null)
            {
                return data.currency4Won;
            }
            return NaN;
        }// end function

        public function getCurrency5Won() : Number
        {
            if (data.currency5Won != null)
            {
                return data.currency5Won;
            }
            return NaN;
        }// end function

        public function getCurrency6Won() : Number
        {
            if (data.currency6Won != null)
            {
                return data.currency6Won;
            }
            return NaN;
        }// end function

        public function getLeaderboardData() : LeaderboardData
        {
            if (data.leaderboardData != null)
            {
                return new LeaderboardData(data.leaderboardData);
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

        public function getWinnerName() : String
        {
            if (data.winnerName != null)
            {
                return data.winnerName;
            }
            return null;
        }// end function

    }
}
