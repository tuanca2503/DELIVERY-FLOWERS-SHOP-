using FloristManagement.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;


namespace FloristManagement.Mapping
{
    public class CartMapping
    {
        private FlowersEntities db = new FlowersEntities();
        public List<Cart> Carts(HttpSessionStateBase session)
        {
            int userId = Convert.ToInt32(session["UserID"]);
            return db.Carts.Include(c => c.CartItems).Where( c => c.UserID  == userId && !c.IsCheckedOut).ToList();
        }
    }
}