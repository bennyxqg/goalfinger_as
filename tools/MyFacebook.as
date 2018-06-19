package tools
{
    import com.milkmangames.nativeextensions.*;
    import com.milkmangames.nativeextensions.events.*;
    import flash.events.*;

    public class MyFacebook extends Object
    {
        private var vLoginCallback:Function;
        private static var vInitViralDone:Boolean = false;

        public function MyFacebook()
        {
            return;
        }// end function

        public function getNewLogin(param1:Function) : void
        {
            Global.addLogTrace("getNewLogin0", "MyFacebook");
            if (!this.initGoViral())
            {
                Global.addLogTrace("Can\'t connect to goviral at getNewLogin !", "MyFacebook");
                return;
            }
            Global.addLogTrace("getNewLogin1", "MyFacebook");
            if (GoViral.goViral.isFacebookSupported())
            {
                Global.addLogTrace("getNewLogin2", "MyFacebook");
                GoViral.goViral.logoutFacebook();
                Global.addLogTrace("getNewLogin3", "MyFacebook");
                this.getLogin(param1);
            }
            Global.addLogTrace("getNewLoginDone", "MyFacebook");
            return;
        }// end function

        public function getLogin(param1:Function) : void
        {
            var _loc_2:* = null;
            Global.addLogTrace("getLogin", "MyFacebook");
            this.vLoginCallback = param1;
            if (Global.vDev)
            {
            }
            if (!this.initGoViral())
            {
                this.vLoginCallback.call(0, "Fail initGoViral");
                return;
            }
            if (GoViral.goViral.isFacebookSupported())
            {
                GoViral.goViral.removeEventListener(GVFacebookEvent.FB_LOGGED_IN, this.onFacebookEvent);
                GoViral.goViral.removeEventListener(GVFacebookEvent.FB_LOGGED_OUT, this.onFacebookEvent);
                GoViral.goViral.removeEventListener(GVFacebookEvent.FB_LOGIN_CANCELED, this.onFacebookEvent);
                GoViral.goViral.removeEventListener(GVFacebookEvent.FB_LOGIN_FAILED, this.onFacebookEvent);
                GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGGED_IN, this.onFacebookEvent);
                GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGGED_OUT, this.onFacebookEvent);
                GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGIN_CANCELED, this.onFacebookEvent);
                GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGIN_FAILED, this.onFacebookEvent);
                GoViral.goViral.initFacebook("1680513265566386", "");
                if (GoViral.goViral.isFacebookAuthenticated())
                {
                    Global.addLogTrace("goViral.isFacebookAuthenticated()=true", "MyFacebook");
                    _loc_2 = GoViral.goViral.getFbAccessToken();
                    Global.addLogTrace("GoViral.goViral.getFbAccessToken()=" + _loc_2, "MyFacebook");
                    if (_loc_2 != null && _loc_2 != "")
                    {
                        this.vLoginCallback.call(0, "token:" + _loc_2);
                    }
                    else
                    {
                        GoViral.goViral.authenticateWithFacebook("public_profile,user_friends");
                    }
                }
                else
                {
                    Global.addLogTrace("goViral.authenticateWithFacebook", "MyFacebook");
                    Global.vRoot.vKillOnDeactivate = false;
                    GoViral.goViral.authenticateWithFacebook("public_profile,user_friends");
                }
            }
            else
            {
                this.vLoginCallback.call(0, "Facebook not supported");
            }
            return;
        }// end function

        private function onFacebookEvent(event:Event) : void
        {
            Global.addLogTrace("onFacebookEvent e=" + event, "MyFacebook");
            Global.vRoot.vKillOnDeactivate = true;
            if (event.type == GVFacebookEvent.FB_LOGGED_IN)
            {
                this.vLoginCallback.call(0, "token:" + GoViral.goViral.getFbAccessToken());
            }
            else
            {
                this.vLoginCallback.call(0, event.type);
            }
            return;
        }// end function

        private function initGoViral() : Boolean
        {
            if (GoViral.isSupported())
            {
                if (vInitViralDone)
                {
                    return true;
                }
                GoViral.create();
                vInitViralDone = true;
            }
            else
            {
                return false;
            }
            return true;
        }// end function

    }
}
