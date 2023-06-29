using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FloristManagement.Models
{
    public class CartViewModel
    {
        public Cart Cart { get; set; }
        public IEnumerable<CartItem> CartItems { get; set; }
    }
}