package gbl.ergo
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.geom.*;
    import gbl.*;

    public class GBL_Aiming extends Sprite
    {
        private var vGame:GBL_Main;
        private var vGlobs:Vector.<GBL_Glob>;
        private var vLastPos:Vector.<Point>;
        private var vLine1:Vector.<Sprite>;
        private var vLine2:Vector.<Sprite>;
        private var vLastOrders:String = "";
        private var vLineThickness:int = 1;
        private var vCompute:GBL_Compute;

        public function GBL_Aiming(param1:GBL_Main)
        {
            this.vGame = param1;
            return;
        }// end function

        public function compute() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_12:* = NaN;
            var _loc_1:* = this.vGame.buildOrders();
            if (this.vLastOrders == _loc_1)
            {
                return;
            }
            this.vLastOrders = _loc_1;
            while (numChildren > 0)
            {
                
                removeChildAt(0);
            }
            this.vGlobs = new Vector.<GBL_Glob>;
            _loc_2 = 0;
            while (_loc_2 < this.vGame.vTerrain.vGlobs.length)
            {
                
                this.vGlobs.push(this.vGame.vTerrain.vGlobs[_loc_2].clone());
                _loc_2++;
            }
            this.vLastPos = new Vector.<Point>;
            this.vLine1 = new Vector.<Sprite>;
            this.vLine2 = new Vector.<Sprite>;
            var _loc_5:* = new Point(0, 0);
            _loc_2 = 0;
            while (_loc_2 < this.vGlobs.length)
            {
                
                _loc_3 = this.vGlobs[_loc_2].vPos.clone();
                if (GBL_Main.isReverse)
                {
                    _loc_3.x = -_loc_3.x;
                    _loc_3.y = -_loc_3.y;
                }
                this.vLastPos.push(_loc_3);
                _loc_4 = new Sprite();
                _loc_4.graphics.lineStyle(this.vLineThickness, this.getLineColor(this.vGlobs[_loc_2].vTeam));
                _loc_4.graphics.moveTo(_loc_3.x, _loc_3.y);
                addChild(_loc_4);
                this.vLine1.push(_loc_4);
                _loc_4 = new Sprite();
                _loc_4.graphics.lineStyle(this.vLineThickness, this.getLineColor(this.vGlobs[_loc_2].vTeam));
                _loc_4.graphics.moveTo(_loc_3.x, _loc_3.y);
                addChild(_loc_4);
                this.vLine2.push(_loc_4);
                if (this.vGlobs[_loc_2].isKilled)
                {
                    this.vLine1[_loc_2].visible = false;
                    this.vLine2[_loc_2].visible = false;
                }
                _loc_2++;
            }
            this.vCompute = new GBL_Compute(this.vGame, this.vGlobs, this.vLastOrders);
            this.vCompute.initResolution();
            var _loc_6:* = 0;
            while (_loc_6 < 1)
            {
                
                _loc_6 = _loc_6 + 0.01;
                if (_loc_6 > 1)
                {
                    _loc_6 = 1;
                }
                _loc_7 = this.vCompute.getEvents(_loc_6);
                _loc_2 = 0;
                while (_loc_2 < _loc_7.length)
                {
                    
                    _loc_2++;
                }
                _loc_8 = this.vCompute.getPosAtPercentTime(_loc_6);
                _loc_2 = 0;
                while (_loc_2 < this.vGlobs.length)
                {
                    
                    _loc_9 = this.vGlobs[_loc_2];
                    _loc_5.x = -(_loc_8.pos[_loc_2].y - _loc_9.vPos.y);
                    _loc_5.y = _loc_8.pos[_loc_2].x - _loc_9.vPos.x;
                    _loc_5.normalize(_loc_9.vRadius * _loc_9.vCoefMass);
                    _loc_9.vPos.x = _loc_8.pos[_loc_2].x;
                    _loc_9.vPos.y = _loc_8.pos[_loc_2].y;
                    _loc_9.setOrientation(_loc_8.orientation[_loc_2]);
                    _loc_9.compress(_loc_8.compress[_loc_2].x, _loc_8.compress[_loc_2].y);
                    _loc_9.refresh();
                    _loc_12 = 1.1 - 2 * _loc_6 / 2;
                    _loc_3.x = _loc_9.vPos.x + _loc_5.x;
                    _loc_3.y = _loc_9.vPos.y + _loc_5.y;
                    if (GBL_Main.isReverse)
                    {
                        _loc_3.x = -_loc_3.x;
                        _loc_3.y = -_loc_3.y;
                    }
                    this.vLine1[_loc_2].graphics.lineStyle(this.vLineThickness, this.getLineColor(_loc_9.vTeam), _loc_12);
                    this.vLine1[_loc_2].graphics.lineTo(_loc_3.x, _loc_3.y);
                    _loc_3.x = _loc_9.vPos.x - _loc_5.x;
                    _loc_3.y = _loc_9.vPos.y - _loc_5.y;
                    if (GBL_Main.isReverse)
                    {
                        _loc_3.x = -_loc_3.x;
                        _loc_3.y = -_loc_3.y;
                    }
                    this.vLine2[_loc_2].graphics.lineStyle(this.vLineThickness, this.getLineColor(_loc_9.vTeam), _loc_12);
                    this.vLine2[_loc_2].graphics.lineTo(_loc_3.x, _loc_3.y);
                    _loc_2++;
                }
            }
            var _loc_11:* = new ColorTransform();
            _loc_2 = 0;
            while (_loc_2 < this.vGlobs.length)
            {
                
                _loc_10 = new GrafAimingFinalPos();
                _loc_10.x = _loc_9.vPos.x;
                _loc_10.y = _loc_9.vPos.y;
                if (GBL_Main.isReverse)
                {
                    _loc_10.x = -_loc_10.x;
                    _loc_10.y = -_loc_10.y;
                }
                var _loc_13:* = 2 * _loc_9.vRadius * _loc_9.vCoefMass;
                _loc_10.height = 2 * _loc_9.vRadius * _loc_9.vCoefMass;
                _loc_10.width = _loc_13;
                addChild(_loc_10);
                _loc_11.color = this.getLineColor(_loc_9.vTeam);
                _loc_10.transform.colorTransform = _loc_11;
                if (_loc_9.isKilled)
                {
                    _loc_10.visible = false;
                }
                _loc_2++;
            }
            return;
        }// end function

        private function getLineColor(param1:int) : uint
        {
            if (param1 == 3)
            {
                return 16777215;
            }
            if (param1 == this.vGame.vCurTeam)
            {
                return 3355647;
            }
            return 16724736;
        }// end function

    }
}
