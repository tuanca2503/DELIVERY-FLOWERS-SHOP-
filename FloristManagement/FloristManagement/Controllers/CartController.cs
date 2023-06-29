using FloristManagement.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.Entity;


namespace FloristManagement.Controllers
{
    public class CartController : Controller
    {
        private FlowersEntities db = new FlowersEntities();
        // GET: Cart
        public ActionResult Index()
        {
            // Get the current user ID
            int userId = Convert.ToInt32(Session["UserID"]);
            if (userId == 0 || userId == null)
            {
                return RedirectToAction("Login", "Home");
            }

            // Find the cart for the current user that hasn't been checked out
            Cart cart = db.Carts.SingleOrDefault(c => c.UserID == userId && !c.IsCheckedOut);

            // If the cart doesn't exist, create a new one
            if (cart == null)
            {
                cart = new Cart
                {
                    UserID = userId,
                    TotalPrice = 0,
                    IsCheckedOut = false,
                    DateCreated = DateTime.Now
                };
                db.Carts.Add(cart);
                db.SaveChanges();
            }
           IEnumerable<CartItem> cartItems = db.CartItems
                .Join(db.Bouquets, ci => ci.BouquetID, b => b.BouquetID, (ci, b) => new { CartItem = ci, Bouquet = b })
                .Where(cib => cib.CartItem.CartID == cart.CartID)
                .Select(cib => cib.CartItem);
            Session["Cart"] = cartItems.Count();
/*            ICollection<CartItem> cartItems = cart.CartItems;
            IQueryable<CartItem> cartItemsQuery = cartItems.AsQueryable()
                .Include(ci => ci.Bouquet);*/


            // Create a view model that includes the cart and the cart items
            CartViewModel viewModel = new CartViewModel
            {
                Cart = cart,
                CartItems = cartItems
            };

            // Return the view with the view model
            return View(viewModel);
        }


        public ActionResult AddToCart(int bouquetId, int quantity)
        {
            // Get the current user ID
            int userId = Convert.ToInt32(Session["UserID"]);
            if(userId == 0 || userId == null)
            {
                return RedirectToAction("Login", "Home");
            }

            // Find the cart for the current user that hasn't been checked out
            Cart cart = db.Carts.SingleOrDefault(c => c.UserID == userId && !c.IsCheckedOut);

            // If the cart doesn't exist, create a new one
            if (cart == null)
            {
                cart = new Cart
                {
                    UserID = userId,
                    TotalPrice = 0,
                    IsCheckedOut = false,
                    DateCreated = DateTime.Now,
                };
                db.Carts.Add(cart);
                db.SaveChanges();
            }

            // Check if the cart already contains the item
            CartItem cartItem = cart.CartItems.SingleOrDefault(ci => ci.BouquetID == bouquetId);

            if (cartItem == null)
            {
                // If the item doesn't exist, create a new cart item
                cartItem = new CartItem
                {
                    BouquetID = bouquetId,
                    Quantity = quantity,
                    CartID = cart.CartID
                };
                db.CartItems.Add(cartItem);
            }
            else
            {
                // If the item exists, update the quantity
                cartItem.Quantity += quantity;
            }

            // Update the total price of the cart
            cart.TotalPrice += quantity * db.Bouquets.Single(b => b.BouquetID == bouquetId).Price;

            // Save changes to the database
            db.SaveChanges();

            // Redirect to the cart view
            return RedirectToAction("Index");
        }

        [HttpPost]
        public ActionResult DeleteCartItem(int cartItemId)
        {
            var item = db.CartItems.Find(cartItemId);

            if (item == null)
            {
                return HttpNotFound();
            }

            db.CartItems.Remove(item);
            db.SaveChanges();

            return RedirectToAction("Index");
        }

        [HttpPost]
        public ActionResult UpdateCart(int cartItemId, int quantity)
        {
            if(quantity <=0 )
            {
                var item = db.CartItems.Find(cartItemId);
                db.CartItems.Remove(item);
                db.SaveChanges();

                return RedirectToAction("Index");
            }
            // Get the current user ID
            int userId = Convert.ToInt32(Session["UserID"]);

            // Find the cart for the current user that hasn't been checked out
            Cart cart = db.Carts.SingleOrDefault(c => c.UserID == userId && !c.IsCheckedOut);

            // Get the cart item
            CartItem cartItem = cart.CartItems.SingleOrDefault(ci => ci.CartItemID == cartItemId);

            // Update the quantity of the cart item
            cartItem.Quantity = quantity;

            // Update the total price of the cart
            cart.TotalPrice = cart.CartItems.Sum(ci => ci.Quantity * ci.Bouquet.Price);

            // Save changes to the database
            db.SaveChanges();

            // Redirect back to the cart view
            return RedirectToAction("Index");
        }

    }
}