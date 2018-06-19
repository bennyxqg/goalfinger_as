package gbl.perso
{
    import com.greensock.*;
    import flash.display.*;
    import gbl.*;

    public class GBL_Perso_Puppet extends GBL_Perso
    {
        private var vGrafInside:MovieClip;
        private var vPuppet:PersoGrafMain;
        private var vSocle:MovieClip;
        private var vGlob:GBL_Glob;
        private var vOrientClip:MovieClip;
        private var vHitPoints:Sprite;

        public function GBL_Perso_Puppet(param1:GBL_Main = null, param2:Boolean = false)
        {
            this.vOrientClip = new MovieClip();
            super(param1, param2);
            vName = "Puppet fixe";
            return;
        }// end function

        override public function init(param1:GBL_Glob) : void
        {
            this.vGlob = param1;
            this.vGrafInside = new MovieClip();
            addChild(this.vGrafInside);
            this.vPuppet = new PersoGrafMain();
            this.vPuppet.init();
            this.vPuppet.setGraf(this.vGlob.vCharCode, this.vGlob.vShirtCode, v3D, Global.vSWFImages, Global.vSWFLoader);
            var _loc_2:* = 0.35;
            var _loc_3:* = 1 + (this.vGlob.vCoefMass - 1) * _loc_2;
            this.vPuppet.scaleY = 1 + (this.vGlob.vCoefMass - 1) * _loc_2;
            this.vPuppet.scaleX = _loc_3;
            this.vGrafInside.addChild(this.vPuppet);
            return;
        }// end function

        override public function destroy() : void
        {
            this.vPuppet.destroy();
            return;
        }// end function

        override public function setVisible(param1:Boolean) : void
        {
            visible = param1;
            this.vSocle.visible = param1;
            return;
        }// end function

        override public function setInMenu() : void
        {
            return;
        }// end function

        override public function getSocle() : DisplayObject
        {
            var _loc_1:* = this.vGlob.vTeam;
            if (GBL_Main.isReverse)
            {
                _loc_1 = 3 - _loc_1;
            }
            if (_loc_1 == 1)
            {
                this.vSocle = new PersoGrafSocle_1();
            }
            else
            {
                this.vSocle = new PersoGrafSocle_2();
            }
            this.vSocle.scaleX = this.vGlob.vCoefMass;
            this.vSocle.scaleY = this.vGlob.vCoefMass;
            this.setGlow(false);
            this.setHighlight(false);
            return this.vSocle;
        }// end function

        override public function onRefreshPos() : void
        {
            if (this.vSocle != null)
            {
                this.vSocle.x = x;
                this.vSocle.y = y;
            }
            return;
        }// end function

        override public function rotationInside(param1:Number) : void
        {
            this.vGrafInside.rotation = param1;
            return;
        }// end function

        override public function setOrientation(param1:Number, param2:Number) : void
        {
            param1 = param1 + 180;
            vOrientation = param1;
            if (param2 == 0)
            {
                this.vPuppet.setOrientation(param1);
            }
            else
            {
                this.vOrientClip.rotation = this.vPuppet.vOrientation;
                TweenMax.to(this.vOrientClip, param2, {shortRotation:{rotation:param1}, onUpdate:this.onOrientationUpdate});
            }
            return;
        }// end function

        private function onOrientationUpdate() : void
        {
            this.vPuppet.setOrientation(this.vOrientClip.rotation);
            return;
        }// end function

        override public function setHighlight(param1:Boolean = true) : void
        {
            if (this.vSocle != null)
            {
                if (this.vSocle.mcHighlight != null)
                {
                    this.vSocle.mcHighlight.visible = param1;
                    if (param1)
                    {
                        this.vSocle.mcHighlight.anim("pulse", -1);
                    }
                    else
                    {
                        this.vSocle.mcHighlight.anim("");
                    }
                }
            }
            return;
        }// end function

        override public function compress(param1:Number, param2:Number) : void
        {
            this.vSocle.scaleX = param2 * this.vGlob.vCoefMass;
            var _loc_3:* = 1 / param2;
            if (_loc_3 > 1.5)
            {
                _loc_3 = 1.5;
            }
            this.vSocle.scaleY = _loc_3 * this.vGlob.vCoefMass;
            this.vSocle.rotation = param1;
            return;
        }// end function

        override public function unCompress() : void
        {
            var _loc_1:* = this.vGlob.vCoefMass;
            this.vSocle.scaleY = this.vGlob.vCoefMass;
            this.vSocle.scaleX = _loc_1;
            this.vSocle.rotation = 0;
            return;
        }// end function

        override public function doKill(param1:Boolean = false) : void
        {
            if (this.vHitPoints != null)
            {
                if (param1)
                {
                    alpha = 0;
                }
                else
                {
                    TweenMax.to(this.vHitPoints, 0.3, {alpha:0});
                }
            }
            if (param1)
            {
                return;
            }
            if (this.vPuppet.y < 0)
            {
                this.anim("fall_up");
            }
            else
            {
                this.anim("fall_down");
            }
            return;
        }// end function

        override public function onPosInit() : void
        {
            this.vSocle.alpha = 1;
            this.anim("show");
            return;
        }// end function

        override public function setGlow(param1:Boolean) : void
        {
            if (!this.vGlob.isKilled && this.vSocle != null)
            {
                if (this.vSocle.mcGlow != null)
                {
                    this.vSocle.mcGlow.visible = param1;
                }
            }
            return;
        }// end function

        override public function showHitPoints(param1:int, param2:int) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = NaN;
            this.cleanHitPoints();
            this.vHitPoints = new Sprite();
            this.vPuppet.addChild(this.vHitPoints);
            var _loc_3:* = 20;
            var _loc_6:* = 0;
            while (_loc_6 < param2)
            {
                
                _loc_5 = (_loc_6 - param2 / 2 + 0.5) * 0.35;
                _loc_5 = _loc_5 + Math.PI / 2;
                _loc_4 = new HitPointGraf();
                this.vHitPoints.addChildAt(_loc_4, 0);
                if (_loc_6 >= param1)
                {
                    _loc_4.gotoAndStop(2);
                }
                var _loc_7:* = 1 / this.vPuppet.scaleX;
                _loc_4.scaleY = 1 / this.vPuppet.scaleX;
                _loc_4.scaleX = _loc_7;
                _loc_4.x = _loc_3 * Math.cos(_loc_5);
                _loc_4.y = _loc_3 * Math.sin(_loc_5);
                _loc_6++;
            }
            return;
        }// end function

        override public function cleanHitPoints() : void
        {
            if (this.vHitPoints != null)
            {
                if (this.vHitPoints.parent != null)
                {
                    this.vHitPoints.parent.removeChild(this.vHitPoints);
                }
                this.vHitPoints = null;
            }
            return;
        }// end function

        public function anim(param1:String, param2:int = 0, param3:int = 0) : void
        {
            this.vPuppet.anim(param1, param2, param3);
            this.vSocle.anim(param1, param2, param3);
            return;
        }// end function

    }
}
