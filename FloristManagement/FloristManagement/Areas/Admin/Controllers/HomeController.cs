using FloristManagement.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Mvc;

namespace FloristManagement.Areas.Admin.Controllers
{
    public class HomeController : Controller
    {
        private FlowersEntities db = new FlowersEntities();

        public ActionResult ContactAdmin()
        {
            if (Session["AdminID"] == null )
            {
                return RedirectToAction("Login");
            }
            return View();
        }
        public ActionResult Login()
        {
            return View();
        }
        public ActionResult Signup()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Login(string Email, string Password)
        {
            if (Email == null || Password == null)
            {
                ViewBag.Message = "Username or Password can't be empty";
                return View();
            }
            var bcryptPassword = GetMD5(Password);
            var florist = db.Admins.FirstOrDefault(y => y.Email == Email && y.Password == bcryptPassword);
            if (florist != null)
            {
                Session["AdminID"] = florist.AdminID;
                Session["Username"] = florist.Username;
                Session["AdminRole"] = florist.Role;

                return Redirect("Index");

            }
            else
            {
                ViewBag.Message = "Account is not exited! please sign up! ";
                return View();
            }
        }

        public ActionResult Logout()
        {
            Session.Clear();//remove session
            return RedirectToAction("Login");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Signup(FloristManagement.Models.Admin admin)
        {
            if (ModelState.IsValid)
            {
                var check = db.Admins.SingleOrDefault(m => m.Email == admin.Email);
                if (check == null)
                {
                    admin.Password = GetMD5(admin.Password);
                    admin.Role = 2;
                    admin.ResetPasswordCode = "null";
                    db.Admins.Add(admin);
                    db.SaveChanges();
                    return RedirectToAction("Login");
                }
                else
                {
                    ViewBag.error = "Email already exists";
                    return View();
                }
            }

            return View();
        }
        public static string GetMD5(string str)
        {
            MD5 md5 = new MD5CryptoServiceProvider();
            byte[] fromData = Encoding.UTF8.GetBytes(str);
            byte[] targetData = md5.ComputeHash(fromData);
            string byte2String = null;

            for (int i = 0; i < targetData.Length; i++)
            {
                byte2String += targetData[i].ToString("x2");

            }
            return byte2String;
        }

        // GET: Admin/Home
        public ActionResult Index()
        {
            if (Session["Username"] == null)
            {
                return RedirectToAction("Login");
            }
            return View();
        }
    }
}