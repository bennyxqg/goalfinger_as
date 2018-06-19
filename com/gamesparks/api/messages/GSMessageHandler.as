package com.gamesparks.api.messages
{
    import flash.utils.*;

    public class GSMessageHandler extends Object
    {
        private var callbacks:Dictionary;

        public function GSMessageHandler()
        {
            this.callbacks = new Dictionary();
            return;
        }// end function

        public function setAchievementEarnedMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".AchievementEarnedMessage"] = param1;
            return this;
        }// end function

        public function setChallengeAcceptedMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".ChallengeAcceptedMessage"] = param1;
            return this;
        }// end function

        public function setChallengeChangedMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".ChallengeChangedMessage"] = param1;
            return this;
        }// end function

        public function setChallengeChatMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".ChallengeChatMessage"] = param1;
            return this;
        }// end function

        public function setChallengeDeclinedMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".ChallengeDeclinedMessage"] = param1;
            return this;
        }// end function

        public function setChallengeDrawnMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".ChallengeDrawnMessage"] = param1;
            return this;
        }// end function

        public function setChallengeExpiredMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".ChallengeExpiredMessage"] = param1;
            return this;
        }// end function

        public function setChallengeIssuedMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".ChallengeIssuedMessage"] = param1;
            return this;
        }// end function

        public function setChallengeJoinedMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".ChallengeJoinedMessage"] = param1;
            return this;
        }// end function

        public function setChallengeLapsedMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".ChallengeLapsedMessage"] = param1;
            return this;
        }// end function

        public function setChallengeLostMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".ChallengeLostMessage"] = param1;
            return this;
        }// end function

        public function setChallengeStartedMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".ChallengeStartedMessage"] = param1;
            return this;
        }// end function

        public function setChallengeTurnTakenMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".ChallengeTurnTakenMessage"] = param1;
            return this;
        }// end function

        public function setChallengeWaitingMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".ChallengeWaitingMessage"] = param1;
            return this;
        }// end function

        public function setChallengeWithdrawnMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".ChallengeWithdrawnMessage"] = param1;
            return this;
        }// end function

        public function setChallengeWonMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".ChallengeWonMessage"] = param1;
            return this;
        }// end function

        public function setFriendMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".FriendMessage"] = param1;
            return this;
        }// end function

        public function setGlobalRankChangedMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".GlobalRankChangedMessage"] = param1;
            return this;
        }// end function

        public function setMatchFoundMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".MatchFoundMessage"] = param1;
            return this;
        }// end function

        public function setMatchNotFoundMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".MatchNotFoundMessage"] = param1;
            return this;
        }// end function

        public function setMatchUpdatedMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".MatchUpdatedMessage"] = param1;
            return this;
        }// end function

        public function setNewHighScoreMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".NewHighScoreMessage"] = param1;
            return this;
        }// end function

        public function setNewTeamScoreMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".NewTeamScoreMessage"] = param1;
            return this;
        }// end function

        public function setScriptMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".ScriptMessage"] = param1;
            return this;
        }// end function

        public function setSessionTerminatedMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".SessionTerminatedMessage"] = param1;
            return this;
        }// end function

        public function setSocialRankChangedMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".SocialRankChangedMessage"] = param1;
            return this;
        }// end function

        public function setTeamChatMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".TeamChatMessage"] = param1;
            return this;
        }// end function

        public function setTeamRankChangedMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".TeamRankChangedMessage"] = param1;
            return this;
        }// end function

        public function setUploadCompleteMessageHandler(param1:Function) : GSMessageHandler
        {
            this.callbacks[".UploadCompleteMessage"] = param1;
            return this;
        }// end function

        public function setHandler(param1:String, param2:Function) : GSMessageHandler
        {
            this.callbacks[param1] = param2;
            return this;
        }// end function

        public function handle(param1:Object) : void
        {
            var _loc_2:* = param1["@class"];
            if (_loc_2 == null || this.callbacks[_loc_2] == null)
            {
                return;
            }
            switch(_loc_2)
            {
                case ".AchievementEarnedMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new AchievementEarnedMessage(param1));
                    break;
                }
                case ".ChallengeAcceptedMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new ChallengeAcceptedMessage(param1));
                    break;
                }
                case ".ChallengeChangedMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new ChallengeChangedMessage(param1));
                    break;
                }
                case ".ChallengeChatMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new ChallengeChatMessage(param1));
                    break;
                }
                case ".ChallengeDeclinedMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new ChallengeDeclinedMessage(param1));
                    break;
                }
                case ".ChallengeDrawnMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new ChallengeDrawnMessage(param1));
                    break;
                }
                case ".ChallengeExpiredMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new ChallengeExpiredMessage(param1));
                    break;
                }
                case ".ChallengeIssuedMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new ChallengeIssuedMessage(param1));
                    break;
                }
                case ".ChallengeJoinedMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new ChallengeJoinedMessage(param1));
                    break;
                }
                case ".ChallengeLapsedMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new ChallengeLapsedMessage(param1));
                    break;
                }
                case ".ChallengeLostMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new ChallengeLostMessage(param1));
                    break;
                }
                case ".ChallengeStartedMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new ChallengeStartedMessage(param1));
                    break;
                }
                case ".ChallengeTurnTakenMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new ChallengeTurnTakenMessage(param1));
                    break;
                }
                case ".ChallengeWaitingMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new ChallengeWaitingMessage(param1));
                    break;
                }
                case ".ChallengeWithdrawnMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new ChallengeWithdrawnMessage(param1));
                    break;
                }
                case ".ChallengeWonMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new ChallengeWonMessage(param1));
                    break;
                }
                case ".FriendMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new FriendMessage(param1));
                    break;
                }
                case ".GlobalRankChangedMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new GlobalRankChangedMessage(param1));
                    break;
                }
                case ".MatchFoundMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new MatchFoundMessage(param1));
                    break;
                }
                case ".MatchNotFoundMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new MatchNotFoundMessage(param1));
                    break;
                }
                case ".MatchUpdatedMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new MatchUpdatedMessage(param1));
                    break;
                }
                case ".NewHighScoreMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new NewHighScoreMessage(param1));
                    break;
                }
                case ".NewTeamScoreMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new NewTeamScoreMessage(param1));
                    break;
                }
                case ".ScriptMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new ScriptMessage(param1));
                    break;
                }
                case ".SessionTerminatedMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new SessionTerminatedMessage(param1));
                    break;
                }
                case ".SocialRankChangedMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new SocialRankChangedMessage(param1));
                    break;
                }
                case ".TeamChatMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new TeamChatMessage(param1));
                    break;
                }
                case ".TeamRankChangedMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new TeamRankChangedMessage(param1));
                    break;
                }
                case ".UploadCompleteMessage":
                {
                    var _loc_3:* = this.callbacks;
                    _loc_3[_loc_2](new UploadCompleteMessage(param1));
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

    }
}
