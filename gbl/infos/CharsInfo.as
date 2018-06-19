package gbl.infos
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import gbl.*;
    import menu.tools.*;
    import sparks.*;

    public class CharsInfo extends MovieClip
    {
        private var vGame:GBL_Main;
        private var vTab:Array;

        public function CharsInfo(param1:GBL_Main)
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = false;
            var _loc_9:* = null;
            var _loc_10:* = 0;
            if (Global.vDev)
            {
            }
            this.vGame = param1;
            this.vTab = new Array();
            var _loc_7:* = new Sparks_User("");
            var _loc_8:* = 0;
            while (_loc_8 < this.vGame.vTerrain.vGlobs.length)
            {
                
                _loc_2 = this.vGame.vTerrain.vGlobs[_loc_8];
                if (!_loc_2.isKilled)
                {
                    _loc_6 = false;
                }
                if (this.vGame.vReplay)
                {
                    if (_loc_2.vTeam == 1 || _loc_2.vTeam == 2)
                    {
                        _loc_6 = true;
                    }
                }
                else if (_loc_2.vTeam == 3 - this.vGame.vCurTeam)
                {
                    _loc_6 = true;
                }
                if (_loc_6)
                {
                    _loc_3 = new Object();
                    _loc_3.glob = _loc_2;
                    _loc_3.fixed = true;
                    _loc_3.dyna = new Dyna();
                    _loc_3.dyna.setPos(_loc_2.vPos.x, _loc_2.vPos.y);
                    this.vTab.push(_loc_3);
                    _loc_3 = new Object();
                    _loc_3.glob = _loc_2;
                    _loc_10 = _loc_2.vTeam;
                    if (GBL_Main.isReverse)
                    {
                        _loc_10 = 3 - _loc_10;
                    }
                    _loc_3.fixed = false;
                    _loc_5 = new Sparks_Char(_loc_7, "id", _loc_2.vName);
                    _loc_5.setForce(_loc_2.vAttributeForce);
                    _loc_5.setSpeed(_loc_2.vAttributeSpeed);
                    _loc_5.setVitality(_loc_2.vAttributeVitality);
                    _loc_5.vCategory = _loc_2.vCategory;
                    _loc_5.vCharId = _loc_2.vCharCode;
                    _loc_4 = new PersoForm(_loc_5, null, false, _loc_10, true, "", true);
                    _loc_4.x = _loc_2.vPos.x * 0.5;
                    _loc_4.y = _loc_2.vPos.y * 0.5;
                    addChild(_loc_4);
                    _loc_3.graf = _loc_4;
                    _loc_3.dyna = new Dyna();
                    _loc_3.dyna.setRadius(100);
                    _loc_3.dyna.setPos(_loc_4.x, _loc_4.y);
                    _loc_3.team = _loc_10;
                    this.vTab.push(_loc_3);
                }
                _loc_8++;
            }
            _loc_8 = 0;
            while (_loc_8 < this.vTab.length)
            {
                
                _loc_3 = this.vTab[_loc_8];
                if (_loc_3.fixed == false)
                {
                    _loc_9 = new CharInfoLine();
                    _loc_9.gotoAndStop((_loc_3.team + 1));
                    addChildAt(_loc_9, 0);
                    _loc_3.line = _loc_9;
                }
                _loc_8++;
            }
            _loc_8 = 0;
            while (_loc_8 < 100)
            {
                
                this.onFrame();
                _loc_8++;
            }
            if (GBL_Main.isReverse)
            {
                _loc_8 = 0;
                while (_loc_8 < this.vTab.length)
                {
                    
                    _loc_3 = this.vTab[_loc_8];
                    if (_loc_3.fixed == false)
                    {
                        _loc_3.graf.x = -_loc_3.graf.x;
                        _loc_3.graf.y = -_loc_3.graf.y;
                        _loc_3.line.x = -_loc_3.line.x;
                        _loc_3.line.y = -_loc_3.line.y;
                    }
                    _loc_8++;
                }
            }
            return;
        }// end function

        private function onFrame(event:Event = null) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            _loc_3 = 0;
            while (_loc_3 < this.vTab.length)
            {
                
                _loc_4 = _loc_3 + 1;
                while (_loc_4 < this.vTab.length)
                {
                    
                    this.vTab[_loc_3].dyna.onSmoothCollision(this.vTab[_loc_4].dyna);
                    _loc_4++;
                }
                _loc_3++;
            }
            var _loc_5:* = new Point(Global.vSize.x * 0.3, Global.vSize.y * 0.35);
            var _loc_6:* = 0;
            if (Global.v169e)
            {
                _loc_6 = 3 * GBL_Main.vDelta169;
            }
            _loc_3 = 0;
            while (_loc_3 < this.vTab.length)
            {
                
                _loc_2 = this.vTab[_loc_3];
                if (_loc_2.fixed == false)
                {
                    if (_loc_2.dyna.vPos.x < -_loc_5.x - _loc_6)
                    {
                        _loc_2.dyna.onTunnelCollision(1, 0, -100);
                    }
                    else if (_loc_2.dyna.vPos.x > _loc_5.x + _loc_6)
                    {
                        _loc_2.dyna.onTunnelCollision(-1, 0, -100);
                    }
                    if (_loc_2.dyna.vPos.y > _loc_5.y)
                    {
                        _loc_2.dyna.onTunnelCollision(0, -1, -100);
                    }
                    else if (_loc_2.dyna.vPos.y < -_loc_5.y)
                    {
                        _loc_2.dyna.onTunnelCollision(0, 1, -100);
                    }
                }
                _loc_3++;
            }
            var _loc_7:* = new Point(0, 0);
            _loc_3 = 0;
            while (_loc_3 < this.vTab.length)
            {
                
                _loc_2.dyna.update(0.004);
                if (_loc_2.fixed)
                {
                    _loc_2.dyna.vPos.x = _loc_2.glob.vPos.x;
                    _loc_2.dyna.vPos.y = _loc_2.glob.vPos.y;
                    _loc_2.dyna.vSpeed.x = 0;
                    _loc_2.dyna.vSpeed.y = 0;
                }
                else
                {
                    _loc_2.graf.x = _loc_2.dyna.vPos.x;
                    _loc_2.graf.y = _loc_2.dyna.vPos.y;
                    _loc_2.dyna.vSpeed.x = _loc_2.dyna.vSpeed.x * 0.1;
                    _loc_2.dyna.vSpeed.y = _loc_2.dyna.vSpeed.y * 0.1;
                }
                if (_loc_2.fixed == false)
                {
                    _loc_7.x = _loc_2.glob.vPos.x - _loc_2.graf.x;
                    _loc_7.y = _loc_2.glob.vPos.y - _loc_2.graf.y;
                    if (Global.vServer.vFakeGame)
                    {
                        _loc_7.x = _loc_7.x + 15;
                    }
                    _loc_2.line.rotation = 0;
                    _loc_2.line.width = _loc_7.length;
                    _loc_2.line.rotation = Math.atan2(_loc_7.y, _loc_7.x) * 180 / Math.PI;
                    _loc_2.line.x = (_loc_2.graf.x + _loc_2.glob.vPos.x) / 2;
                    _loc_2.line.y = (_loc_2.graf.y + _loc_2.glob.vPos.y) / 2;
                }
                _loc_3++;
            }
            return;
        }// end function

    }
}
