package com.gamesparks.api.responses
{
    import com.gamesparks.*;

    public class GetUploadUrlResponse extends GSResponse
    {

        public function GetUploadUrlResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getUrl() : String
        {
            if (data.url != null)
            {
                return data.url;
            }
            return null;
        }// end function

    }
}
