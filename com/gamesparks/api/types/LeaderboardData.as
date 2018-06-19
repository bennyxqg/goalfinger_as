package com.gamesparks.api.types
{
    import com.gamesparks.*;

    public class LeaderboardData extends GSData
    {

        public function LeaderboardData(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getCity() : String
        {
            if (data.city != null)
            {
                return data.city;
            }
            return null;
        }// end function

        public function getCountry() : String
        {
            if (data.country != null)
            {
                return data.country;
            }
            return null;
        }// end function

        public function getExternalIds() : Object
        {
            if (data.externalIds != null)
            {
                return data.externalIds;
            }
            return null;
        }// end function

        public function getRank() : Number
        {
            if (data.rank != null)
            {
                return data.rank;
            }
            return NaN;
        }// end function

        public function getUserId() : String
        {
            if (data.userId != null)
            {
                return data.userId;
            }
            return null;
        }// end function

        public function getUserName() : String
        {
            if (data.userName != null)
            {
                return data.userName;
            }
            return null;
        }// end function

        public function getWhen() : String
        {
            if (data.when != null)
            {
                return data.when;
            }
            return null;
        }// end function

    }
}
