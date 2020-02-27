using Microsoft.AspNetCore.Mvc;
using Microsoft.FeatureManagement;
using Microsoft.FeatureManagement.Mvc;

namespace app.Controllers
{
    public class BetaController : Controller
    {
        private readonly IFeatureManagerSnapshot _featureManager;

        public BetaController(IFeatureManagerSnapshot featureManager)
        {
            _featureManager = featureManager;
        }

        [FeatureGate(FeatureFlags.Beta)]
        public IActionResult Index()
        {
            return View();
        }
    }
}