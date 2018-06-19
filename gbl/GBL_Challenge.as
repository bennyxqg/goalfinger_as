package gbl
{
    import flash.geom.*;

    public class GBL_Challenge extends Object
    {
        private var vGame:GBL_Main;
        private var vCallback:Function;
        public var vArrowHelp:Array;

        public function GBL_Challenge(param1:GBL_Main)
        {
            this.vArrowHelp = new Array();
            this.vGame = param1;
            return;
        }// end function

        private function getGlob(param1:int, param2:int) : GBL_Glob
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            while (_loc_4 < this.vGame.vTerrain.vGlobs.length)
            {
                
                if (this.vGame.vTerrain.vGlobs[_loc_4].vTeam == param1)
                {
                    _loc_3++;
                    if (_loc_3 == param2)
                    {
                        return this.vGame.vTerrain.vGlobs[_loc_4];
                    }
                }
                _loc_4++;
            }
            return null;
        }// end function

        public function setChallengeGlob(param1:int, param2:int, param3:int, param4:int, param5:int = 0, param6:int = 0) : void
        {
            var _loc_7:* = this.vGame.getGlob(param1, param2);
            if (this.vGame.getGlob(param1, param2) == null)
            {
                return;
            }
            _loc_7.setPosInit(new Point(param3, param4));
            _loc_7.vPerso.setVisible(true);
            var _loc_8:* = new Point(param5, param6);
            _loc_7.addForce(_loc_8);
            _loc_7.previewArrow(_loc_8);
            return;
        }// end function

        public function startChallenge(param1:Function) : void
        {
            this.vCallback = param1;
            this.vGame.vTerrain.resetRoundSpecific(this.noFun, true);
            this.vGame.vTerrain.vScoreOnTeamDead = true;
            if (this.vGame.vTerrain.getNbLeftInTeam(this.vGame.vTerrain.vGlobs, 1) == 0)
            {
                this.vGame.vTerrain.vScoreOnTeamDead = false;
            }
            if (this.vGame.vTerrain.getNbLeftInTeam(this.vGame.vTerrain.vGlobs, 2) == 0)
            {
                this.vGame.vTerrain.vScoreOnTeamDead = false;
            }
            this.vGame.askOrders(this.onOrdersPlayed);
            return;
        }// end function

        private function noFun() : void
        {
            return;
        }// end function

        private function onOrdersPlayed(param1:String) : void
        {
            var _loc_2:* = 0;
            while (_loc_2 < this.vArrowHelp.length)
            {
                
                this.vArrowHelp[_loc_2].visible = false;
                _loc_2++;
            }
            this.vArrowHelp.length = 0;
            this.vGame.startResolution(param1, this.afterResolution);
            return;
        }// end function

        private function afterResolution(param1:int) : void
        {
            this.vCallback.call(0, param1);
            return;
        }// end function

    }
}
