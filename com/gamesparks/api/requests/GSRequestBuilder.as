package com.gamesparks.api.requests
{
    import com.gamesparks.*;

    public class GSRequestBuilder extends Object
    {
        private var gs:GS;

        public function GSRequestBuilder(param1:GS)
        {
            this.gs = param1;
            return;
        }// end function

        public function createAcceptChallengeRequest() : AcceptChallengeRequest
        {
            return new AcceptChallengeRequest(this.gs);
        }// end function

        public function createAccountDetailsRequest() : AccountDetailsRequest
        {
            return new AccountDetailsRequest(this.gs);
        }// end function

        public function createAmazonBuyGoodsRequest() : AmazonBuyGoodsRequest
        {
            return new AmazonBuyGoodsRequest(this.gs);
        }// end function

        public function createAmazonConnectRequest() : AmazonConnectRequest
        {
            return new AmazonConnectRequest(this.gs);
        }// end function

        public function createAnalyticsRequest() : AnalyticsRequest
        {
            return new AnalyticsRequest(this.gs);
        }// end function

        public function createAroundMeLeaderboardRequest() : AroundMeLeaderboardRequest
        {
            return new AroundMeLeaderboardRequest(this.gs);
        }// end function

        public function createAuthenticationRequest() : AuthenticationRequest
        {
            return new AuthenticationRequest(this.gs);
        }// end function

        public function createBatchAdminRequest() : BatchAdminRequest
        {
            return new BatchAdminRequest(this.gs);
        }// end function

        public function createBuyVirtualGoodsRequest() : BuyVirtualGoodsRequest
        {
            return new BuyVirtualGoodsRequest(this.gs);
        }// end function

        public function createCancelBulkJobAdminRequest() : CancelBulkJobAdminRequest
        {
            return new CancelBulkJobAdminRequest(this.gs);
        }// end function

        public function createChangeUserDetailsRequest() : ChangeUserDetailsRequest
        {
            return new ChangeUserDetailsRequest(this.gs);
        }// end function

        public function createChatOnChallengeRequest() : ChatOnChallengeRequest
        {
            return new ChatOnChallengeRequest(this.gs);
        }// end function

        public function createConsumeVirtualGoodRequest() : ConsumeVirtualGoodRequest
        {
            return new ConsumeVirtualGoodRequest(this.gs);
        }// end function

        public function createCreateChallengeRequest() : CreateChallengeRequest
        {
            return new CreateChallengeRequest(this.gs);
        }// end function

        public function createCreateTeamRequest() : CreateTeamRequest
        {
            return new CreateTeamRequest(this.gs);
        }// end function

        public function createDeclineChallengeRequest() : DeclineChallengeRequest
        {
            return new DeclineChallengeRequest(this.gs);
        }// end function

        public function createDeviceAuthenticationRequest() : DeviceAuthenticationRequest
        {
            return new DeviceAuthenticationRequest(this.gs);
        }// end function

        public function createDismissMessageRequest() : DismissMessageRequest
        {
            return new DismissMessageRequest(this.gs);
        }// end function

        public function createDismissMultipleMessagesRequest() : DismissMultipleMessagesRequest
        {
            return new DismissMultipleMessagesRequest(this.gs);
        }// end function

        public function createDropTeamRequest() : DropTeamRequest
        {
            return new DropTeamRequest(this.gs);
        }// end function

        public function createEndSessionRequest() : EndSessionRequest
        {
            return new EndSessionRequest(this.gs);
        }// end function

        public function createFacebookConnectRequest() : FacebookConnectRequest
        {
            return new FacebookConnectRequest(this.gs);
        }// end function

        public function createFindChallengeRequest() : FindChallengeRequest
        {
            return new FindChallengeRequest(this.gs);
        }// end function

        public function createFindMatchRequest() : FindMatchRequest
        {
            return new FindMatchRequest(this.gs);
        }// end function

        public function createFindPendingMatchesRequest() : FindPendingMatchesRequest
        {
            return new FindPendingMatchesRequest(this.gs);
        }// end function

        public function createGameCenterConnectRequest() : GameCenterConnectRequest
        {
            return new GameCenterConnectRequest(this.gs);
        }// end function

        public function createGetChallengeRequest() : GetChallengeRequest
        {
            return new GetChallengeRequest(this.gs);
        }// end function

        public function createGetDownloadableRequest() : GetDownloadableRequest
        {
            return new GetDownloadableRequest(this.gs);
        }// end function

        public function createGetLeaderboardEntriesRequest() : GetLeaderboardEntriesRequest
        {
            return new GetLeaderboardEntriesRequest(this.gs);
        }// end function

        public function createGetMessageRequest() : GetMessageRequest
        {
            return new GetMessageRequest(this.gs);
        }// end function

        public function createGetMyTeamsRequest() : GetMyTeamsRequest
        {
            return new GetMyTeamsRequest(this.gs);
        }// end function

        public function createGetPropertyRequest() : GetPropertyRequest
        {
            return new GetPropertyRequest(this.gs);
        }// end function

        public function createGetPropertySetRequest() : GetPropertySetRequest
        {
            return new GetPropertySetRequest(this.gs);
        }// end function

        public function createGetTeamRequest() : GetTeamRequest
        {
            return new GetTeamRequest(this.gs);
        }// end function

        public function createGetUploadUrlRequest() : GetUploadUrlRequest
        {
            return new GetUploadUrlRequest(this.gs);
        }// end function

        public function createGetUploadedRequest() : GetUploadedRequest
        {
            return new GetUploadedRequest(this.gs);
        }// end function

        public function createGooglePlayBuyGoodsRequest() : GooglePlayBuyGoodsRequest
        {
            return new GooglePlayBuyGoodsRequest(this.gs);
        }// end function

        public function createGooglePlayConnectRequest() : GooglePlayConnectRequest
        {
            return new GooglePlayConnectRequest(this.gs);
        }// end function

        public function createGooglePlusConnectRequest() : GooglePlusConnectRequest
        {
            return new GooglePlusConnectRequest(this.gs);
        }// end function

        public function createIOSBuyGoodsRequest() : IOSBuyGoodsRequest
        {
            return new IOSBuyGoodsRequest(this.gs);
        }// end function

        public function createJoinChallengeRequest() : JoinChallengeRequest
        {
            return new JoinChallengeRequest(this.gs);
        }// end function

        public function createJoinPendingMatchRequest() : JoinPendingMatchRequest
        {
            return new JoinPendingMatchRequest(this.gs);
        }// end function

        public function createJoinTeamRequest() : JoinTeamRequest
        {
            return new JoinTeamRequest(this.gs);
        }// end function

        public function createKongregateConnectRequest() : KongregateConnectRequest
        {
            return new KongregateConnectRequest(this.gs);
        }// end function

        public function createLeaderboardDataRequest() : LeaderboardDataRequest
        {
            return new LeaderboardDataRequest(this.gs);
        }// end function

        public function createLeaderboardsEntriesRequest() : LeaderboardsEntriesRequest
        {
            return new LeaderboardsEntriesRequest(this.gs);
        }// end function

        public function createLeaveTeamRequest() : LeaveTeamRequest
        {
            return new LeaveTeamRequest(this.gs);
        }// end function

        public function createListAchievementsRequest() : ListAchievementsRequest
        {
            return new ListAchievementsRequest(this.gs);
        }// end function

        public function createListBulkJobsAdminRequest() : ListBulkJobsAdminRequest
        {
            return new ListBulkJobsAdminRequest(this.gs);
        }// end function

        public function createListChallengeRequest() : ListChallengeRequest
        {
            return new ListChallengeRequest(this.gs);
        }// end function

        public function createListChallengeTypeRequest() : ListChallengeTypeRequest
        {
            return new ListChallengeTypeRequest(this.gs);
        }// end function

        public function createListGameFriendsRequest() : ListGameFriendsRequest
        {
            return new ListGameFriendsRequest(this.gs);
        }// end function

        public function createListInviteFriendsRequest() : ListInviteFriendsRequest
        {
            return new ListInviteFriendsRequest(this.gs);
        }// end function

        public function createListLeaderboardsRequest() : ListLeaderboardsRequest
        {
            return new ListLeaderboardsRequest(this.gs);
        }// end function

        public function createListMessageDetailRequest() : ListMessageDetailRequest
        {
            return new ListMessageDetailRequest(this.gs);
        }// end function

        public function createListMessageRequest() : ListMessageRequest
        {
            return new ListMessageRequest(this.gs);
        }// end function

        public function createListMessageSummaryRequest() : ListMessageSummaryRequest
        {
            return new ListMessageSummaryRequest(this.gs);
        }// end function

        public function createListTeamChatRequest() : ListTeamChatRequest
        {
            return new ListTeamChatRequest(this.gs);
        }// end function

        public function createListTransactionsRequest() : ListTransactionsRequest
        {
            return new ListTransactionsRequest(this.gs);
        }// end function

        public function createListVirtualGoodsRequest() : ListVirtualGoodsRequest
        {
            return new ListVirtualGoodsRequest(this.gs);
        }// end function

        public function createLogChallengeEventRequest() : LogChallengeEventRequest
        {
            return new LogChallengeEventRequest(this.gs);
        }// end function

        public function createLogEventRequest() : LogEventRequest
        {
            return new LogEventRequest(this.gs);
        }// end function

        public function createMatchDetailsRequest() : MatchDetailsRequest
        {
            return new MatchDetailsRequest(this.gs);
        }// end function

        public function createMatchmakingRequest() : MatchmakingRequest
        {
            return new MatchmakingRequest(this.gs);
        }// end function

        public function createPSNConnectRequest() : PSNConnectRequest
        {
            return new PSNConnectRequest(this.gs);
        }// end function

        public function createPsnBuyGoodsRequest() : PsnBuyGoodsRequest
        {
            return new PsnBuyGoodsRequest(this.gs);
        }// end function

        public function createPushRegistrationRequest() : PushRegistrationRequest
        {
            return new PushRegistrationRequest(this.gs);
        }// end function

        public function createQQConnectRequest() : QQConnectRequest
        {
            return new QQConnectRequest(this.gs);
        }// end function

        public function createRegistrationRequest() : RegistrationRequest
        {
            return new RegistrationRequest(this.gs);
        }// end function

        public function createRevokePurchaseGoodsRequest() : RevokePurchaseGoodsRequest
        {
            return new RevokePurchaseGoodsRequest(this.gs);
        }// end function

        public function createScheduleBulkJobAdminRequest() : ScheduleBulkJobAdminRequest
        {
            return new ScheduleBulkJobAdminRequest(this.gs);
        }// end function

        public function createSendFriendMessageRequest() : SendFriendMessageRequest
        {
            return new SendFriendMessageRequest(this.gs);
        }// end function

        public function createSendTeamChatMessageRequest() : SendTeamChatMessageRequest
        {
            return new SendTeamChatMessageRequest(this.gs);
        }// end function

        public function createSocialDisconnectRequest() : SocialDisconnectRequest
        {
            return new SocialDisconnectRequest(this.gs);
        }// end function

        public function createSocialLeaderboardDataRequest() : SocialLeaderboardDataRequest
        {
            return new SocialLeaderboardDataRequest(this.gs);
        }// end function

        public function createSocialStatusRequest() : SocialStatusRequest
        {
            return new SocialStatusRequest(this.gs);
        }// end function

        public function createSteamBuyGoodsRequest() : SteamBuyGoodsRequest
        {
            return new SteamBuyGoodsRequest(this.gs);
        }// end function

        public function createSteamConnectRequest() : SteamConnectRequest
        {
            return new SteamConnectRequest(this.gs);
        }// end function

        public function createTwitchConnectRequest() : TwitchConnectRequest
        {
            return new TwitchConnectRequest(this.gs);
        }// end function

        public function createTwitterConnectRequest() : TwitterConnectRequest
        {
            return new TwitterConnectRequest(this.gs);
        }// end function

        public function createUpdateMessageRequest() : UpdateMessageRequest
        {
            return new UpdateMessageRequest(this.gs);
        }// end function

        public function createViberConnectRequest() : ViberConnectRequest
        {
            return new ViberConnectRequest(this.gs);
        }// end function

        public function createWeChatConnectRequest() : WeChatConnectRequest
        {
            return new WeChatConnectRequest(this.gs);
        }// end function

        public function createWindowsBuyGoodsRequest() : WindowsBuyGoodsRequest
        {
            return new WindowsBuyGoodsRequest(this.gs);
        }// end function

        public function createWithdrawChallengeRequest() : WithdrawChallengeRequest
        {
            return new WithdrawChallengeRequest(this.gs);
        }// end function

        public function createXBOXLiveConnectRequest() : XBOXLiveConnectRequest
        {
            return new XBOXLiveConnectRequest(this.gs);
        }// end function

        public function createXboxOneConnectRequest() : XboxOneConnectRequest
        {
            return new XboxOneConnectRequest(this.gs);
        }// end function

    }
}
