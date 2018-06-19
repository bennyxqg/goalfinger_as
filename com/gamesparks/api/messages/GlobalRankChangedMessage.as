package com.gamesparks.api.messages
{
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class GlobalRankChangedMessage extends GSResponse
    {
        public static var MESSAGE_TYPE:String = ".GlobalRankChangedMessage";

        public function GlobalRankChangedMessage(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getGameId() : Number
        {
            if (data.gameId != null)
            {
                return data.gameId;
            }
            return NaN;
        }// end function

        public function getLeaderboardName() : String
        {
            if (data.leaderboardName != null)
            {
                return data.leaderboardName;
            }
            return null;
        }// end function

        public function getLeaderboardShortCode() : String
        {
            if (data.leaderboardShortCode != null)
            {
                return data.leaderboardShortCode;
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

        public function getThem() : LeaderboardData
        {
            if (data.them != null)
            {
                return new LeaderboardData(data.them);
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

        public function getYou() : LeaderboardData
        {
            if (data.you != null)
            {
                return new LeaderboardData(data.you);
            }
            return null;
        }// end function

    }
}
