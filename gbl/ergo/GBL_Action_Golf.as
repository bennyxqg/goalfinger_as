package gbl.ergo
{
    import __AS3__.vec.*;
    import flash.geom.*;
    import flash.utils.*;
    import gbl.*;
    import tools.*;

    public class GBL_Action_Golf extends GBL_Action
    {
        private var vCurDragId:int;
        private var vOrder:Vector.<GBL_Glob>;
        private var vCurDrag:GBL_Glob;
        private var vCurTouchId:int = 0;
        private var vDragStart:ErgoGlobHighlight;
        private var vDragTime0:int;
        private var vDragDelayShort:int = 200;
        private var vDragDistanceShort:int = 20;
        private var vDirectTapDone:Boolean = false;
        private var vSavedLastOrder:Point;
        private var vDoubleTapDelay:int = 300;
        private var vDoubleTapLastGlob:GBL_Glob;
        private var vDoubleTapLastTime:int = 0;

        public function GBL_Action_Golf(param1:GBL_Main = null)
        {
            super(param1);
            vName = "Golf Classique";
            return;
        }// end function

        override protected function onStart() : void
        {
            var _loc_2:* = null;
            var _loc_4:* = false;
            var _loc_1:* = new Array();
            var _loc_3:* = vGame.getGlob(3, 0).vPos;
            var _loc_5:* = 1;
            while (_loc_5 <= vGame.vTerrain.vGlobsPerTeam)
            {
                
                _loc_2 = new Object();
                _loc_2.glob = vGame.getGlob(vGame.vCurTeam, _loc_5);
                _loc_2.dist = Point.distance(_loc_2.glob.vPos, _loc_3) - _loc_2.glob.vRadius;
                _loc_4 = true;
                if (Global.vHitPoints)
                {
                    if (_loc_2.glob.vWounded)
                    {
                        _loc_4 = false;
                    }
                }
                if (_loc_4)
                {
                    _loc_1.push(_loc_2);
                }
                _loc_5++;
            }
            _loc_1.sort(this.sortDist);
            this.vOrder = new Vector.<GBL_Glob>;
            _loc_5 = 0;
            while (_loc_5 < _loc_1.length)
            {
                
                this.vOrder.push(_loc_1[_loc_5].glob);
                _loc_5++;
            }
            this.vCurDragId = -1;
            this.setNextGlob();
            return;
        }// end function

        private function sortDist(param1:Object, param2:Object) : int
        {
            if (param1.dist < param2.dist)
            {
                return -1;
            }
            if (param1.dist > param2.dist)
            {
                return 1;
            }
            return 0;
        }// end function

        private function setNextGlob(param1:GBL_Glob = null) : void
        {
            var _loc_2:* = false;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            if (Global.vHitPoints)
            {
                _loc_2 = false;
                _loc_4 = 0;
                while (_loc_4 < this.vOrder.length)
                {
                    
                    if (!this.vOrder[_loc_4].isKilled)
                    {
                        if (!this.vOrder[_loc_4].vWounded)
                        {
                            _loc_2 = true;
                        }
                    }
                    _loc_4++;
                }
                if (!_loc_2)
                {
                    return;
                }
            }
            if (this.vCurDrag != null)
            {
                this.vCurDrag.vPerso.setHighlight(false);
            }
            if (Global.vHitPoints)
            {
                if (param1 != null)
                {
                    if (param1.vWounded)
                    {
                        _loc_3 = Global.getText("txtInGameWounded");
                        vGame.vInterface.showBubble(param1.vPos.clone(), _loc_3);
                        return;
                    }
                }
            }
            if (param1 == null)
            {
                var _loc_5:* = this;
                var _loc_6:* = this.vCurDragId + 1;
                _loc_5.vCurDragId = _loc_6;
                if (this.vCurDragId >= this.vOrder.length)
                {
                    this.vCurDragId = 0;
                }
                this.vCurDrag = this.vOrder[this.vCurDragId];
            }
            else
            {
                _loc_4 = 0;
                while (_loc_4 < this.vOrder.length)
                {
                    
                    if (this.vOrder[_loc_4] == param1)
                    {
                        this.vCurDragId = _loc_4;
                    }
                    _loc_4++;
                }
                this.vCurDrag = param1;
            }
            this.vCurDrag.vPerso.setHighlight(true);
            if (this.vCurDrag.isKilled)
            {
                this.setNextGlob();
            }
            return;
        }// end function

        override protected function onEnd() : void
        {
            if (this.vDragStart != null)
            {
                vGame.layerPlayers.removeChild(this.vDragStart);
                this.vDragStart = null;
            }
            if (this.vCurDrag != null)
            {
                this.vCurDrag.vPerso.setHighlight(false);
            }
            this.vCurTouchId = 0;
            vGame.vInterface.onBoosterCancel();
            return;
        }// end function

        override protected function onMDown(param1:MyTouch) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            if (this.vCurTouchId > 0)
            {
                return;
            }
            var _loc_2:* = vGame.vTerrain.getGlobInRange(1, new Point(param1.x, param1.y));
            if (_loc_2 != null)
            {
                this.vDirectTapDone = true;
                this.setNextGlob(_loc_2);
                if (this.vDoubleTapLastGlob != null)
                {
                    if (getTimer() - this.vDoubleTapLastTime < this.vDoubleTapDelay)
                    {
                        _loc_3 = this.vDoubleTapLastGlob.vPos.clone();
                        if (GBL_Main.isReverse)
                        {
                            _loc_3.x = -_loc_3.x;
                            _loc_3.y = -_loc_3.y;
                        }
                        this.vDoubleTapLastGlob.showArrow(_loc_3);
                        this.vDirectTapDone = false;
                    }
                }
                this.vDoubleTapLastGlob = _loc_2;
                this.vDoubleTapLastTime = getTimer();
            }
            else
            {
                this.vDoubleTapLastGlob = null;
            }
            this.vCurTouchId = param1.id;
            if (this.vDragStart != null)
            {
                if (vGame.layerPlayers.contains(this.vDragStart))
                {
                    vGame.layerPlayers.removeChild(this.vDragStart);
                }
                this.vDragStart = null;
            }
            this.vDragStart = new ErgoGlobHighlight();
            this.vDragStart.x = param1.x;
            this.vDragStart.y = param1.y;
            this.vDragStart.alpha = 0;
            var _loc_5:* = 0.3;
            this.vDragStart.scaleY = 0.3;
            this.vDragStart.scaleX = _loc_5;
            vGame.layerPlayers.addChildAt(this.vDragStart, 0);
            this.vDragStart.visible = false;
            this.vDragTime0 = getTimer();
            if (this.vCurDrag != null)
            {
                _loc_4 = this.vCurDrag.getArrowOrder();
                this.vSavedLastOrder = new Point(-_loc_4.x, -_loc_4.y);
                if (this.vDirectTapDone)
                {
                    this.vSavedLastOrder.x = 0;
                    this.vSavedLastOrder.y = 0;
                }
                if (GBL_Main.isReverse)
                {
                    this.vSavedLastOrder.x = this.vSavedLastOrder.x * -1;
                    this.vSavedLastOrder.y = this.vSavedLastOrder.y * -1;
                }
            }
            this.onMMove(param1);
            vGame.vTerrain.afterResolution();
            return;
        }// end function

        override protected function onMMove(param1:MyTouch) : void
        {
            var _loc_3:* = null;
            if (this.vCurTouchId != param1.id)
            {
                return;
            }
            if (this.vDragStart == null)
            {
                return;
            }
            if (this.vCurDrag == null)
            {
                return;
            }
            var _loc_2:* = new Point(param1.x, param1.y);
            if (this.vDragStart.visible == false)
            {
                if (getTimer() - this.vDragTime0 < this.vDragDelayShort && Point.distance(_loc_2, new Point(this.vDragStart.x, this.vDragStart.y)) < this.vDragDistanceShort)
                {
                }
                else
                {
                    if (this.vDirectTapDone)
                    {
                        this.vDirectTapDone = false;
                    }
                    this.vDragStart.x = this.vDragStart.x + this.vSavedLastOrder.x;
                    this.vDragStart.y = this.vDragStart.y + this.vSavedLastOrder.y;
                    this.vDragStart.visible = true;
                }
            }
            else
            {
                _loc_3 = this.vCurDrag.vPos.clone();
                if (GBL_Main.isReverse)
                {
                    _loc_3.x = -_loc_3.x;
                    _loc_3.y = -_loc_3.y;
                }
                _loc_2.x = _loc_2.x - (this.vDragStart.x - _loc_3.x);
                _loc_2.y = _loc_2.y - (this.vDragStart.y - _loc_3.y);
                if (Global.vHitPoints)
                {
                    if (this.vCurDrag.vWounded)
                    {
                        _loc_2.normalize(0);
                    }
                }
                if (Global.vErgoReverse)
                {
                    _loc_2.x = _loc_2.x - 2 * (_loc_2.x - _loc_3.x);
                    _loc_2.y = _loc_2.y - 2 * (_loc_2.y - _loc_3.y);
                }
                this.vCurDrag.showArrow(_loc_2);
                Global.vSound.onDragTick();
            }
            vGame.vTerrain.afterResolution();
            return;
        }// end function

        override protected function onMUp(param1:MyTouch) : void
        {
            if (this.vDragStart == null)
            {
                return;
            }
            if (this.vDragStart.visible == false)
            {
                this.vCurTouchId = 0;
                if (!this.vDirectTapDone)
                {
                    this.setNextGlob();
                }
                return;
            }
            else
            {
                this.onMMove(param1);
                this.vCurDrag.onEndArrow();
                vGame.vTerrain.showOutlines();
                if (vGame.vHandlerOrder != null)
                {
                    vGame.vHandlerOrder.call();
                }
            }
            this.vCurTouchId = 0;
            if (this.vDragStart != null)
            {
                vGame.layerPlayers.removeChild(this.vDragStart);
                this.vDragStart = null;
            }
            this.setNextGlob();
            vGame.vTerrain.afterResolution();
            return;
        }// end function

    }
}
