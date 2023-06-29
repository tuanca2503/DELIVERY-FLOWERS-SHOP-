using FloristManagement.Models;
using PagedList;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FloristManagement.Mapping;

namespace FloristManagement.Controllers
{
    public class BouquetController : Controller
    {
        private FlowersEntities db = new FlowersEntities();
        private BouquetMappingcs bouquetMappingcs = new BouquetMappingcs();

        public ActionResult Index(string searchTerm, string occasionID, decimal? minPrice, decimal? maxPrice, int? page)
        {
            int pageSize = 8;
            int pageNumber = (page ?? 1);
            var bouquets = bouquetMappingcs.listOfBouquets(searchTerm, occasionID, minPrice, maxPrice);

            return View(bouquets.ToPagedList(pageNumber, pageSize));
        }

        // GET: Bouquet
        public ActionResult Detail(int? id)
        {
            Bouquet bouquet = db.Bouquets.Find(id);

            return View(bouquet);
        }

    }
}