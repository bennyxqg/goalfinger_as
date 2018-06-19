package menu.tools
{
    import flash.display.*;
    import globz.*;

    public class CostBar extends Sprite
    {
        private var vGraf:CostBarGraf;

        public function CostBar(param1:int, param2:int, param3:Number = 0, param4:Number = 0)
        {
            var _loc_5:* = 0;
            var _loc_6:* = NaN;
            x = param3;
            y = param4;
            this.vGraf = new CostBarGraf();
            if (param1 >= param2)
            {
                this.vGraf.gotoAndStop(2);
            }
            else
            {
                _loc_5 = 88;
                _loc_6 = param1 / param2;
                if (_loc_6 > 1)
                {
                    _loc_6 = 1;
                }
                this.vGraf.mcBar.gotoAndStop(Math.round(10 * _loc_6));
            }
            this.vGraf.txtCost.htmlText = "<B>" + param1 + "/" + param2 + "</B>";
            Toolz.textReduce(this.vGraf.txtCost);
            addChild(this.vGraf);
            return;
        }// end function

    }
}
