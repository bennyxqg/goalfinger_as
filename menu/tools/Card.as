package menu.tools
{
    import flash.display.*;
    import globz.*;

    public class Card extends Sprite
    {
        private var vGraf:MovieClip;

        public function Card(param1:String, param2:String, param3:int = 0, param4:Boolean = true)
        {
            var _loc_5:* = null;
            if (param1 != "Gold" && param2.substr(0, 1) == "G")
            {
                param1 = "Gold";
                param3 = parseInt(param2.substr(1));
                param2 = "Gold_A";
            }
            if (param1 == "Gold")
            {
                _loc_5 = new CardGraf();
                _loc_5.mcFG.visible = false;
                _loc_5.gotoAndStop(param2);
                if (param3 == -1)
                {
                    _loc_5.txtGold.htmlText = "";
                }
                else
                {
                    _loc_5.txtGold.htmlText = "<B>" + param3.toString() + "</B>";
                }
                Toolz.textReduce(_loc_5.txtGold);
                this.vGraf = new MovieClip();
                if (param4)
                {
                    this.vGraf.addChild(new ButtonGrafBitmap(_loc_5));
                }
                else
                {
                    this.vGraf.addChild(_loc_5);
                }
            }
            else if (param1 == "Card")
            {
                this.vGraf = new MovieClip();
                if (param2 == "?")
                {
                    this.vGraf.addChild(new bitmapClip(Global.vImages["card_back"]));
                }
                else
                {
                    this.vGraf.addChild(new bitmapClip(Global.vImages["card_" + param2]));
                }
                ;
            }
            addChild(this.vGraf);
            return;
        }// end function

        public function setShadow() : void
        {
            this.vGraf.addChild(new CardShadow());
            return;
        }// end function

        public static function getTitle(param1:String) : String
        {
            var _loc_2:* = Global.getText("txtCard" + param1);
            if (param1.substr(0, 1) == "E")
            {
                _loc_2 = Global.getText("txtCardEX");
                _loc_2 = _loc_2.replace(/#/, param1.substr(1));
            }
            return _loc_2;
        }// end function

    }
}
