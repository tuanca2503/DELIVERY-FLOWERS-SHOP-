using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FloristManagement.Models
{
    public class BillViewModel
    {
        public string OrderNumber { get; set; } 
        public DateTime OrderDate { get; set; }   
        public string DeliveryAddress { get; set; }
        public string PhoneNumber { get; set; }
        public int PayMethod { get; set; }
        public decimal TotalPrice { get; set; }
        public List<OrderItemViewModel> OrderItems { get; set; }
    }
}