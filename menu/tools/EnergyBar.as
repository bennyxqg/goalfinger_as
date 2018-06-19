package menu.tools
{
    import flash.display.*;
    import flash.events.*;
    import globz.*;
    import sparks.*;

    public class EnergyBar extends Sprite
    {
        private var vChar:Sparks_Char;
        private var vGraf:EnergyBarGraf;
        private var vBG:bitmapClip;
        private var vValueFont:MyFont;

        public function EnergyBar(param1:Sparks_Char, param2:DisplayObjectContainer, param3:Number, param4:Number)
        {
            this.vChar = param1;
            x = param3;
            y = param4;
            param2.addChild(this);
            this.vGraf = new EnergyBarGraf();
            addChild(this.vGraf);
            this.vGraf.mcZap.mcBG.visible = false;
            this.vBG = new bitmapClip(Global.vImages["energybarbg"]);
            this.vGraf.mcZap.addChildAt(this.vBG, 0);
            this.refreshBar();
            addEventListener(Event.ADDED_TO_STAGE, this.onStageAdded);
            return;
        }// end function

        private function onStageAdded(event:Event) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.onStageAdded);
            if (this.vChar.getEnergy() == 100)
            {
                return;
            }
            addEventListener(Event.ENTER_FRAME, this.onFrame);
            addEventListener(Event.REMOVED_FROM_STAGE, this.onStageRemoved);
            return;
        }// end function

        private function onStageRemoved(event:Event) : void
        {
            removeEventListener(Event.ENTER_FRAME, this.onFrame);
            removeEventListener(Event.REMOVED_FROM_STAGE, this.onStageRemoved);
            return;
        }// end function

        private function onFrame(event:Event) : void
        {
            this.refreshBar();
            return;
        }// end function

        private function refreshBar() : void
        {
            var _loc_1:* = this.vChar.getEnergy();
            if (Global.vDev)
            {
            }
            var _loc_2:* = this.curve(_loc_1);
            _loc_2 = 100 - _loc_2;
            if (_loc_2 == 0)
            {
                _loc_2 = 1;
            }
            this.vGraf.mcZap.gotoAndStop(_loc_2);
            this.vGraf.mcZap.mcBar.y = 31 - 63 * this.curve(Sparks_Char.vEnergyThreshold) / 100;
            if (_loc_1 < Sparks_Char.vEnergyThreshold)
            {
                this.vBG.gotoAndStop(2);
            }
            else
            {
                this.vBG.gotoAndStop(1);
            }
            if (this.vValueFont != null)
            {
                this.vGraf.mcZap.removeChild(this.vValueFont);
                this.vValueFont = null;
            }
            if (_loc_1 < 100)
            {
                if (_loc_1 < Sparks_Char.vEnergyThreshold)
                {
                    this.vGraf.mcZap.txtValueOff.text = _loc_1.toString();
                    this.vGraf.mcZap.txtValueOn.visible = false;
                }
                else
                {
                    this.vGraf.mcZap.txtValueOn.text = _loc_1.toString();
                    this.vGraf.mcZap.txtValueOff.visible = false;
                }
            }
            else
            {
                this.vGraf.mcZap.txtValueOn.visible = false;
                this.vGraf.mcZap.txtValueOff.visible = false;
            }
            return;
        }// end function

        private function curve(param1:int) : int
        {
            if (param1 < 0)
            {
                param1 = 0;
            }
            return Math.round(100 * Math.pow(param1 / 100, 0.6));
        }// end function

    }
}
