package menu.screens
{
    import flash.events.*;
    import flash.text.*;
    import globz.*;
    import menu.*;
    import tools.*;

    public class LoadingGlobe extends MenuXXX
    {
        private var vTextInvite:TextField;

        public function LoadingGlobe()
        {
            vTag = "LoadingGlobe";
            return;
        }// end function

        override protected function init() : void
        {
            var _loc_1:* = null;
            var _loc_3:* = null;
            _loc_1 = new BG_Textured();
            _loc_1.x = Global.vSize.x / 2;
            _loc_1.y = Global.vSize.y / 2;
            addChild(_loc_1);
            var _loc_2:* = new SphereMap(new earth360(), new earth2d(), 4.8, new sprites360(), 0.5);
            _loc_2.x = Global.vSize.x / 2;
            _loc_2.y = Global.vSize.y * 0.42;
            addChild(_loc_2);
            Global.adjustPos(_loc_2, 0, -0.5);
            _loc_3 = new Logo_GoalFinger();
            var _loc_6:* = 2;
            _loc_3.scaleY = 2;
            _loc_3.scaleX = _loc_6;
            _loc_3.x = Global.vSize.x / 2;
            _loc_3.y = Global.vSize.y * 0.8;
            addChild(_loc_3);
            Global.adjustPos(_loc_3, 0, 0.5);
            var _loc_4:* = new Logo_Credits();
            _loc_4.x = Global.vSize.x / 2;
            _loc_4.y = Global.vSize.y - 52;
            addChild(_loc_4);
            Global.adjustPos(_loc_4, 0, 1);
            var _loc_5:* = new Logo_Invite();
            _loc_5.txtInvite.htmlText = "<b>" + Global.getText("txtLoadingInvite") + "<br>" + Global.getText("txtLoadingConnection") + "</b>";
            Global.vLang.checkSans(_loc_5.txtInvite);
            Toolz.textReduce(_loc_5.txtInvite);
            addChild(_loc_5);
            Global.adjustPos(_loc_5, -1, -1);
            this.vTextInvite = _loc_5.txtInvite;
            Global.vLoadingGlobe = this;
            return;
        }// end function

        public function showInitStep(param1:int) : void
        {
            Global.addLogTrace("showInitStep " + param1, vTag);
            this.vTextInvite.htmlText = "<B>" + Global.getText("txtInitStep" + param1) + "</B>";
            Global.vLang.checkSans(this.vTextInvite);
            Toolz.textReduce(this.vTextInvite);
            return;
        }// end function

        private function showTrace(event:Event) : void
        {
            if (Global.vClientTrace == null)
            {
                Global.vClientTrace = new MyLogTrace();
            }
            else
            {
                Global.vClientTrace.toggle();
            }
            return;
        }// end function

    }
}
