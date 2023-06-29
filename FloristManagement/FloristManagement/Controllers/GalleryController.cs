using PagedList;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FloristManagement.Models;

namespace FloristManagement.Controllers
{
    public class GalleryController : Controller
    {
        FlowersEntities db = new FlowersEntities();
        // GET: Gallery
        public ActionResult Index(int? page)
        {
            int pageSize = 4;
            int pageNumber = (page ?? 1);
            var galleries = db.Galleries.ToList();

            return View(galleries.ToPagedList(pageNumber, pageSize));
        }
    }
}