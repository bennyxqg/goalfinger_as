package menu.tools
{
    import flash.display.*;
    import globz.*;

    public class ConsecutiveWinStep extends MovieClip
    {
        private var vHeight:int = 100;

        public function ConsecutiveWinStep(param1:int, param2:Boolean, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false, param6:Number = 1)
        {
            var _loc_10:* = null;
            if (param1 >= Global.vConsecutiveWins.length)
            {
                return;
            }
            var _loc_7:* = Global.vConsecutiveWins[param1].cards;
            var _loc_8:* = Global.vConsecutiveWins[param1].trophies;
            var _loc_9:* = new ConsecutiveWinsStepGraf();
            var _loc_11:* = param6;
            _loc_9.scaleY = param6;
            _loc_9.scaleX = _loc_11;
            if (_loc_8 == 0)
            {
                if (param3)
                {
                    _loc_9.gotoAndStop(4);
                }
                else
                {
                    _loc_9.gotoAndStop(2);
                }
                this.vHeight = 55;
            }
            else
            {
                if (param3)
                {
                    _loc_9.gotoAndStop(3);
                }
                else
                {
                    _loc_9.gotoAndStop(1);
                }
                this.vHeight = 100;
                _loc_9.txtTrophy.htmlText = "<B>+" + _loc_8 + "</B>";
                Toolz.textReduce(_loc_9.txtTrophy);
            }
            _loc_9.txtCard.htmlText = "<B>x" + _loc_7 + "</B>";
            Toolz.textReduce(_loc_9.txtCard);
            if (!param3)
            {
                if (param2)
                {
                    _loc_9.mcBG.gotoAndStop(5);
                }
                else
                {
                    _loc_9.mcBG.gotoAndStop(4);
                }
            }
            _loc_9.txtNum.htmlText = "<B>" + ((param1 + 1)).toString() + "</B>";
            if (param3 || param4)
            {
                _loc_9.txtNum.visible = false;
            }
            if (param4)
            {
                _loc_9.mcDone.visible = false;
            }
            else if (param1 < Global.vServer.vUser.vConsecutiveWins)
            {
                _loc_9.mcDone.visible = true;
            }
            else
            {
                _loc_9.mcDone.visible = false;
            }
            if (param5)
            {
                _loc_10 = new ConsecutiveWinsStepGraf();
                var _loc_11:* = param6;
                _loc_10.scaleY = param6;
                _loc_9.scaleX = _loc_11;
                if (_loc_8 == 0)
                {
                    if (param3)
                    {
                        _loc_10.gotoAndStop(4);
                    }
                    else
                    {
                        _loc_10.gotoAndStop(2);
                    }
                }
                else if (param3)
                {
                    _loc_10.gotoAndStop(3);
                }
                else
                {
                    _loc_10.gotoAndStop(1);
                }
                if (!param3)
                {
                    if (param2)
                    {
                        _loc_10.mcBG.gotoAndStop(5);
                    }
                    else
                    {
                        _loc_10.mcBG.gotoAndStop(4);
                    }
                }
                while (_loc_10.numChildren > 1)
                {
                    
                    _loc_10.removeChildAt(1);
                }
                addChild(_loc_10);
                addChild(new ButtonGrafBitmap(_loc_9));
            }
            else
            {
                addChild(_loc_9);
            }
            return;
        }// end function

        public function getHeight() : Number
        {
            return this.vHeight;
        }// end function

    }
}
