package gbl
{
    import __AS3__.vec.*;

    public class GBL_Team extends Object
    {
        public var vSide:int = -1;
        public var vDesc:String;
        public var vGlobs:Vector.<GBL_Glob>;
        public var vShirtCode:String;
        public var vBoosters:Array;

        public function GBL_Team()
        {
            this.vGlobs = new Vector.<GBL_Glob>;
            return;
        }// end function

        public function parseTeam(param1:int, param2:String) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_7:* = 0;
            this.vDesc = param2;
            var _loc_5:* = JSON.parse(this.vDesc);
            this.vShirtCode = _loc_5.shirt;
            if (this.vShirtCode == null)
            {
                return;
            }
            this.vBoosters = new Array();
            if (_loc_5.boosters != null)
            {
                _loc_7 = 0;
                while (_loc_7 < _loc_5.boosters.length)
                {
                    
                    this.vBoosters.push({type:_loc_5.boosters[_loc_7], used:0});
                    _loc_7++;
                }
            }
            var _loc_6:* = 1;
            while (_loc_6 <= 3)
            {
                
                _loc_3 = _loc_5["player" + _loc_6];
                _loc_4 = new GBL_Glob(param1, _loc_3.force, _loc_3.speed, _loc_3.vitality);
                _loc_4.vCategory = _loc_3.category;
                _loc_4.vCharCode = _loc_3.code;
                _loc_4.vShirtCode = this.vShirtCode;
                _loc_4.vName = _loc_3.name;
                _loc_4.vPosition = _loc_6;
                _loc_4.vEnergyStats = new Object();
                _loc_4.vEnergyStats.orders = new Array();
                _loc_4.vEnergyStats.ordersTotal = 0;
                _loc_4.vEnergyStats.ordersNorm = 0;
                _loc_4.vEnergyStats.nbKos = 0;
                _loc_4.vEnergyStats.nbKilled = 0;
                this.vGlobs.push(_loc_4);
                _loc_6++;
            }
            return;
        }// end function

        public function setShirtCode(param1:String) : void
        {
            this.vShirtCode = param1;
            var _loc_2:* = 0;
            while (_loc_2 < this.vGlobs.length)
            {
                
                this.vGlobs[_loc_2].vShirtCode = this.vShirtCode;
                _loc_2++;
            }
            return;
        }// end function

    }
}
