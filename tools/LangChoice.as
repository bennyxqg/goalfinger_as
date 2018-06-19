package tools
{
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    import flash.text.*;

    public class LangChoice extends Sprite
    {
        private var vLabels:Array;
        private var vMain:MyCboListItem;
        private var vSpace:int = 50;
        private var vChoice:MyCboListItem;
        private var vStarted:Boolean = false;

        public function LangChoice()
        {
            this.vLabels = [{label:"English", lang:"en", sans:false}, {label:"Français", lang:"fr", sans:false}, {label:"Deutsch", lang:"de", sans:false}, {label:"Español", lang:"es", sans:false}, {label:"Italiano", lang:"it", sans:false}, {label:"Русский", lang:"ru", sans:true}, {label:"Português", lang:"pt", sans:false}, {label:"中文", lang:"zh", sans:true}, {label:"日本語", lang:"ja", sans:true}, {label:"한국어", lang:"ko", sans:true}];
            this.vMain = new MyCboListItem();
            this.vMain.gotoAndStop(2);
            addChild(this.vMain);
            this.setLabel(this.vMain, this.getCurLabel());
            if (Capabilities.isDebugger)
            {
                addEventListener(MouseEvent.MOUSE_DOWN, this.onStart);
            }
            else
            {
                addEventListener(TouchEvent.TOUCH_BEGIN, this.onStart);
            }
            return;
        }// end function

        private function getCurLabel() : Object
        {
            var _loc_1:* = 0;
            while (_loc_1 < this.vLabels.length)
            {
                
                if (this.vLabels[_loc_1].lang == Global.vLang.vCur)
                {
                    return this.vLabels[_loc_1];
                }
                _loc_1++;
            }
            return this.vLabels[0];
        }// end function

        private function setLabel(param1:MyCboListItem, param2:Object) : void
        {
            var _loc_3:* = null;
            if (param2.sans)
            {
                _loc_3 = new TextFormat();
                _loc_3.font = "_sans";
                param1.txtLabel.embedFonts = false;
                param1.txtLabel.defaultTextFormat = _loc_3;
                param1.txtLabel.htmlText = "<FONT FACE=\"_sans\">" + param2.label + "</FONT>";
            }
            else
            {
                param1.txtLabel.htmlText = param2.label;
            }
            param1.txtLabel.mouseEnabled = false;
            return;
        }// end function

        private function labelToLang(param1:String) : String
        {
            var _loc_2:* = 0;
            while (_loc_2 < this.vLabels[_loc_2])
            {
                
                if (this.vLabels[_loc_2].label == param1)
                {
                    return this.vLabels[_loc_2].lang;
                }
                _loc_2++;
            }
            return this.vLabels[0].lang;
        }// end function

        private function onStart(event:Event) : void
        {
            var _loc_3:* = null;
            if (this.vStarted)
            {
                this.cancelLang();
                return;
            }
            Global.vSound.onButton();
            var _loc_2:* = 0;
            var _loc_4:* = 0;
            while (_loc_4 < this.vLabels.length)
            {
                
                if (this.vLabels[_loc_4].lang != Global.vLang.vCur)
                {
                    _loc_3 = new MyCboListItem();
                    _loc_2 = _loc_2 + this.vSpace;
                    _loc_3.y = _loc_2;
                    _loc_3.lang = this.vLabels[_loc_4].lang;
                    addChild(_loc_3);
                    this.setLabel(_loc_3, this.vLabels[_loc_4]);
                    if (Capabilities.isDebugger)
                    {
                        _loc_3.addEventListener(MouseEvent.MOUSE_DOWN, this.onLangChoosed);
                    }
                    else
                    {
                        _loc_3.addEventListener(TouchEvent.TOUCH_BEGIN, this.onLangChoosed);
                    }
                }
                _loc_4++;
            }
            if (parent)
            {
                parent.setChildIndex(this, (parent.numChildren - 1));
            }
            this.vStarted = true;
            return;
        }// end function

        private function onLangChoosed(event:Event) : void
        {
            MyCboListItem(event.target).gotoAndStop(2);
            Global.vRoot.changeLang(event.currentTarget.lang);
            this.setLabel(this.vMain, this.getCurLabel());
            this.vMain.gotoAndStop(2);
            return;
        }// end function

        private function cancelLang() : void
        {
            while (numChildren > 1)
            {
                
                removeChildAt(1);
            }
            this.vStarted = false;
            return;
        }// end function

    }
}
