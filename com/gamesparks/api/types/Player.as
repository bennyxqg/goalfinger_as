package com.gamesparks.api.types
{
    import __AS3__.vec.*;
    import com.gamesparks.*;

    public class Player extends GSData
    {

        public function Player(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getAchievements() : Vector.<String>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<String>;
            if (data.achievements != null)
            {
                _loc_2 = data.achievements;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(_loc_2[_loc_3]);
                }
            }
            return _loc_1;
        }// end function

        public function getDisplayName() : String
        {
            if (data.displayName != null)
            {
                return data.displayName;
            }
            return null;
        }// end function

        public function getExternalIds() : Object
        {
            if (data.externalIds != null)
            {
                return data.externalIds;
            }
            return null;
        }// end function

        public function getId() : String
        {
            if (data.id != null)
            {
                return data.id;
            }
            return null;
        }// end function

        public function getOnline() : Boolean
        {
            if (data.online != null)
            {
                return data.online;
            }
            return false;
        }// end function

        public function getScriptData() : Object
        {
            if (data.scriptData != null)
            {
                return data.scriptData;
            }
            return null;
        }// end function

        public function getVirtualGoods() : Vector.<String>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<String>;
            if (data.virtualGoods != null)
            {
                _loc_2 = data.virtualGoods;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(_loc_2[_loc_3]);
                }
            }
            return _loc_1;
        }// end function

    }
}
