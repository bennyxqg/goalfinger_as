package com.gamesparks.api.messages
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class MatchNotFoundMessage extends GSResponse
    {
        public static var MESSAGE_TYPE:String = ".MatchNotFoundMessage";

        public function MatchNotFoundMessage(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getMatchData() : Object
        {
            if (data.matchData != null)
            {
                return data.matchData;
            }
            return null;
        }// end function

        public function getMatchGroup() : String
        {
            if (data.matchGroup != null)
            {
                return data.matchGroup;
            }
            return null;
        }// end function

        public function getMatchShortCode() : String
        {
            if (data.matchShortCode != null)
            {
                return data.matchShortCode;
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

        public function getParticipantData() : Object
        {
            if (data.participantData != null)
            {
                return data.participantData;
            }
            return null;
        }// end function

        public function getParticipants() : Vector.<Participant>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<Participant>;
            if (data.participants != null)
            {
                _loc_2 = data.participants;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new Participant(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
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

    }
}
