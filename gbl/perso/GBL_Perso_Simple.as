package gbl.perso
{
    import flash.display.*;
    import gbl.*;
    import globz.*;

    public class GBL_Perso_Simple extends GBL_Perso
    {
        private var vGrafInside:MovieClip;
        private var vGrafClip:bitmapClip;
        private var vGlob:GBL_Glob;
        private var vOldX:Number = 0;
        private var vOldY:Number = 0;
        private var vHighlight:ErgoGlobHighlight;

        public function GBL_Perso_Simple(param1:GBL_Main = null, param2:Boolean = false)
        {
            super(param1, param2);
            vName = "Simple";
            return;
        }// end function

        override public function init(param1:GBL_Glob) : void
        {
            var _loc_2:* = null;
            this.vGlob = param1;
            this.vGrafInside = new MovieClip();
            addChild(this.vGrafInside);
            if (vGame.vImages == null)
            {
                return;
            }
            this.vGrafClip = new bitmapClip(vGame.vImages["glob_team" + this.vGlob.vTeam + "_pos" + this.vGlob.vPosition]);
            if ("glob_team" + this.vGlob.vTeam + "_pos" + this.vGlob.vPosition == "glob_team3_pos0")
            {
                var _loc_3:* = GBL_Glob.BALL_SIZE_COEF;
                this.vGrafInside.scaleY = GBL_Glob.BALL_SIZE_COEF;
                this.vGrafInside.scaleX = _loc_3;
                _loc_2 = new GameBallMask();
                this.vGrafClip.addChildAt(_loc_2, 1);
                this.vGrafClip.mcTexture.mask = _loc_2;
                this.vOldX = x;
                this.vOldY = y;
            }
            this.vGrafInside.addChild(this.vGrafClip);
            return;
        }// end function

        override public function rotationInside(param1:Number) : void
        {
            this.vGrafInside.rotation = param1;
            return;
        }// end function

        override public function setOrientation(param1:Number, param2:Number) : void
        {
            return;
        }// end function

        override public function onRefreshPos() : void
        {
            var _loc_1:* = NaN;
            if (this.vGrafClip == null)
            {
                return;
            }
            if (this.vGrafClip.mcTexture)
            {
                _loc_1 = this.vGrafClip.mcTexture.scaleX;
                this.vGrafClip.mcTexture.x = (this.vGrafClip.mcTexture.x - (this.vOldX - x)) % (31.9 * _loc_1);
                this.vGrafClip.mcTexture.y = (this.vGrafClip.mcTexture.y - (this.vOldY - y)) % (55.3 * _loc_1);
            }
            this.vOldX = x;
            this.vOldY = y;
            return;
        }// end function

        override public function setHighlight(param1:Boolean = true) : void
        {
            if (param1)
            {
                if (this.vHighlight == null)
                {
                    this.vHighlight = new ErgoGlobHighlight();
                    var _loc_2:* = this.vGlob.vCoefMass;
                    this.vHighlight.scaleY = this.vGlob.vCoefMass;
                    this.vHighlight.scaleX = _loc_2;
                    addChildAt(this.vHighlight, 0);
                }
                this.vHighlight.visible = true;
            }
            else if (this.vHighlight != null)
            {
                this.vHighlight.visible = false;
            }
            return;
        }// end function

    }
}
