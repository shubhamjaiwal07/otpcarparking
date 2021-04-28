using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;

namespace QR_Car_parking_service
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IService1" in both code and config file together.
    [ServiceContract]
    public interface IService1
    {

        [OperationContract]
        [WebGet(UriTemplate = "login/{email}/{pass}", ResponseFormat = WebMessageFormat.Json)]
        Cust_log login(string email, string pass);

        [OperationContract]
        [WebGet(UriTemplate = "getLog/{cid}", ResponseFormat = WebMessageFormat.Json)]
        List<transLog> getLog(string cid);

        [OperationContract]
        [WebGet(UriTemplate = "Getlist/{cust_id}/{area_id}", ResponseFormat = WebMessageFormat.Json)]
        List<Park_list> Getlist(string cust_id, string area_id);

        [OperationContract]
        [WebGet(UriTemplate = "GetPark_log/{slot_id}", ResponseFormat = WebMessageFormat.Json)]
        Slot_log GetPark_log(string slot_id);

        [OperationContract]
        [WebGet(UriTemplate = "Bookslot/{slot_id}/{cust_id}", ResponseFormat = WebMessageFormat.Json)]
        Book Bookslot(string slot_id, string cust_id);

        [OperationContract]
        [WebGet(UriTemplate = "fill_area/{ulat}/{ulon}/{temp}", ResponseFormat = WebMessageFormat.Json)]
        List<Fill_list> fill_area(string ulat, string ulon, string temp);

        [OperationContract]
        [WebGet(UriTemplate = "fill_area_by/{byType}", ResponseFormat = WebMessageFormat.Json)]
        List<Fill_list> fill_area_by(string byType);

        [OperationContract]
        [WebGet(UriTemplate = "BookingID/{cust_id}", ResponseFormat = WebMessageFormat.Json)]
        Booking_info BookingID(string cust_id);

        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "register", BodyStyle = WebMessageBodyStyle.Bare, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)]
        RegResp register(UserData udata);

        [OperationContract]
        [WebGet(UriTemplate = "parkingLotLogin/{mail}/{pass}", ResponseFormat = WebMessageFormat.Json)]
        respPLLog parkingLotLogin(string mail, string pass);

        [OperationContract]
        [WebGet(UriTemplate = "checkBookLog/{areaId}/{bookingId}", ResponseFormat = WebMessageFormat.Json)]
        respCheck checkBookLog(string areaId, string bookingId);

        [OperationContract]
        [WebGet(UriTemplate = "allocateSlot/{bookingId}", ResponseFormat = WebMessageFormat.Json)]
        respAllocate allocateSlot(string bookingId);

        //addBalance
        [OperationContract]
        [WebGet(UriTemplate = "addBalance/{cid}/{ac}/{bal}", ResponseFormat = WebMessageFormat.Json)]
        respAdd addBalance(string cid, string ac, string bal);

        [OperationContract]
        [WebGet(UriTemplate = "forgetPassword/{mail}", ResponseFormat = WebMessageFormat.Json)]
        respForget forgetPassword(string mail);

        [OperationContract]
        [WebGet(UriTemplate = "postFeed/{feed}/{mail}", ResponseFormat = WebMessageFormat.Json)]
        respFeed postFeed(string feed, string mail);


        //check otp
        [OperationContract]
        [WebGet(UriTemplate = "checkOtp/{phno}/{otp}", ResponseFormat = WebMessageFormat.Json)]
        respFeed checkOtp(string phno, string otp);

        //check rating give rating
        [OperationContract]
        [WebGet(UriTemplate = "checkRating/{areaId}/{userid}", ResponseFormat = WebMessageFormat.Json)]
        resp checkRating(string areaId, string userid);

        [OperationContract]
        [WebGet(UriTemplate = "giverating/{rating}/{areaId}/{userid}", ResponseFormat = WebMessageFormat.Json)]
        resp giverating(string rating, string areaId, string userid);

        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "forgot", ResponseFormat = WebMessageFormat.Json)]
        respReg forgotPassword(ForgotPass fp);

        [OperationContract]
        [WebGet(UriTemplate = "checkParkingOtp/{otp}", ResponseFormat = WebMessageFormat.Json)]
        respOtp checkParkingOtp(string otp);
        
    }


    // Use a data contract as illustrated in the sample below to add composite types to service operations.
    [DataContract]
    public class resp
    {
        [DataMember]
        public string rate { get; set; }
        [DataMember]
        public string msg { get; set; }
    }

    [DataContract]
    public class respFeed
    {
        [DataMember]
        public string msg
        {
            get;
            set;
        }
    }

    [DataContract]
    public class respForget
    {
        [DataMember]
        public string msg
        { get; set; }
    }

    [DataContract]
    public class respAdd
    {
        [DataMember]
        public string msg{get;set;}
        [DataMember]
        public string bal { get; set; }
    }

  [DataContract]
    public class transLog
    {
      [DataMember]
      public string bid
      { get; set; }
      [DataMember]
      public string date
      { get; set; }
      [DataMember]
      public string cost
      { get; set; }
      [DataMember]
      public string mallname
      { get; set; }
    }
    
    [DataContract]
    public class respAllocate
    {
       [DataMember]
       public string msg
       { get; set; }
    }
    
    [DataContract]
    public class respCheck
    {
        [DataMember]
        public string custId { get; set; }
        [DataMember]
        public string custName { get; set; }
        [DataMember]
        public string slotId { get; set; }

    }
    
    [DataContract]
    public class respPLLog
    {
        [DataMember]
        public string areaId
        { get; set; }
        [DataMember]
        public string areaName
        { get; set; }
    }

    [DataContract]
    public class UserData
    {
        [DataMember(Name = "Fname")]
        public string Fname { get; set; }
        [DataMember(Name = "Lname")]
        public string Lname { get; set; }
        [DataMember(Name = "Addr")]
        public string Addr { get; set; }
        [DataMember(Name = "Ph")]
        public string Ph { get; set; }
        [DataMember(Name = "Email")]
        public string Email { get; set; }
        [DataMember(Name = "Pass")]
        public string Pass { get; set; }

    }

    [DataContract]
    public class RegResp
    {
        [DataMember]
        public string msg
        {
            get;
            set;
        }
        [DataMember]
        public string otp { get; set; }
    }

    [DataContract]
    public class Booking_info
    {
        [DataMember]
        public string booking_id
        {
            get;
            set;
        }
        [DataMember]
        public string path
        { get; set; }

        [DataMember]
        public int otp { get; set; }

        [DataMember]
        public string message { get; set; }
    }

    [DataContract]
    public class Cust_log
    {
        [DataMember]
        public string cust_id
        {
            get;
            set;
        }
        [DataMember]
        public string bal
        { get; set; }
    }

    [DataContract]
    public class Park_list
    {
        [DataMember]
        public string slot_id
        {
            get;
            set;
        }

        [DataMember]
        public string slot_no
        {
            get;
            set;
        }
        [DataMember]
        public string slot_url
        { get; set; }
    }

    [DataContract]
    public class Slot_log
    {
        [DataMember]
        public string msg
        {
            get;
            set;
        }
        [DataMember]
        public string slot_no
        {
            get;
            set;
        }
        [DataMember]
        public string area_name
        {
            get;
            set;
        }

    }

    [DataContract]
    public class Book
    {
        [DataMember]
        public string msg2
        {
            get;
            set;
        }
    }

    [DataContract]
    public class Fill_list
    {
        [DataMember]
        public string a_name
        {
            get;
            set;
        }
        [DataMember]
        public string lat
        { get; set; }
        [DataMember]
        public string lon
        { get; set; }

        [DataMember]
        public double InformationDistance { get; set; }
        [DataMember]
        public string byValue { get; set; }
    }

    public class ForgotPass
    {
        [DataMember]
        public string email { get; set; }
    }

    [DataContract]
    public class respReg
    {
        [DataMember]
        public string msg { get; set; }
    }

    [DataContract]
    public class respOtp
    {
        [DataMember]
        public string booking_id { get; set; }

        [DataMember]
        public string msg { get; set; }
    }


}
