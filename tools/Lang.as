package tools
{
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import globz.*;

    public class Lang extends Object
    {
        public var vCur:String;
        private var vCallback:Function;
        private var vText:XML;
        private var vAddChar:String = "";
        public var isSans:Boolean = false;

        public function Lang(param1:String, param2:Function)
        {
            this.vCallback = param2;
            var _loc_3:* = SharedObject.getLocal(Global.SO_ID);
            if (param1 == "")
            {
                if (_loc_3.data.lang2 != null)
                {
                    param1 = _loc_3.data.lang2;
                }
            }
            if (param1 == null)
            {
                param1 = "";
            }
            if (param1 == "")
            {
                param1 = Capabilities.language.substr(0, 2).toLowerCase();
            }
            var _loc_4:* = false;
            var _loc_5:* = 0;
            while (_loc_5 < Global.vLangOpen.length)
            {
                
                if (Global.vLangOpen[_loc_5] == param1)
                {
                    _loc_4 = true;
                }
                _loc_5++;
            }
            if (!_loc_4)
            {
                param1 = "en";
            }
            if (_loc_3.data.lang2 != param1)
            {
                _loc_3.data.lang2 = param1;
                _loc_3.flush();
            }
            var _loc_6:* = new URLLoader();
            _loc_6.addEventListener(Event.COMPLETE, this.parseLang);
            _loc_6.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            this.vCur = param1;
            if (this.vCur == "ru")
            {
                this.isSans = true;
            }
            else if (this.vCur == "zh")
            {
                this.isSans = true;
            }
            else if (this.vCur == "ko")
            {
                this.isSans = true;
            }
            else if (this.vCur == "ja")
            {
                this.isSans = true;
            }
            else if (this.vCur == "tr")
            {
                this.isSans = true;
            }
            else
            {
                this.isSans = false;
            }
            var _loc_7:* = new URLRequest("lang/text_" + this.vCur + ".xml");
            _loc_6.load(_loc_7);
            return;
        }// end function

        private function ioErrorHandler(event:IOErrorEvent) : void
        {
            Global.vStats.Stats_Error("Lang ioErrorHandler : " + event.toString());
            return;
        }// end function

        public function toggleVerifText() : void
        {
            if (this.vAddChar == "")
            {
                this.vAddChar = "µ";
            }
            else
            {
                this.vAddChar = "";
            }
            return;
        }// end function

        private function parseLang(event:Event) : void
        {
            XML.ignoreWhitespace = true;
            this.vText = new XML(event.target.data);
            this.vText["txtLogoSans"] = this.vText["txtLogoLine1"] + "," + this.vText["txtLogoLine2"] + "," + this.vText["txtLogoParams"];
            this.vCallback.call();
            this.vCallback = null;
            return;
        }// end function

        public function getText(param1:String, param2:Boolean = true) : String
        {
            if (this.vText == null)
            {
                return "";
            }
            if (this.vText[param1] == null)
            {
                return "[" + param1 + "]";
            }
            var _loc_3:* = this.vText[param1];
            if (param2 && this.isSans)
            {
                _loc_3 = "<FONT FACE=\"_sans\">" + _loc_3 + "</FONT>";
            }
            return this.vAddChar + _loc_3;
        }// end function

        public function checkSans(param1:TextField, param2:Boolean = true) : void
        {
            if (!this.isSans)
            {
                if (param2)
                {
                    Toolz.textReduce(param1);
                }
                return;
            }
            var _loc_3:* = 1;
            var _loc_4:* = param1.defaultTextFormat.font;
            if (param1.defaultTextFormat.font == "Edit Undo BRK")
            {
                _loc_3 = 44 / 60;
            }
            else if (_loc_4 == "OpenDyslexic")
            {
                _loc_3 = 1.1;
            }
            else if (_loc_4 == "Esphimere")
            {
                _loc_3 = 1;
                ;
            }
            if (this.vCur == "ru")
            {
                _loc_3 = _loc_3 * 0.8;
                param1.y = param1.y + 5;
            }
            var _loc_5:* = new TextFormat();
            _loc_5.font = "_sans";
            var _loc_6:* = 12;
            if (param1.getTextFormat().size != null)
            {
                _loc_6 = parseInt(param1.getTextFormat().size.toString());
            }
            _loc_5.size = Math.round(_loc_6 * _loc_3);
            param1.defaultTextFormat = _loc_5;
            param1.setTextFormat(_loc_5);
            param1.embedFonts = false;
            if (param2)
            {
                Toolz.textReduce(param1);
            }
            return;
        }// end function

    }
}
