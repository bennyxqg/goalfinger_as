package com.gamesparks.api.types
{
    import com.gamesparks.*;

    public class InvitableFriend extends GSData
    {

        public function InvitableFriend(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getDisplayName() : String
        {
            if (data.displayName != null)
            {
                return data.displayName;
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

        public function getProfilePic() : String
        {
            if (data.profilePic != null)
            {
                return data.profilePic;
            }
            return null;
        }// end function

    }
}
