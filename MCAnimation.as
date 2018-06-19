package 
{
    import flash.display.*;

    public class MCAnimation extends MovieClip
    {
        public var mcPerso:MovieClip;
        public var mcHighlight:persoHighlight;
        public var mcShadow:MovieClip;
        public var mcGlow:MovieClip;
        public var vAnim:String = "";
        public var vAnimLoop:int = 0;
        private var vLabels:Array;

        public function MCAnimation()
        {
            this.vAnim = "";
            this.vAnimLoop = 0;
            this.vLabels = this.currentLabels;
            return;
        }// end function

        public function anim(param1:String, param2:int = 0, param3:int = 0) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            if (param1 == this.vAnim)
            {
                return;
            }
            if (param1 == "")
            {
                this.vAnim = "";
                this.vAnimLoop = 0;
                stop();
                return;
            }
            this.vAnim = param1;
            this.vAnimLoop = param2;
            if (param3 > 0)
            {
                _loc_4 = 0;
                while (_loc_4 < this.vLabels.length)
                {
                    
                    if (this.vLabels[_loc_4].name == this.vAnim)
                    {
                        _loc_5 = this.vLabels[_loc_4].frame;
                        gotoAndPlay(_loc_5 + param3);
                        break;
                    }
                    _loc_4++;
                }
            }
            else
            {
                gotoAndPlay(this.vAnim);
            }
            return;
        }// end function

        public function checkEnd(param1)
        {
            if (this.vAnimLoop > 0)
            {
                var _loc_2:* = this;
                var _loc_3:* = this.vAnimLoop - 1;
                _loc_2.vAnimLoop = _loc_3;
            }
            if (this.vAnimLoop > 0 || this.vAnimLoop == -1 && this.vAnim == param1)
            {
                gotoAndPlay(this.vAnim);
            }
            else if (this.vAnim == param1)
            {
                this.vAnim = "";
                stop();
            }
            return;
        }// end function

    }
}
