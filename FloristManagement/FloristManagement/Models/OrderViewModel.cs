using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FloristManagement.Models
{
    public class OrderViewModel
    {
        public int OrderID { get; set; }
        public string PhoneNumber { get; set; }
        public DateTime DeliveryDate { get; set; }
        public string DeliveryAddress { get; set; }
        public int PaymentID { get; set; }
        public string CreditCardNumber { get; set; }
        public int ExpiryMonth { get; set; }
        public int ExpiryYear { get; set; }

        public string CreditCardCVC { get; set; }
    }
}