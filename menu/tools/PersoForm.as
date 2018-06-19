package menu.tools
{
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    import globz.*;
    import sparks.*;
    import tools.*;

    public class PersoForm extends Sprite
    {
        public var vChar:Sparks_Char;
        private var vCallback:Function;
        public var vForm:PersoFormGraf;
        public var vCountdown:Countdown;
        public var vFinishing:Boolean = false;
        public var vBitmapHead:Boolean = false;
        public var vTeam:int;
        public var vHeadOnly:Boolean;
        public var vShirt:String = "";
        public var vEnergyBar:EnergyBar;
        public var vHeadCenter:Boolean;
        public var vPanel:SlidePanel;

        public function PersoForm(param1:Sparks_Char, param2:Function = null, param3:Boolean = false, param4:int = 0, param5:Boolean = true, param6:String = "", param7:Boolean = false)
        {
            if (param1 == null)
            {
                return;
            }
            this.vChar = param1;
            this.vTeam = param4;
            this.vHeadOnly = param5;
            this.vHeadCenter = param7;
            this.vShirt = param6;
            if (param2 != null)
            {
                this.vCallback = param2;
            }
            this.vBitmapHead = param3;
            this.refresh();
            return;
        }// end function

        public function refresh() : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            while (numChildren > 0)
            {
                
                removeChildAt(0);
            }
            if (this.vForm != null)
            {
                this.vForm.removeEventListener(MouseEvent.CLICK, this.onAction);
                this.vForm.removeEventListener(TouchEvent.TOUCH_TAP, this.onAction);
            }
            this.vForm = new PersoFormGraf();
            this.vForm.mcBG.gotoAndStop(this.vChar.vCategory);
            this.vForm.mcBG.mcTeam.gotoAndStop((this.vTeam + 1));
            addChild(this.vForm);
            this.vForm.txtName.htmlText = "<B>" + this.vChar.vName + "</B>";
            Toolz.textReduce(this.vForm.txtName);
            if (this.vChar.vStatus == "")
            {
                this.vForm.gotoAndStop(1);
                this.setMore(false);
            }
            else if (this.vChar.vStatus == "active")
            {
                this.vForm.gotoAndStop(1);
            }
            else
            {
                this.vForm.gotoAndStop(2);
                this.setMore(false);
                if (this.vChar.vStatus == "training")
                {
                    this.vForm.mcStatus.gotoAndStop(this.vChar.vJob.Attribute);
                }
                else
                {
                    this.vForm.mcStatus.gotoAndStop(this.vChar.vStatus);
                }
                this.vForm.mcStatus.visible = true;
                _loc_3 = Global.vServer.getTimeLeft(this.vChar.vJob.Started, this.vChar.vJob.Duration);
                this.vCountdown = new Countdown(this.onCountDownDone, _loc_3, true, this.vChar, this);
                if (this.vPanel != null)
                {
                    this.vCountdown.vPanel = this.vPanel;
                }
                this.vCountdown.x = this.vForm.x + this.vForm.mcTimer.x;
                this.vCountdown.y = this.vForm.y + this.vForm.mcTimer.y;
                var _loc_5:* = this.vForm.mcTimer.scaleX;
                this.vCountdown.scaleY = this.vForm.mcTimer.scaleX;
                this.vCountdown.scaleX = _loc_5;
                this.addChild(this.vCountdown);
            }
            if (this.vChar.canUpgrade() == false)
            {
                this.setMore(false);
            }
            var _loc_1:* = new PersoGrafMain();
            _loc_1.init();
            if (this.vHeadOnly)
            {
                _loc_1.setHead(this.vChar.vCharId, Global.vSWFImages, Global.vSWFLoader);
            }
            else
            {
                _loc_1.setGraf(this.vChar.vCharId, this.vShirt, false, Global.vSWFImages, Global.vSWFLoader);
                _loc_1.setOrientation(0);
            }
            if (this.vHeadCenter)
            {
                _loc_1.x = this.vForm.mcPersoCenter.x;
                _loc_1.y = this.vForm.mcPersoCenter.y;
            }
            else
            {
                _loc_1.x = this.vForm.mcPerso.x;
                _loc_1.y = this.vForm.mcPerso.y;
            }
            if (!this.vHeadOnly)
            {
                _loc_1.y = _loc_1.y + 80;
            }
            var _loc_5:* = 1.8;
            _loc_1.scaleY = 1.8;
            _loc_1.scaleX = _loc_5;
            if (this.vBitmapHead)
            {
                _loc_4 = new ButtonGrafBitmap(_loc_1);
                this.vForm.addChild(_loc_4);
                if (!this.vHeadOnly)
                {
                    this.vForm.mcMask.visible = false;
                }
                else
                {
                    _loc_4.mask = this.vForm.mcMask;
                }
            }
            else
            {
                this.vForm.addChild(_loc_1);
                if (!this.vHeadOnly)
                {
                    this.vForm.mcMask.visible = false;
                }
                else
                {
                    _loc_1.mask = this.vForm.mcMask;
                }
            }
            if (this.vChar.vStatus == "" || this.vChar.vStatus == "active")
            {
                this.vForm.mc1.gotoAndStop(this.attributeToFrame(this.vChar.getForce()));
                this.vForm.txtAdd1.htmlText = "<B>+" + this.vChar.getForce() + "</B>";
                this.vForm.mc2.gotoAndStop(this.attributeToFrame(this.vChar.getSpeed()));
                this.vForm.txtAdd2.htmlText = "<B>+" + this.vChar.getSpeed() + "</B>";
                this.vForm.mc3.gotoAndStop(this.attributeToFrame(this.vChar.getVitality()));
                this.vForm.txtAdd3.htmlText = "<B>+" + this.vChar.getVitality() + "</B>";
            }
            if (!this.vHeadCenter)
            {
                this.vEnergyBar = new EnergyBar(this.vChar, this.vForm, this.vForm.mcEnergy.x, this.vForm.mcEnergy.y);
            }
            var _loc_2:* = this.vChar.getEnergy();
            if (_loc_2 == 100)
            {
                this.setMoreRecuperation(false);
            }
            else if (Global.vServer.vUser.getEnergyCards().length > 0)
            {
                this.setMoreRecuperation(true);
            }
            else
            {
                this.setMoreRecuperation(false);
            }
            if (this.vCallback != null)
            {
                if (Capabilities.isDebugger)
                {
                    this.vForm.addEventListener(MouseEvent.CLICK, this.onAction);
                }
                else
                {
                    this.vForm.addEventListener(TouchEvent.TOUCH_TAP, this.onAction);
                }
            }
            return;
        }// end function

        public function setPanel(param1:SlidePanel) : void
        {
            this.vPanel = param1;
            if (this.vCountdown != null)
            {
                this.vCountdown.vPanel = param1;
            }
            return;
        }// end function

        public function setMore(param1:Boolean = true) : void
        {
            if (this.vForm.mcMore == null)
            {
                return;
            }
            this.vForm.mcMore.visible = param1;
            return;
        }// end function

        public function setMoreRecuperation(param1:Boolean = true) : void
        {
            if (this.vForm.mcMoreRecuperation == null)
            {
                return;
            }
            this.vForm.mcMoreRecuperation.visible = param1;
            return;
        }// end function

        private function onCountDownDone() : void
        {
            if (this.vChar.vStatus == "recruit")
            {
                this.vChar.vStatus = "active";
                if (this.vCountdown != null)
                {
                    this.vCountdown.visible = false;
                }
                this.vForm.mcStatus.visible = false;
            }
            return;
        }// end function

        private function onAction(event:Event) : void
        {
            if (this.vFinishing)
            {
                return;
            }
            this.vCallback.call(0, this);
            return;
        }// end function

        private function attributeToFrame(param1:int) : int
        {
            return (param1 + 1);
        }// end function

    }
}
