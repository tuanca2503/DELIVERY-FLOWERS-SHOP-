﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FloristManagement.Models
{
    public class OrderItemViewModel
    {
        public string BouquetName { get; set; }
        public decimal Price { get; set; }
        public int Quantity { get; set; }
        public string Description { get; set; }
    }
}