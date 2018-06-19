package com.gamesparks.api.types
{
    import com.gamesparks.*;

    public class PlayerDetail extends GSData
    {

        public function PlayerDetail(param1:Object)
        {
            super(param1);
            return;
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

        public function getName() : String
        {
            if (data.name != null)
            {
                return data.name;
            }
            return null;
        }// end function

    }
}
