using FloristManagement.Models;
using Stripe;
using Stripe.Checkout;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using System.Net;
using System.Net.Mail;
using System.IO;
using Stripe.Issuing;
using PagedList;
using Microsoft.Ajax.Utilities;

namespace FloristManagement.Controllers
{
    public class OrderController : Controller
    {
        FlowersEntities db = new FlowersEntities();
        // GET: Order
        public ActionResult Index()
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            if (userId == 0 || userId == null)
            {
                return RedirectToAction("Login", "Home");
            }

            var cart = db.Carts.Include(c => c.CartItems).SingleOrDefault(c => c.UserID == userId && !c.IsCheckedOut);
            if (cart != null)
            {
                ViewBag.Cart = cart;
                ViewBag.CartItems = cart.CartItems.ToList();
                ViewBag.TotalPrice = cart.TotalPrice;
            }
            ViewBag.PaymentID = new SelectList(db.Payments, "PaymentID", "PaymentMethod");
            return View();
        }


        public ActionResult Checkout(OrderViewModel orderVM)
        {
            // Get the current user's ID
            var userId = Convert.ToInt32(Session["UserID"]);
            if(userId == null || userId == 0)
            {
                return RedirectToAction("Login", "Home");
            }

            // Get the user's cart
            var user = db.Users.Find(userId);
            var cart = db.Carts.FirstOrDefault(c => c.UserID == userId && !c.IsCheckedOut);

            if (cart == null)
            {
                return RedirectToAction("Index", "Cart");
            }
            // Create a new order object and set its properties
            var order = new Order
            {
                OrderID = orderVM.OrderID,
                UserID = userId,
                PaymentID = orderVM.PaymentID,
                TotalPrice = cart.TotalPrice,
                PhonenNumber = orderVM.PhoneNumber,
                DeliveryDate = orderVM.DeliveryDate,
                DeliveryAddress = orderVM.DeliveryAddress,
                Status = "Pending"
            };
            // If the payment method is "Pay Later"
            if (orderVM.PaymentID == 1)
            {
                // Mark the cart as checked out
                cart.IsCheckedOut = true;
                db.Entry(cart).State = EntityState.Modified;

                // Save the changes to the database
                db.Orders.Add(order);
                db.SaveChanges();

                // Iterate through the cart items and create new order detail objects
                foreach (var cartItem in cart.CartItems)
                {
                    var orderDetail = new OrderDetail
                    {
                        OrderID = order.OrderID,
                        BouquetID = cartItem.BouquetID,
                        Quantity = cartItem.Quantity,
                    };

                    db.OrderDetails.Add(orderDetail);
                }
                db.SaveChanges();

                db.Entry(cart).State = EntityState.Modified;
                db.SaveChanges();

                // Redirect to the bill page
                return RedirectToAction("Bill", "Order", new { orderId = order.OrderID });
            }
            else if (orderVM.PaymentID == 2)
            {
                // Mark the cart as checked out
                cart.IsCheckedOut = true;
                db.Entry(cart).State = EntityState.Modified;

                // Save the changes to the database
                db.Orders.Add(order);
                db.SaveChanges();

                // Iterate through the cart items and create new order detail objects
                foreach (var cartItem in cart.CartItems)
                {
                    var orderDetail = new OrderDetail
                    {
                        OrderID = order.OrderID,
                        BouquetID = cartItem.BouquetID,
                        Quantity = cartItem.Quantity,
                    };

                    db.OrderDetails.Add(orderDetail);
                }
                db.SaveChanges();

                db.Entry(cart).State = EntityState.Modified;
                db.SaveChanges();

                StripeConfiguration.ApiKey = "sk_test_51N42ILFIzQFKVouPZ8A9vIb3UUxScC5cygpGVu1PiwhvbNwcg22lbHf0dIwOVgdoxGLc6wP49616yzLbcVrH4EN30027MYG6me";

                var orderItems = db.OrderDetails
                .Where(od => od.OrderID == order.OrderID)
                .Select(od => new OrderItemViewModel
                {
                    BouquetName = od.Bouquet.Name,
                    Price = od.Bouquet.Price,
                    Description = od.Bouquet.Description,
                    Quantity = od.Quantity, 
                })
                .ToList();

                var lineItems = new List<SessionLineItemOptions>();


                foreach (var item in orderItems)
                {
                    var lineItem = new SessionLineItemOptions
                    {
                        PriceData = new SessionLineItemPriceDataOptions
                        {
                            ProductData = new SessionLineItemPriceDataProductDataOptions
                            {
                                Name = item.BouquetName,
                                Description = item.Description
                            },
                            Currency = "usd",
                            UnitAmount = (long)item.Price * 100, // amount in cents
                        },
                        Quantity = item.Quantity
                    };

                    lineItems.Add(lineItem);
                }

                var successUrl = Url.Action("Bill", "Order", new {orderId = order.OrderID }, protocol: Request.Url.Scheme);

                var options = new SessionCreateOptions
                {
                    PaymentMethodTypes = new List<string> { "card" },
                    LineItems = lineItems,
                    Mode = "payment",
                    SuccessUrl = successUrl,
                    CancelUrl = "https://example.com/cancel",
                };

                var service = new SessionService();
                var session = service.Create(options);           

               // Redirect to the Stripe checkout page
                return Redirect(session.Url);
            }

            ViewBag.PaymentID = new SelectList(db.Payments, "PaymentID", "PaymentMethod", orderVM.PaymentID);
            return View(orderVM);
        }
        public ActionResult ViewBill(int? orderId)
        {
            // Get the current user's ID
            var userId = Convert.ToInt32(Session["UserID"]);
            if (userId == null || userId == 0)
            {
                return RedirectToAction("Login", "Home");
            }

            // Get the order ID from the session
            if(orderId == null || orderId == 0)
            {
                return Redirect("ListBill");
            }

            var user = db.Users.Find(userId);
            var order = db.Orders.Find(orderId);
            var orderItems = db.OrderDetails
                .Where(od => od.OrderID == orderId)
                .Select(od => new OrderItemViewModel
                {
                    BouquetName = od.Bouquet.Name,
                    Price = od.Bouquet.Price,
                    Description = od.Bouquet.Description,
                    Quantity = od.Quantity,
                })
                .ToList();

            var viewModel = new BillViewModel
            {
                OrderNumber = "ORDER-" + order.OrderID.ToString(),
                OrderDate = order.DeliveryDate,
                DeliveryAddress = order.DeliveryAddress,
                PhoneNumber = order.PhonenNumber,
                TotalPrice = order.TotalPrice,
                PayMethod = order.PaymentID,
                OrderItems = orderItems
            };

            return View(viewModel);
        }
        public ActionResult Bill (int OrderId)
        {
            Session["orderId"] = OrderId;
            // Get the current user's ID
            var userId = Convert.ToInt32(Session["UserID"]);
            if (userId == null || userId == 0)
            {
                return RedirectToAction("Login", "Home");
            }
            var user = db.Users.Find(userId);
            var order = db.Orders.Find(OrderId);
            var orderItems = db.OrderDetails
                .Where(od => od.OrderID == OrderId)
                .Select(od => new OrderItemViewModel
                {
                    BouquetName = od.Bouquet.Name,
                    Price = od.Bouquet.Price,
                    Description = od.Bouquet.Description,
                    Quantity = od.Quantity,
                })
                .ToList();

            var viewModel = new BillViewModel
            {
                OrderNumber = "ORDER-" + order.OrderID.ToString(),
                OrderDate = order.DeliveryDate,
                DeliveryAddress = order.DeliveryAddress,
                PhoneNumber = order.PhonenNumber,
                TotalPrice = order.TotalPrice,
                PayMethod = order.PaymentID,
                OrderItems = orderItems
            };
            // construct email message
            var fromEmail = new MailAddress("hoainampham2k@gmail.com", "Nam Phạm");
            var toAddress = new MailAddress(user.Email, user.Fullname);
            var fromEmailPassword = "16012000"; // Replace with actual password

            const string subject = "Your order details";
            var body = RenderRazorViewToString("Bill", viewModel);


            // Add more content to the email body here
            var smtp = new SmtpClient
            {
                Host = "smtp.gmail.com",
                Port = 587,
                EnableSsl = true,
                DeliveryMethod = SmtpDeliveryMethod.Network,
                UseDefaultCredentials = false,
                Credentials = new NetworkCredential(fromEmail.Address, "eqohsaalabdsdmpy")
            };

            using (var message = new MailMessage(fromEmail, toAddress)
            {
                Subject = subject,
                Body = (string)body,
                IsBodyHtml = true
            })
                smtp.Send(message);

            return View(viewModel);
        }
        public ActionResult ListBill(string searchTerm)
        {

            var userId = Convert.ToInt32(Session["UserID"]);
            if (userId == null || userId == 0)
            {
                return RedirectToAction("Login", "Home");
            }
            if(!searchTerm.IsNullOrWhiteSpace())
            {
                int search = Convert.ToInt32(searchTerm);
                var ordersFilter = db.Orders.Where(o => o.UserID == userId && search == o.OrderID).ToList();
                if(ordersFilter.Count == 0)
                {
                    ViewBag.Message = "No data";
                    Session["orderCount"] = 0;
                    return View(ordersFilter); // return an empty list to avoid null reference exceptions
                }
                Session["orderCount"] = ordersFilter.Count();
                return View(ordersFilter);

            }

            var orders = db.Orders.Where(o => o.UserID == userId).ToList();
            var orderCount = db.Orders.Where(o => o.UserID == userId).Count();
            Session["orderCount"] = orderCount;

            return View(orders);
        }
        private string RenderRazorViewToString(string viewName, object model)
        {
            ViewData.Model = model;
            using (var sw = new StringWriter())
            {
                var viewResult = ViewEngines.Engines.FindPartialView(ControllerContext, viewName);
                var viewContext = new ViewContext(ControllerContext, viewResult.View, ViewData, TempData, sw);
                viewResult.View.Render(viewContext, sw);
                viewResult.ViewEngine.ReleaseView(ControllerContext, viewResult.View);
                return sw.GetStringBuilder().ToString();
            }
        }

    }
   
}